# Clean variables
rm(list = ls())

source(file="./config.R")
source(file="./partitioning.R")
source(file="./predicting.R")

##########################################################################
# Loads data
##########################################################################
covertype <- read.arff("../data/covertype.arff")
kddcup <- read.arff("../data/kddcup99.arff")
pokerhand <- read.arff("../data/pokerhand.arff") 
protein <- read.arff("../data/protein.arff")

datasets <- c(covertype, kddcup, pokerhand, protein)
datasets.names <- c("covertype", "kddcup", "pokerhand", "protein")


partitions <- lapply(1:length(datasets), function(i) {
  make.partition(datasets[i], datasets.names[i])
})


J48.predictions <- get.predictions(J48, Weka_control())
# Random Forest with 50 trees
RF.predictions <- get.predictions(RF, Weka_control(I=50))

#save(file="J48pred.RData", list = c('J48.predictions'))
#save(file="RFpred.RData", list = c('RF.predictions'))
load(file="J48pred.RData")
load(file="RFpred.RData")


RF.class  <- get.classes(RF.predictions)
J48.class <- get.classes(J48.predictions) 


J48.accuracies <- get.accuracies(J48.class)
RF.accuracies  <- get.accuracies(RF.class)


J48.simple.vote.preds <- prediction.simple.vote( J48.predictions, J48.accuracies )
J48.simple.vote.acc <-  get.accuracies(J48.simple.vote.preds)

RF.simple.vote.preds <- prediction.simple.vote( RF.predictions, RF.accuracies )
RF.simple.vote.acc <-  get.accuracies(RF.simple.vote.preds)


#save(file="temp.RData", list=c('J48.class', 'J48.accuracies',
#                               'RF.class', 'RF.accuracies',
#                               'J48.simple.vote.preds', 'J48.simple.vote.acc',
#                               'RF.simple.vote.preds', 'RF.simple.vote.acc'))
load(file="temp.RData")
