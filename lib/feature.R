#############################################################
### Construct features and responses for training images###
#############################################################

### Project 3

### load libraries
library("EBImage")

feature <- function(LR_dir, HR_dir, n_points=100){
  
  ### Construct process features for training images (LR/HR pairs)
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + number of points sampled from each LR image
  ### Output: an .RData file contains processed features and responses for the images
  
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
  
  # This function returns the sub pixels
  sub_pixels <- function(x,y,imgH=imgHR,imgL=imgLR)
  {
    sub <- array(NA, c(4,3))
    imgH <- as.array(imgH)
    sub_pixel <- imgH[c(2*x-1,2*x), c(2*y-1,2*y), ]
    center <- rep(imgL[x, y, ],4)
    sub_pixel <- sub_pixel - center
    sub[1:2, ]<- sub_pixel[1, , ]
    sub[3:4, ]<- sub_pixel[2, , ]
    return(sub)
  }
  
  
  n_files <- length(list.files(LR_dir))
  
  ### store feature and responses
  featMat <- array(NA, c(n_files * n_points, 8, 3))
  labMat <- array(NA, c(n_files * n_points, 4, 3))
  
  
  # require(parallel)
  # cl <- makeCluster(8)
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    
    ### step 1. sample n_points from imgLR
    
    sample_x_index <- sample(1:dim(imgLR)[1],n_points,replace = T)
    sample_y_index <- sample(1:dim(imgLR)[2],n_points,replace = T)
    
    ### step 2. for each sampled point in imgLR,
        ### step 2.1. save (the neighbor 8 pixels - central pixel) in featMat
        ###           tips: padding zeros for boundary points
    
    imgLR_padded_zero <- abind(array(0, replace(dim(imgLR), 2, 1)),imgLR, array(0, replace(dim(imgLR), 2, 1)), along = 2)
    imgLR_padded_zero <- abind(array(0, replace(dim(imgLR_padded_zero), 1, 1)),imgLR_padded_zero, array(0, replace(dim(imgLR_padded_zero), 1, 1)), along = 1)
    
        ### step 2.2. save the corresponding 4 sub-pixels of imgHR in labMat
    ### step 3. repeat above for three channels
    index <- ((i-1)*n_points+1):(i*n_points) 
    
    temp_feature <- mapply(surrounding_pixels,sample_x_index+1,sample_y_index+1)
    featMat[index, , 1]<- t(temp_feature[1:8, ])
    featMat[index, , 2]<- t(temp_feature[9:16, ])
    featMat[index, , 3]<- t(temp_feature[17:24, ])
    
    temp_label <- mapply(sub_pixels,sample_x_index,sample_y_index)
    labMat[index, , 1]<- t(temp_label[1:4, ])
    labMat[index, , 2]<- t(temp_label[5:8, ])
    labMat[index, , 3]<- t(temp_label[9:12, ])
    
    print(paste("file:",i)) #Print the progress
  }
  # stopCluster(cl)
  return(list(feature = featMat, label = labMat))
}






