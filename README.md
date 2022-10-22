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


