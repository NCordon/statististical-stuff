get.predictions <- function(algorithm, param){
  result <- lapply(1:length(datasets.names), function(n.index){
    name <- datasets.names[n.index]
    load(file=paste(name, ".RData", sep="")) 
  
    current.pred <- lapply(1:5, function(i){
      train.model <- algorithm(class ~ ., data = partition$train[[i]], control = param)
      predict(train.model, newdata = partition$test, type = c("probability"))
    })

    # Force R's garbage collector
    gc()
    current.pred
  })

  names(result) <- datasets.names
  result
}


### Get class with more confidence for each dataset
get.classes <- function(predictions){
  lapply(predictions, function(set.pred){
    columns <- colnames(set.pred[[1]])
  
    lapply(set.pred, function(prob.matrix){
      apply(prob.matrix, 1, function(x){ columns[ which.max(x) ] })
    })
  })
}




acc.rate <- function(true, calculated){
  length( which(calculated == true) ) / length(calculated)
}

get.accuracies <- function(algorithm.class){
  result <- lapply( 1:length(datasets.names), function(n.index){ 
    name <- datasets.names[ n.index ]
    load(file=paste(name, ".RData", sep="")) 

    true.class <- partition$test$class

    ifelse (length(algorithm.class[n.index]) > 1, 
            sapply( 1:length(algorithm.class[[n.index]]), function(i){
              calculated.class <- algorithm.class[[ n.index ]][[ i ]]
              acc.rate( true.class,calculated.class )
            }),
            acc.rate( true.class, algorithm.class[[ n.index ]] ))
  })

  names(result) <- datasets.names

  result
}

