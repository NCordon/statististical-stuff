# Clean variables
rm(list = ls())

# Memory dedicated to java
options( java.parameters = "-Xmx8g")

# My random seed
my.seed <- 12345678
set.seed(my.seed)

##########################################################################
# List of packages to load
##########################################################################
pkgs = c("RWeka", "caret")

load.my.packages <- function(){
  to.install <- pkgs[ ! pkgs %in% installed.packages() ]
  
  if ( length(to.install) > 0 )
    install.packages( to.install, dependencies = TRUE )
  
  sapply(pkgs, require, character.only=TRUE)
}

load.my.packages()


##########################################################################
# Random forest of Weka
##########################################################################
random.forest <- make_Weka_classifier("weka.classifiers.trees.RandomForest")

##########################################################################
# Loads data
##########################################################################
covertype <- read.arff("../data/covertype.arff")
kddcup <- read.arff("../data/kddcup99.arff")
pokerhand <- read.arff("../data/pokerhand.arff") 
protein <- read.arff("../data/protein.arff")

datasets <- c(covertype, kddcup, pokerhand, protein)
datasets.names <- c("covertype", "kddcup", "pokerhand", "protein")

##########################################################################
# Partition generation
#   Returns hold-out of 0.2 test, 0.8 train
#   The train partition is divided in 5 folds of 20% size of the train
#   The result is written into a .RData file
##########################################################################

make.partition <- function(data, name){
  train.index <- createDataPartition(data$class, p = 0.8, list = F, times = 1)
  train <- data[ train.index, ]
  test  <- data[-train.index, ]
  
  folds <- createFolds(train$class, 5)

  # Returns map of folds to the original data
  partition <- list(
    train = lapply(folds, function(selected){
      train[selected, ]
    }),
    test = test)

  save (list = c('partition'), file = paste(name,".RData", sep = ""))
}

lapply(1:length(datasets), function(i) { make.partition(datasets[i], datasets.names[i]) })
