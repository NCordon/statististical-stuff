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


vote.prediction <- function(predictions, accuracies, ponderate){
  # For each dataset, calc most voted class and break ties with most accurate pred
  result <- lapply( 1:length( predictions ), function(i){ 
    dataset.pred <- predictions[[i]]

    if(! ponderate){
      votes <- lapply( dataset.pred, function(m){
        matrix(
          sapply( seq_len(nrow(m)), function(row.index){
            row <- m[row.index,]
            # Substitute max probability prediction with 1, otherwise 0
            result <- rep(0,length(row))
            result[ which.max(row) ] <- 1
            result
          }),
          ncol = ncol(m), byrow=T)
      })
    }else{
      votes <- dataset.pred
    }
    
    sum.votes <- Reduce('+', votes)
    categories <- colnames(dataset.pred[[1]])

    sapply( seq_len( nrow(sum.votes) ), function(row.index){
      row <- sum.votes[row.index,]

      index.max <- which(row == max(row))

      if(length(index.max) == 1){
        categories [ index.max ]
       }else{
         pred.categories <- sapply(votes, function(m){ categories[ which.max(m[row.index, ]) ] })
         pred.indexes <- which(pred.categories %in% categories[ index.max ])
         categories[ which.max( accuracies[[i]][ pred.indexes ] ) ]
      }
    })
  })

  names(result) <- datasets.names
  result
}
