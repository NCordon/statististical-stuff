# Clean variables
rm(list = ls())

source(file="./config.R")
source(file="./partitioning.R")
source(file="./predicting.R")

##########################################################################
# Loads data
##########################################################################

# ---- partition.gen ----
covertype <- read.arff("../data/covertype.arff")
kddcup <- read.arff("../data/kddcup99.arff")
protein <- read.arff("../data/protein.arff")
pokerhand <- read.arff("../data/pokerhand.arff") 


datasets <- c(covertype, kddcup, protein, pokerhand)
datasets.names <- c("covertype", "kddcup", "protein", "pokerhand")


partitions <- lapply(1:length(datasets), function(i) {
  make.partition(datasets[i], datasets.names[i])
})


# ---- prediction.gen ----
J48.predictions <- get.predictions(J48, Weka_control())
# Random Forest with 50 trees
RF.predictions <- get.predictions(RF, Weka_control(I=50))

# ---- save.predictions ----
#save(file="J48pred.RData", list = c('J48.predictions'))
#save(file="RFpred.RData", list = c('RF.predictions'))
load(file="J48pred.RData")
load(file="RFpred.RData")


# ---- accuracy.gen ----
RF.class  <- get.classes(RF.predictions)
J48.class <- get.classes(J48.predictions) 


J48.accuracies <- get.accuracies(J48.class)
RF.accuracies  <- get.accuracies(RF.class)

# ---- ponderation.gen ----
J48.simple.vote.preds <- vote.prediction(J48.predictions, J48.accuracies, ponderate=F)
J48.simple.vote.acc <-  get.accuracies(J48.simple.vote.preds)

RF.simple.vote.preds <- vote.prediction(RF.predictions, RF.accuracies, ponderate=F)
RF.simple.vote.acc <-  get.accuracies(RF.simple.vote.preds)

J48.ponderate.vote.preds <- vote.prediction(J48.predictions, J48.accuracies, ponderate=T)
J48.ponderate.vote.acc <-  get.accuracies(J48.ponderate.vote.preds)

RF.ponderate.vote.preds <- vote.prediction(RF.predictions, RF.accuracies, ponderate=T)
RF.ponderate.vote.acc <-  get.accuracies(RF.ponderate.vote.preds)


# ---- save.ponderations ----
## save(file="temp.RData", list=c('J48.class', 'J48.accuracies',
##                                'RF.class', 'RF.accuracies',
##                                'J48.simple.vote.preds', 'J48.simple.vote.acc',
##                                'RF.simple.vote.preds', 'RF.simple.vote.acc',
##                                'J48.ponderate.vote.preds', 'J48.ponderate.vote.acc',
##                                'RF.ponderate.vote.preds', 'RF.ponderate.vote.acc'))
load(file="temp.RData")
