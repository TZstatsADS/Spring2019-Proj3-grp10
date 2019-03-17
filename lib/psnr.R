compute_psnr <- function(test_dir, HR_dir)
{
  library(EBImage)
  n_files <- length(list.files(test_dir))
  psnr <- array(NA,dim=n_files)
  
  for(i in 1:n_files){
    imgUR <- readImage(paste0(test_dir,  "upscale_img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    
    d <- dim(imgHR)
    MSE <- sum((as.vector(imgUR - imgHR))^2)/(d[1]*d[2]*d[3])
    psnr[i] <- 10*log10(1/MSE)
    
    print(paste("file:",i)) #Print the progress
  }
  return(mean(psnr))
}