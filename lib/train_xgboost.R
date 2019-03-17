train.xgboost <- function(dat_train, label_train, par=NULL){
  
  library("xgboost")
  
  modelList <- list()
  
  if(is.null(par)){
    max_depth <- 2
    eta <- 1
  } else {
    max_depth <- par$max_depth
    eta <- par$eta
    #nrounds = par$nrounds
    subsample = par$subsample
    min_child_weight = par$min_child_weight
    
  }
  

  for (i in 1:12){
    ## calculate column and channel
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
    featMat <- dat_train[, , c2]
    labMat <- label_train[, c1, c2]
    fit_xgboost <- xgboost(data=featMat, label=labMat,
                           max_depth=max_depth,
                           eta=eta,
                           nthread=2,
                           nrounds=10,
                           objective="reg:linear", 
                           verbose=FALSE,
                           subsample = subsample,
                           min_child_weight = min_child_weight
    )
    modelList[[i]] <- list(fit=fit_xgboost)
  }
  
  return(modelList)
}