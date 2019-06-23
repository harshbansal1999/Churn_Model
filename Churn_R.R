data=read.csv("Churn_1.csv")
data$customerID=NULL
library(caTools)
split=sample.split(data$Churn,SplitRatio = 0.75)
train=subset(data,split==T)
test=subset(data,split==F)
train[,c(6,19,20)]=scale(train[,c(6,19,20)])
test[,c(6,19,20)]=scale(test[,c(6,19,20)])

#install.packages("h2o")
library(h2o)
h2o.init(nthreads = -1)
clf=h2o.deeplearning(y="Churn",training_frame = as.h2o(train),activation = "Rectifier",
                     hidden=c(8,8),epochs = 100,train_samples_per_iteration = -2)
prob_pred=h2o.predict(clf,newdata = as.h2o(test[-21]))
y_pred=(prob_pred>0.5)
y_pred=as.vector(y_pred)
cm=table(test[,21],y_pred)
cm
acc=(cm[1,1]+cm[2,2])/(cm[1,1]+cm[2,2]+cm[1,2]+cm[2,1])
acc
write.csv(y_pred,"Churn_pred.csv")
