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

A preliminary analysis shows that the accuracy of detecting oral diseases has not yet met the desired expectations. Based on the sample images provided in the [source repository](https://github.com/hplin6/oral_disease_diagnosis/tree/master/samples/center-position), the model is consistently predicting normal(No Cancer). Without access to the image dataset, it is difficult to make a comprehensive assessment of the solution's performance using saved pytorch model.

### Analysis of [source repository](https://github.com/hplin6/oral_disease_diagnosis/tree/master/samples/center-position) images

![Image](../main/Resources/oral_disease_result.png?raw=true)

# Steps to implement 

The model size is aroung 150 MB and the Githhub has upload size limit. So I've put the assets in Google Drive. 

1. Download and extract the [Assets.zip](https://drive.google.com/file/d/18gRBDezrw0-rxtnDzGn1VonAFmY0pjJM/view?usp=share_link)

2. For iOS: 

    2.1 Move OralCancerV3.mlpackage to ...Source/iOS/Oral Diagnosis/ 

    2.2 Open Oral Diagnosis.xcodeproj and run on Xcode

3. For Ipynb: 

    3.1 Move pretrained.zip to ...Source/Ipynb/Assets/OralCancer/

    3.2 Copy OralDiagnosisConvertModel.ipynb, and zip files( images.zip, oral.zip and pretrained.zip) from ...Source/Ipynb/Assets/OralCancer) to your Google Drive

    3.3 Run OralDiagnosisConvertModel.ipynb on Colab
