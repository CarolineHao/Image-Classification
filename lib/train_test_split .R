#-----------------------------------------------------------------------------#
# This R file aims to find a balanced partition of training and testing data  #
# 'df_train' is the training data (80% or 64%)                                #
# 'df_test' is the testing data (20%)                                         #
# 'df_cv' is the cross-validation data (16%)                                  #
#-----------------------------------------------------------------------------#
library(caret)
#Load the Data
df = read.csv('/Users/gongfan/Desktop/training_set/sift_train.csv', header = T)
label = read.csv('/Users/gongfan/Desktop/training_set/label_train.csv', header = T)
df_complete = cbind(label, df)

#Delete the Useless Column and Rename the Column
df_complete = df_complete[, -3]
colnames(df_complete)[1:2] = c('Image_Number', 'Label')

#Make a Balanced Partition
df_complete$Label = as.factor(df_complete$Label)
dpart = createDataPartition(df_complete$Label, p = 0.2, list = F)

df_test = df_complete[dpart, ]
df_train = df_complete[-dpart, ]

#Check whether it is balanced or not
table(df_test$Label)
table(df_train$Label)

####Validation Set (Ignore if you will not use)
dpart_validation = createDataPartition(df_train$Label, p = 0.2, list = F)
df_train = df_train[-dpart_validation, ]
df_cv = df_train[dpart_validation, ]
df_test = df_test
