# Project: Can you unscramble a blurry image? 
![image](figs/example.png)

### [Full Project Description](doc/project3_desc.md)

Term: Spring 2019

+ Team Group 10
+ Team members
	+ Karsok, Max mk4192@columbia.edu
	+ Lin, Nelson nl2600@columbia.edu
	+ Su, Feng fs2658@columbia.edu
	+ Yang, Zeyu zy2327@columbia.edu
	+ Zhang, Liwei lz2655@columbia.edu

+ Project summary: In this project, we created a classification engine for enhance the resolution of images. This classification engine is based on XGBoost algorithm. After building the model, we compare it with GBM model. The result shows we sacrifice a little in PSNR but reduce the time for training and applying model significantly. For 50 test images, PSNR is 23.7681 for GBM model while time for training model= 1536.47 s, time for super-resolution= 625.23 s. PSNR is 22.27632 for XGBoost model while time for training model= 16.93 s, time for super-resolution= 115.53 s.
 
 **Contribution statement**: ([default](doc/a_note_on_contributions.md)) Zeyu filled out the _feature.R_ file, optimized the feature extraction speed and filled out the _superResolution.R_ file. Zeyu and Max made appropriate modifications and ran the GBM baseline. Liwei and Zeyu built the XG Boost algorithm, Zeyu tuned the parameters and Max tested potential XG Boost improvements. Nelson and Liwei explored advanced models in python that involved re-designing the features file. Max explored a random forest model that was not as fast or accurate as baseline and XG Boost. Feng designed the presentation of results, and presented to the class. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
