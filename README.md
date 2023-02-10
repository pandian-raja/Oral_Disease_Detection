# Oral_Disease_Detection

This project aims to bring to life the study on [Automatic detection of oral cancer in smartphone-based images using deep learning for early diagnosis](https://pubmed.ncbi.nlm.nih.gov/34453419/)

The [source code](https://github.com/hplin6/oral_disease_diagnosis) available in PyTorch, has been converted to CoreML for implementation on iOS devices.

# Initial Analysis

While the source code provides the models and weights, the image dataset is not included. This presents a challenge in assessing the full capabilities of the solution. So I've just conveted the pytorch model(.pth) into CoreMl.

# iOS TestFlight link
 Join public beta [link](https://testflight.apple.com/join/qNt23VJs)

# Colab Ipynb file link 
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/pandian-raja/Oral_Disease_Detection/blob/main/Ipynb/OralDiagnosisConvertModel.ipynb)

# Conclution 

A preliminary analysis shows that the accuracy of detecting oral diseases has not yet met the desired expectations. The model was able to correctly classify the sample images located in the [source repository](https://github.com/hplin6/oral_disease_diagnosis/tree/master/samples/center-position). However, when the model was built for iOS, its performance was not up to par. Without access to the image dataset, it is difficult to make a comprehensive assessment of the solution's performance using saved pytorch model.


### Analysis of [source repository](https://github.com/hplin6/oral_disease_diagnosis/tree/master/samples/center-position) images

![Image](../main/Resources/oral_disease_result.png?raw=true)

# Steps to implement 


1. For iOS: Open Oral Diagnosis.xcodeproj and run on Xcode

2. For Ipynb: 

    2.1 Copy OralDiagnosisConvertModel.ipynb, and zip files( images.zip, oral.zip and pretrained.zip) from ...Source/Ipynb/Assets/OralCancer) to your Google Drive

    2.2 Run OralDiagnosisConvertModel.ipynb on Colab
