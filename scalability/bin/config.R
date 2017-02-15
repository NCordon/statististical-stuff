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
RF <- make_Weka_classifier("weka.classifiers.trees.RandomForest")
