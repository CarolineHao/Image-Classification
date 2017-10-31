source("../lib/train_v1.R")
source("../lib/test_v1.R")
library(caret)
library(gbm)
library(e1071)
library(randomForest)
library(nnet)

df = read.csv('../data/hog812.csv', header = F)[-1,-1]
label = read.csv('../data/label_train.csv', header = T)

label = data.frame(label[,-1])
colnames(label) = c('Label') # Rename the Column

set.seed(42)
df_complete = cbind(label, df) # Combine the dataframe and label
df_complete$Label = as.factor(df_complete$Label) # Make the Label as factor
dpart = createDataPartition(df_complete$Label, p = 0.2, list = F) #Balanced Partition
df_test = df_complete[dpart, ] # test set
df_train = df_complete[-dpart, ] # training set


### lbp results
train_lbp = list(lr, gbm, rf, svm, df_result)
save(train_lbp, file="../output/train_lbp.RData")
load("../output/train_lbp.RData")


### lr
lr = train_lr(df_train)

train_lr_accuracy = mean(test(lr,df_train) == df_train$Label)
test_lr_accuracy = mean(test(lr,df_test) == df_test$Label)
lr_time = lr$time


### GBM

gbm = train_gbm(df_train)

train_gbm_accuracy = mean(test_gbm(gbm,df_train) == df_train$Label)
test_gbm_accuracy = mean(test_gbm(gbm,df_test) == df_test$Label)
gbm_time = gbm$time


### Random Forest
rf = train_rf(df_train)

train_rf_accuracy = mean(test(rf,df_train) == df_train$Label)
test_rf_accuracy = mean(test(rf,df_test) == df_test$Label)
rf_time = rf$time

### SVM
svm = train_svm(df_train)

train_svm_accuracy = mean(test(svm,df_train) == df_train$Label)
test_svm_accuracy = mean(test(svm,df_test) == df_test$Label)
svm_time = svm$time

### Result Table
df_result = data.frame(Model = c('Random Forest', 'Logistic Regression', 
                                 'SVM', 'GBM', 'Neural Networks'), 
                       Train_accuracy = c(train_rf_accuracy, train_lr_accuracy, 
                                          train_svm_accuracy, train_gbm_accuracy, 1), 
                       Test_accuracy = c(test_rf_accuracy, train_lr_accuracy, 
                                         test_svm_accuracy, test_gbm_accuracy, 1), 
                       Running_Time = c(rf_time, lr_time, svm_time, gbm_time, 1))





