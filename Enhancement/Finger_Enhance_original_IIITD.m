% Project Title: Enhancement of Bad Quality Fingerprints
% The code below reconstructs most of the details from a bad quality
% fingerprint image

close all
clear all
clc

%[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick a Degraded Fingerprint Image File');
%im = imread([pathname,filename]);
%figure, imshow(im);title('Fingerprint Image');
myFolder = 'F:\PhD\Software\Matlab\Fingerprint Enhancements\Fingerprint Enhancements\Fingerprint Enhancements\Enhancements\DB_IIITD_1000ppi\';
if exist(myFolder, 'dir') ~= 7
  Message = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(Message));
  return;
end

filePattern = fullfile(myFolder, '*.tif');
jpegFiles   = dir(filePattern);
for kk = 1:1%length(jpegFiles)
  baseFileName = jpegFiles(kk).name;
  fullFileName = fullfile(myFolder, baseFileName);

im = imread(fullFileName);
%I = imread(fullFileName);
%I = imread('./fingerprints/t4.bmp');

if ndims(im) == 3
    im = rgb2gray(im);
end

% Binarize the image
disp(['Extractingfeaturesfrom' baseFileName ' ...']);
J=imadjust(im,[0.3;0.7],[]);
im(:,:,1)>160;
figure(2)
imshow(J)
% Ridge thining is to eliminate the redundant pixels of s till the 
% ridges are just one pixel wide.  
%set(gcf,'position', [1 1 800 768]);
K=bwmorph(~J,'thin','inf');
figure(3)
imshow(~K)
%[newim, binim, mask, reliability] =  testfin(K,baseFileName);
%[newim, binim, mask, reliability] =  testfin_IIITD(K,baseFileName);
%[newim, binim, mask, reliability] =  testfin_skelonly(K,baseFileName);
end 
