# Statistical-Analysis-of-EKG-GSR-and-Respiration-Features-for-Stress-Recognition-in-Automobile-Drive

This study presents a method for analyze physiological signals, Electrocardiogram (EKG), Skin Conductance (foot GSR) and Respiration, to extract features able to identify drivers’ stress level while driving using Matlab. The data used in this study come from an already existing database, called “Stress Recognition in Automobile Drivers”, in which physiological signals were acquired while the drivers followed a prescribed path specifically designed to make the drivers experience different levels of stress. Features were extracted from 5 minutes intervals during the rest, highway and city driving conditions and the most significant ones were selected through statistical analysis. The results indicate that the three best indicators for stress recognition are features coming from foot GSR and Respiration signals for which an accuracy up 94% is achieved. These findings could be managed for in-vehicle information systems to improve drivers’ safety and comfort.

## Files explanation
- The [Report](https://github.com/Eri0898/Statistical-Analysis-of-EKG-GSR-and-Respiration-Features-for-Stress-Recognition-in-Automobile-Drive/blob/main/Report.pdf) is an unpublished article in which all the details of the study can be found, starting with an introductory overview, passing through the methods used, to end with the results and discussion of the work.
- The [Feature_extraction](https://github.com/Eri0898/Statistical-Analysis-of-EKG-GSR-and-Respiration-Features-for-Stress-Recognition-in-Automobile-Drive/blob/main/Feature_extraction.m) is a Matlab file in which EKG, foot GSR and Respiration signals have been analyzed and some features were extracted from them. The following table reports all the features extracted from the signals. 
<p align="center">
<img width="411" alt="Schermata 2022-11-03 alle 10 06 15" src="https://user-images.githubusercontent.com/111573018/199682973-0ffd13a7-87bc-492e-a9f8-c3c791b96184.png">
</p>
- The [Statistical_Analysis](https://github.com/Eri0898/Statistical-Analysis-of-EKG-GSR-and-Respiration-Features-for-Stress-Recognition-in-Automobile-Drive/blob/main/Statistical_Analysis.m) is a Matlab file in which the statistical analysis has been performed on the extracted features to find out which are more significant to recognize the level of stress. Particularly, the one-way analysis of variance (ANOVA) test was performed on the features to evaluate whether the means of several groups are equal. The p-value produced by the ANOVA test was compared with the significance level that we assumed equal to 0.05. If the p-value was smaller than 0.05, the means feature differences were considered statistically significant, otherwise not. Multiple comparison of means was performed to obtain the p-value and the corresponding confidence interval for each pair of stress levels to statistically discriminate or not each group. Finally, the Receiver Operating Characteristics (ROC) curve was also computed to evaluate the accuracy of each feature to recognize low, medium, or high stress. The ROC curve was obtained using the ‘perfcurve’ function in MATLAB, that returns the Area Under the ROC Curve (AUC). Also, the Optimal Operating Point (opt) of the ROC curve was calculated as the point in which the Sensitivity is equal to Specificity.
