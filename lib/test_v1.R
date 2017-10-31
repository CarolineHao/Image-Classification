######################################################
### Fit the classification model with testing data ###
######################################################

### Author: Fan Gong
### Project 3
### ADS Fall 2016


##### Testing Function For GBM Model #####

test_gbm = function(fit_train, dat_test){
  
  ###  fit_train the fitted gradient boosting model
  ###  dat_test  processed features from testing images 
  
  
  ### load libraries
  library("gbm")
  
  pred = predict(fit_train$fit, newdata=dat_test, 
                 n.trees = 400, type="response")
  
  gbm_prob = predict(fit_train$fit, n.trees = 400, newdat =  dat_test, type="response")
  gbm_class = apply(gbm_prob, 1, which.max) - 1
  
  
  return(gbm_class)
}




##### Test Function For All Other Classification Model #####
test = function(fit_train, dat_test){
 
  ###  fit_train: the fitted classification model using training data except GBM
  ###  dat_test:  processed features from testing images 
 
  
  pred = predict(fit_train$fit, newdata = dat_test)
  
  return(pred)
}






