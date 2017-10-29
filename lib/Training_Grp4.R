################################################################################
#                            Training Part                                     #
#                                                                              #
# Contians Random Forest; Logistic Regression; Support Vector Machine and      #
# Gradient Boosting Machine and Neural Networks.                               #
#                                                                              #
################################################################################

### Package Loading

library(caret)
library(gbm)
library(e1071)
library(randomForest)
library(nnet)
  
  
### Create a balanced df_train and test data

df = read.csv('/Users/gongfan/Desktop/GR5243/training_set/sift_train.csv', header = T)
label = read.csv('/Users/gongfan/Desktop/GR5243/training_set/label_train.csv', header = T)
  
set.seed(42)
df_complete = cbind(label, df) # Combine the dataframe and label
df_complete = df_complete[, -c(1,3)] # Delete the Useless Column 
colnames(df_complete)[1] = c('Label') # Rename the Column
df_complete$Label = as.factor(df_complete$Label) # Make the Label as factor
dpart = createDataPartition(df_complete$Label, p = 0.2, list = F) #Balanced Partition
df_test = df_complete[dpart, ] # test set
df_train = df_complete[-dpart, ] # training set
  
### Model Pre-Processing
  
fitControl = trainControl(method = 'cv', number = 2) # Use 2-fold Validation
  
  
### Random Forest Model 
  
rfGrid = expand.grid(mtry = floor(sqrt(ncol(df_train)) * 0.97) : floor(sqrt(ncol(df_train) * 1.03)))
  
start_time_rf = Sys.time() # Model Start Time 
rf.fit = train(Label~., 
                 data = df_train,
                 method = "rf", 
                 trControl = fitControl,
                 ntree = 1000,
                 tuneGrid = rfGrid) # Parameter Tuning
end_time_rf = Sys.time() # Model End time
end_time_rf - start_time_rf

rf_time = end_time_rf - start_time_rf #Total Running Time
  
train_rf_error = mean(predict(rf.fit, df_train) != df_train$Label)
test_rf_error = mean(predict(rf.fit, df_test) != df_test$Label)
  
### Logistic Regression Model
  
start_time_lr = Sys.time() # Model Start Time
lr.fit = multinom(Label~., data = df_train, MaxNWts=16000)
end_time_lr = Sys.time() # Model End time
end_time_lr - start_time_lr

lr_time = end_time_lr - start_time_lr #Total Running Time
  
train_lr_error = mean(predict(lr.fit, df_train) != df_train$Label)
test_lr_error = mean(predict(lr.fit, df_test) != df_test$Label)
  
### SVM
  
#svmGrid = expand.grid(sigma= 2^c(-25, -15, -5), C= 2^c(0:2))
svmGrid = expand.grid(sigma= 10^(-4:-1), C= 10^(-3:1))
  
start_time_svm = Sys.time() # Model Start Time
svm.fit = train(Label~., 
                 data = df_train,
                 method = "svmRadial", 
                 trControl = fitControl, 
                 tuneGrid = svmGrid)
end_time_svm = Sys.time() # Model End time
end_time_svm - start_time_svm

svm_time = end_time_svm - start_time_svm #Total Running Time
  
train_svm_error = mean(predict(svm.fit, df_train) != df_train$Label)
test_svm_error = mean(predict(svm.fit, df_test) != df_test$Label)
  
  
### GBM 

gbmGrid = expand.grid(interaction.depth = c(1:4),
                        n.trees = c(1:10),
                        shrinkage = 0.1,
                        n.minobsinnode = 20)
  
start_time_gbm = Sys.time() # Model Start Time
gbm.fit = train(Label~., 
                data = df_train,
                method = "gbm", 
                trControl = fitControl, 
                verbose = FALSE,
                bag.fraction = 0.5, 
                tuneGrid = gbmGrid) #parameter tuning
end_time_gbm = Sys.time() # Model End time

gbm_time = end_time_gbm - start_time_gbm #Total Running Time

train_gbm_error = mean(predict(gbm.fit, df_train) != df_train$Label)
test_gbm_error = mean(predict(gbm.fit, df_test) != df_test$Label)

### Neural Networks
 

 
 
### Result Table (Error and Running Time)

df_result = data.frame(Model = c('Random Forest', 'Logistic Regression', 
                                 'SVM', 'GBM', 'Neural Networks'), 
                       Train_Error = c(train_rf_error, train_lr_error, train_svm_error, train_gbm_error, 1), 
                       Test_Error = c(test_rf_error, train_lr_error, test_svm_error, test_gbm_error, 1), 
                       Running_Time = c(rf_time, lr_time, svm_time, gbm_time, 1))
  
  
df_result
  
 
  
  
  
 
