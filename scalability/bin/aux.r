# Clean variables
rm(list = ls())

# Memory dedicated to java
options(java.parameters = "-Xmx5g")

# My random seed
set.seed(12345678)

##########################################################################
# List of packages to load
##########################################################################
pkgs = c("foreign", "RWeka", "caret")

load.my.packages <- function(){
  to.install <- pkgs[ ! pkgs %in% installed.packages() ]
  
  if ( length(to.install) > 0 )
    install.packages( to.install, dependencies = TRUE )
  
  sapply(pkgs, require, character.only=TRUE)
}

load.my.packages()


##########################################################################
# Loads data
##########################################################################
covertype <- read.arff("../data/covertype.arff")
kddcup <- read.arff("../data/kddcup99.arff")
pokerhand <- read.arff("../data/pokerhand.arff") 
protein <- read.arff("../data/protein.arff")

datasets <- list(covertype, kddcup, pokerhand, protein)
datasets.names <- c("covertype", "kddcup", "pokerhand", "protein")

data.file <- "scalability.RData"
#load(file = data.file)
save.image(file = data.file, safe=TRUE)   


##########################################################################
# Partition generation
#   Returns hold-out of 0.2 test, 0.8 train
#   The train partition is divided in 5 folds of 20% size of the train
##########################################################################

make.partition <- function(data){
  train.index <- createDataPartition(data$class, p = 0.8, list = F, times = 1)
  train <- data[ train.index, ]
  test  <- data[-train.index, ]
  
  folds <- createFolds(train$class, 5)

  # Returns map of folds to the original data
  list(
    train = lapply(folds, function(selected){
      train[selected, ]
    }),
    test = test)
}

particion <- make.partition(covertype)

# Comprobación de que el muestreo es estratificado
#length(which(particion$train[[1]][,"class"]==3)) / length(particion$train[[1]][,1])

## cross.eval <- function(algorithm){
##   n.eval <- length(seedd)
##   all.results <- list()
##   mean.results <- list()
  
##   with.decimals <- function(v){ format(v, nsmall=5) }
  
  
##   gather.results <- function(train, test, result){
##     n.var <- length(colnames(train))-1
    
##     t.ini <- proc.time()[3]
##     mask <- algorithm(train)
##     t.fin <- proc.time()[3]
##     result$tasa.test <- c( result$tasa.test, tasa.clas(test,mask) )
##     result$tasa.train <- c( result$tasa.train, tasa.clas(train,mask) )
##     result$tasa.red <- c( result$tasa.red, (n.var - sum(mask==1))/n.var )
##     result$t.exec <- c( result$t.exec, unname(t.fin - t.ini) )
    
##     result
##   }
  
##   for (d in 1:length(datasets)){
##     x <- datasets[[d]]
##     result <- list(tasa.test = NULL, tasa.train = NULL, tasa.red = NULL, t.exec = NULL)
    
##     cat("Procesando dataset", datasets.names[d], "\n")
    
##     class.split <- split(x, x$class)
    
##     for (i in 1:n.eval){
##       set.seed(semilla[i])
      
##       # Hacemos las particiones de entrenamiento y prueba
##       partition <- lapply(class.split, make.partition, per=0.5 )
##       train <- lapply (partition, function(x){ x$train } )
##       train <- rbindlist(train)
##       test <- lapply (partition, function(x){ x$test } )
##       test <- rbindlist(test)
      
##       # Primero usando la mascara dada por el train
##       result <- gather.results(train, test, result)
##       # Despues usando la mascara dada por el test
##       result <- gather.results(test, train, result)
##     }
    
##     result <- data.frame(result)
##     result.mean <- apply(result, 2, mean) 
    
##     all.results[[d]] <- with.decimals(result)
##     mean.results[[d]] <- result.mean
##   }
  
##   names(all.results) <- datasets.names
##   names(mean.results) <- paste(datasets.names, ".media", sep="")
##   # Salida
##   append(all.results, mean.results)
## } 
