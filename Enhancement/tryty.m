% Project Title: Enhancement of Bad Quality Fingerprints
% The code below reconstructs most of the details from a bad quality
% fingerprint image

close all
clear all
clc

myFolder = 'F:\PhD\Software\Matlab\Fingerprint Enhancements\Fingerprint Enhancements\Fingerprint Enhancements\Enhancements';

filePattern = fullfile(myFolder, '*.bmp');
jpegFiles   = dir(filePattern);

for kk = 1:1%length(jpegFiles)
  baseFileName = jpegFiles(kk).name;
  fullFileName = fullfile(myFolder, baseFileName);

im = imread(fullFileName);
ext_finger_skeleton(im,0,baseFileName);
end


