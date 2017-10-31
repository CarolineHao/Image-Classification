#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Fan Gong
### Project 3
### ADS Fall 2016


##### GBM #####

train_gbm = function(dat_train){
  
  ###  dat_train: processed features from images also contains label
  
  library(gbm)
  
  start_time_gbm = Sys.time() # Model Start Time
  
  gbm.fit = gbm(Label~., 
                data = df_train,
                n.trees = 400,
                distribution = "multinomial",
                interaction.depth = 3, 
                shrinkage = 0.2,
                n.minobsinnode = 30,
                verbose=FALSE)
  end_time_gbm = Sys.time() # Model End time
  gbm_time = end_time_gbm - start_time_gbm #Total Running Time
  
  
  return(list(fit = gbm.fit, time = gbm_time))
}




##### SVM #####

train_svm = function(dat_train){

  ###  dat_train: processed features from images also contains label

  library(e1071)
  
  fitControl = trainControl(method = 'cv', number = 2)
  
  svmGrid = expand.grid(C = 1)
  
  start_time_svm = Sys.time() # Model Start Time
  svm.fit = train(Label~., 
                  data = df_train,
                  method = "svmLinear",
                  preProc = c('center', 'scale'),
                  tuneGrid = svmGrid,
                  trControl = fitControl)
  end_time_svm = Sys.time() # Model End time
  
  svm_time = end_time_svm - start_time_svm #Total Running Time
  
  
  return(list(fit = svm.fit, time = svm_time))
  
}


##### Logistic Regression #####

train_lr = function(dat_train){
  
  ###  dat_train: processed features from images also contains label
  
  library(nnet)
  
  start_time_lr = Sys.time() # Model Start Time
  lr.fit = multinom(Label~., 
                    data = df_train, 
                    MaxNWts=16000)
  end_time_lr = Sys.time() # Model End time
  end_time_lr - start_time_lr
  
  lr_time = end_time_lr - start_time_lr #Total Running Time
  
  
  return(list(fit = lr.fit, time = lr_time))
}


##### Random Forest #####

train_rf = function(dat_train){
  
  ###  dat_train: processed features from images also contains label
  
  fitControl = trainControl(method = 'cv', number = 2)
  
  rfGrid = expand.grid(mtry = floor(sqrt(ncol(df_train)) * 0.97) : floor(sqrt(ncol(df_train) * 1.03)))
  
  start_time_rf = Sys.time() # Model Start Time 
  rf.fit = train(Label~., 
                 data = df_train,
                 method = "rf", 
                 trControl = fitControl,
                 ntree = 500, #number of trees to grow
                 tuneGrid = rfGrid) # Parameter Tuning
  end_time_rf = Sys.time() # Model End time
  end_time_rf - start_time_rf
  
  rf_time = end_time_rf - start_time_rf #Total Running Time
  
  return(list(fit = rf.fit, time = rf_time))
}





