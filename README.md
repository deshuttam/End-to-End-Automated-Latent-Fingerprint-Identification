# End-to-End-Automated-Latent-Fingerprint-Identification-with-DCNN-FFT
By Uttam Deshpande et. al.,







An end-to-end ﬁngerprint matching system to automatically enhance, extract minutiae, and produce matching results with the help of “Automated Deep Convolutional Neural Network (DCNN)” and “Fast Fourier Transform (FFT)” ﬁlters. To refer to this paper: https://www.frontiersin.org/articles/10.3389/frobt.2020.594412/full

## Introduction
We have presented an end-to-end ﬁngerprint matching system to automatically enhance, extract minutiae, and produce matching results. To automatically enhance the poor-quality ﬁngerprint images we utilise the automated "Deep Convolutional Neural Network (DCNN)” and “Fast Fourier Transform (FFT)” ﬁlters. The Deep Convolutional Neural Network (DCNN) produces a frequency enhanced map from ﬁngerprint domain knowledge. A “FFT Enhancement” algorithm enhances and extracts the ridges from the frequency enhanced map. Minutiae from the enhanced ridges are automatically extracted using a proposed “Automated Latent Minutiae Extractor (ALME)”. Based on the extracted minutiae, the ﬁngerprints are automatically aligned, and a matching score is calculated using a proposed “Frequency Enhanced Minutiae Matcher (FEMM)” algorithm. 
![image](https://user-images.githubusercontent.com/107185323/197323498-85bc2958-aa78-4c57-a705-db78e15da314.png)

## AUTOMATED LATENT FINGERPRINT PRE-PROCESSING AND ENHANCEMENT USING DCNN AND FFT FILTERS
We use the DCNN layers of FingerNet to obtain the enhanced frequency map. Later, we enhance the ridge structure to assist good minutiae extraction using the DCNN layers to remove the background noise and to extract the important ridge information. 
![image](https://user-images.githubusercontent.com/107185323/197323622-b1f865c1-4a2c-4094-9386-f3850158900d.png)

![image](https://user-images.githubusercontent.com/107185323/197323641-8e3fe342-9f84-471a-9708-ec577c069d70.png)

Further processing is carried out using FFT enhancement ﬁlters. 
![image](https://user-images.githubusercontent.com/107185323/197323660-d42f663e-aea5-4226-acb9-1d7041880f4b.png)

## AUTOMATED MINUTIAE EXTRACTION AND MATCHING
Minutiae present in the gallery ﬁngerprints are extracted and stored as a set of minutiae belonging to a particular ﬁngerprint with the ﬁngerprint ids. For a query ﬁngerprint our proposed minutiae extractor performs ﬁngerprint alignment to retrieve minutiae pairings between both the ﬁngerprints. Our proposed matcher computes the similarity between the query and gallery ﬁngerprints, searches the top 20 similar ﬁngerprints, and ﬁnally outputs the candidate list based on the match score. 


The repository includes:
* Source code for FingerNet 
* Training code 
* Pre-trained weights 
* Jupyter notebooks
* Source code for FFT enhancement
* Source code for matching
* Matlab code

### Citing
@ARTICLE{10.3389/frobt.2020.594412,
AUTHOR={Deshpande, Uttam U. and Malemath, V. S. and Patil, Shivanand M. and Chaugule, Sushma V.},   
TITLE={End-to-End Automated Latent Fingerprint Identification With Improved DCNN-FFT Enhancement},      
JOURNAL={Frontiers in Robotics and AI},      
VOLUME={7},           
YEAR={2020},        
URL={ https://www.frontiersin.org/articles/10.3389/frobt.2020.594412 },       
DOI={10.3389/frobt.2020.594412},      
ISSN={2296-9144},
}

## FingerNet 

### Contents
0. [Requirements: software](#requirements-software)
0. [Requirements: hardware](#requirements-hardware)
0. [Predicting Demo](#predicting-demo)
0. [Preparation for Training & Testing](#preparation-for-training-and-testing)
0. [Training](#training)
0. [Testing](#testing)
0. [Acknowledgement](#acknowledgement)


### Requirements: software

0. `Python 2.7`: cv2, numpy, scipy, matplotlib, pydot, graphviz
0. `Tensorflow 1.0.1`
0.  `Keras 2.0.2`

### Requirements: hardware

GPU: Titan, Titan Black, Titan X, K20, K40, K80.

0. FingerNet predicting
    - 2GB GPU memory for FVC2002DB2A
    - 5GB GPU memory for NISTSD27

### Predicting Demo

0.  Run `cd` in shell to directory `src/`
0.  Run `python train_test_deploy.py 0 deploy` to test demo images provided in `datasets/`.
    - You may use different GPU by changing 0 to desired GPU ID. 
    - You will see the timing information as below. We get the following running time on single-core of K80 the demo images:
    ```Shell
    Predicting images:
    images 1 / 1: B101L9U
    load+conv: 4.872s, seg-postpro+nms: 0.223, draw: 2.249
    Average: load+conv: 4.872s, oir-select+seg-post+nms: 0.223, draw: 2.249
    Predicting CISL24218:
    CISL24218 1 / 1: A0100003009991600022036_2
    load+conv: 2.219s, seg-postpro+nms: 0.439, draw: 2.247
    Average: load+conv: 2.219s, oir-select+seg-post+nms: 0.439, draw: 2.247
    Predicting FVC2002DB2A:
    FVC2002DB2A 1 / 1: 1_1
    load+conv: 1.718s, seg-postpro+nms: 0.548, draw: 3.309
    Average: load+conv: 1.718s, oir-select+seg-post+nms: 0.548, draw: 3.309
    Predicting NIST4:
    NIST4 1 / 1: F0001_01
    load+conv: 1.006s, seg-postpro+nms: 1.640, draw: 3.947
    Average: load+conv: 1.006s, oir-select+seg-post+nms: 1.640, draw: 3.947
    Predicting NIST14:
    NIST14 1 / 1: F0000001
    load+conv: 6.211s, seg-postpro+nms: 3.271, draw: 4.643
    Average: load+conv: 6.211s, oir-select+seg-post+nms: 3.271, draw: 4.643
    ```
    - The visual results might be different from those in the paper due to numerical variations.    
0. Change `deploy_set=['*/',..., '*/']` in line 44-45 in `train_test_deploy.py` to desired dataset folders to test other fingerprint datasets.

### Preparation for Training and Testing

0.  Move raw fingerprint training images to `datasets/dataset-name/images/`
    - Training images should be of `bmp` format
0.  Move segmentation labels to `datasets/dataset-name/seg_labels/`
    - Segmentation labels should be of `png` format and have the same size and name with its corresponding fingerprint images.
    - `255` indicates foreground while `0` for background.
0. Move orientation labels to `datasets/dataset-name/ori_labels/`
    - Orientation labels are rolled/slap fingerprint aligned to training images and of same size, same name and `bmp` format.
0. Move minutiae labels to `datasets/dataset-name/mnt_labels/`
    - Minutiae labels should be of same name and `mnt` format.
    - `.mnt` structure is as follow:
        - line 1: image-name
        - line 2: number-of-minutiae-N, image-W, image-H
        - next N lines: minutia-x, minutia-y, minutiae-o 
0. Change `train_set=['*/', ...'*/']` in line 42 in `train_test_deploy.py` to `train_set=['../datasets/dataset-name/',]`

### Training:

0. Run `python train_test_deploy.py 0 train` to finetune your model. 
    - **Note**: Maximum epoch is set to 100. Early stop if model have converged.

### Testing

0. Run `python train_test_deploy.py 0 test` to test your model.
    - Different from Predicting, Testing requires datasets to have at least mnt labels and segmentation labels. 
    - Change `test_set=['*/', ...'*/']` in line 44 in `train_test_deploy.py` to test other datasets.


##  FFT enhancement
Run Finger_Enhance_FingerNet.m matlab code by placing images in respective folder

##  Matching
Run main_total.m matlab code by placing enhanced images in respective folder

