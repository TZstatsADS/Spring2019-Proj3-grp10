########################
### Super-resolution ###
########################

### Project 3

superResolution <- function(LR_dir, HR_dir, modelList){
  
  ### Construct high-resolution images from low-resolution images with trained predictor
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + a list for predictors
  
  ### load libraries
  library("EBImage")
  library(tidyverse)
  n_files <- length(list.files(LR_dir))
  
  # This function returns the surronding pixels
  surrounding_pixels <- function(x,y,img=imgLR_padded_zero)
  {
    surronding <- array(NA, c(8,3))
    neighbors <- img[c(x-1,x,x+1),c(y-1,y,y+1), ]
    center <- rep(neighbors[2,2,],9)
    neighbors <- neighbors - center
    surronding[1:3, ]<- neighbors[1, , ]
    surronding[4:5, ]<- neighbors[2, c(1, 3), ]
    surronding[6:8, ]<- neighbors[3, , ]
    return(surronding)
  }
  
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img", "_", sprintf("%04d", i), ".jpg"))
    pathHR <- paste0(HR_dir,  "img", "_", sprintf("%04d", i), ".jpg")
    featMat <- array(NA, c(dim(imgLR)[1] * dim(imgLR)[2], 8, 3))
    
    ### step 1. for each pixel and each channel in imgLR:
    ###           save (the neighbor 8 pixels - central pixel) in featMat
    ###           tips: padding zeros for boundary points
    
    imgLR_padded_zero <- abind(array(0, replace(dim(imgLR), 2, 1)),imgLR, array(0, replace(dim(imgLR), 2, 1)), along = 2)
    imgLR_padded_zero <- abind(array(0, replace(dim(imgLR_padded_zero), 1, 1)),imgLR_padded_zero, array(0, replace(dim(imgLR_padded_zero), 1, 1)), along = 1)
    
    x_index <- rep(1:(dim(imgLR)[1]),dim(imgLR)[2])
    y_index <- rep(1:(dim(imgLR)[2]),dim(imgLR)[1])
    
    temp_feature <- mapply(surrounding_pixels,x_index+1,y_index+1)
    featMat[, , 1]<- t(temp_feature[1:8, ])
    featMat[, , 2]<- t(temp_feature[9:16, ])
    featMat[, , 3]<- t(temp_feature[17:24, ])
    
    ### step 2. apply the modelList over featMat
    predMat <- test(modelList, featMat)%>%
      array(.,c(dim(imgLR)[1] * dim(imgLR)[2], 4, 3))
    ### step 3. recover high-resolution from predMat and save in HR_dir
    imgLR_upscale <- array(NA, c(dim(imgLR)[1]*2, dim(imgLR)[2]*2, 3))
    
    LR <- array(c(rep(as.numeric(imgLR[,,1]), 4), 
                    rep(as.numeric(imgLR[,,2]), 4), 
                    rep(as.numeric(imgLR[,,3]), 4)), 
                    dim = c(dim(imgLR)[1] * dim(imgLR)[2], 4, 3))
    
    HR <- predMat + LR
    
    row <- 2*(1:dim(imgLR)[1])
    col <- 2*(1:dim(imgLR)[2])
    
    imgLR_upscale[row-1, col-1, ]<- HR[, 1, ]
    imgLR_upscale[row-1, col, ]<- HR[, 2, ]
    imgLR_upscale[row, col-1, ]<- HR[, 3, ]
    imgLR_upscale[row, col, ]<- HR[, 4, ]
    
    imgLR_upscale <- imageData(imgLR_upscale)%>%
      Image(., colormode=Color)
    
    writeImage(imgLR_upscale, paste0(HR_dir,  "upscale_img", "_", sprintf("%04d", i), ".jpg"))
    print(i)
    
  }
}