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

