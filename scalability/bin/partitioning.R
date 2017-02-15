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
