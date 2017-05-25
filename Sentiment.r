library(coreNLP)
initCoreNLP()
args<-commandArgs(TRUE)
review<-args[1]
review<-annotateString(review)
score<-getSentiment(review)
score$sentiment