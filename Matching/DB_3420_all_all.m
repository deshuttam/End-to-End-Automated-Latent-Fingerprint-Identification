% ————————————————————————————————–
clear all;
clc;
addpath(genpath(pwd));

%% BUILD FINGERPRINT TEMPLATE DATABASE
%build_datab();
%build_datab_skeleton();

%% LOAD FINGERPRINT TEMPLATE DATABASE
load('db.mat');

%% EXTRACT FEATURES FROM AN ARBITRARY FINGERPRINT
%myFolder = 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\FingerNet AE\Extracted';
myFolder = 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching';
if exist(myFolder, 'dir') ~= 7
  Message = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(Message));
  return;
end
%[filename] = uigetfile('.jpg;  .png;  .tif;  .jpeg;  .bmp');
%img = imread(['F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\DB1_B\image\101_1.bmp']);
%cd  'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\FingerNet AE\Extracted';
cd 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching';
filePattern = fullfile(myFolder, '*.bmp');
jpegFiles   = dir(filePattern);

fid=fopen('FingerNetQueryAEGallery.txt','wt');
Query='Query';
Gallery='Gallery';
Score='Score';
fprintf(fid,'%s \t %s \t %s\n',Query,Gallery,Score); 

for k = 1:1%length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullfilename = fullfile(myFolder, baseFileName);
  filename=baseFileName;
  img = imread(baseFileName);
  %+imshow(img);
  %fn=sprintf('%s.jpg',res);

%img = imread(['F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2004\DB1_B\101_1.tif']);
%img = imread(['F:\PhD\Software\Matlab\sc_minutia\sc_minutia\GroundMinuPairs\Manualskeleton\t1.bmp']);


GAR=0; FAR=0; FRR=0;

%figure(1)
%imshow(img)

%binim, mask, cimg1, cimg2, oimg1, oimg2=f_enhance(img);
oimg = ridgeorient(img, 1, 3, 3); 
%Res=extract_finger(filename);
img=imresize(img, [300,300] );
if ndims(img) == 3; img = rgb2gray(img); 
end

%%Pre-processing for fingerprint recognition system.
% program for Sobel and Canny filter:
a=img;
%subplot(2,2,1);
%imshow(a);
%title('original image');

b=fspecial('sobel');
c=imfilter(a,b);
%subplot(2,2,2);
%imshow(c);
%title('horizontal sobel');

d=edge(a,'sobel',[],'both');
%subplot(2,2,3);
%imshow(d);
%title('sobel');

e=edge(a,'canny',[],1);
%subplot(2,2,4);
%imshow(e);
%title('canny');

%Program for Morphological gray scale (dilate)
f=img;
se=strel('square',5);
gd=imdilate(f,se);
ge=imerode(f,se);
gf=imsubtract(gd,ge);
%imshow(gf),title('Morphological gray scale(dilate)')


%%Statistical Measures:
I=img;
%imshow(I); title('Original Image');
%img=rgb2gray(I);
%subplot(2,2,2);
%imshow(img); title('Grayscale image');

BW3 = edge(I,'log');
%subplot(2,2,3);

%imshow(BW3);title('Laplacian of Gaussian');
%subplot(2,2,4);
%imshow(BW3);title('Laplacian of Gaussian');
%imshow(BW1);

MSE1=mean(mean((BW3).^2));

%MSE2=mean(mean((im-imf2).^2));
MaxI=1;% the maximum possible pixel value of the images.
PSNR1=10*log10((MaxI^2)/MSE1);
%PSNR2=10*log10((MaxI^2)/MSE2);
    
    
%% Binarize the image
disp(['Extractingfeaturesfrom' filename ' ...']);
J=imadjust(img,[0.3;0.7],[]);
img(:,:,1)>160;
%figure(2)
%imshow(J)

% Ridge thining is to eliminate the redundant pixels of s till the 
% ridges are just one pixel wide.  
%set(gcf,'position', [1 1 600 600]);
K=bwmorph(~J,'thin','inf');
%figure(3)
%imshow(~K)


%% extFinger Function
% ------------------------------------------------------------------------
%ffnew=load('ext_finger.m','img','K');
disp(['Extracting features from ' filename ' ...']);
load('fnmr.mat');
load('fmr.mat');
ffnew=ext_finger(img,1,filename);

%ffnew=ext_finger_FVC2004(img,1,filename);
%imshow(ffnew)
%figure(8)

%ff{i}=ext_finger(img,1);
%imshow(ff{i})
%figure(9)

%% FOR EACH FINGERPRINT TEMPLATE, CALCULATE MATCHING SCORE IN COMPARISION WITH FIRST ONE
  fname = filename;
  pattern = '.bmp';
  replacement = '';
  fname=regexprep(filename,pattern,replacement);
GT=0;
sec_file=0;
S=zeros(80,1);
for i=1:80
    second=['10' num2str(fix((i-1)/8)+1) '_' num2str(mod(i-1,8)+1)];
    fprintf(['Computing similarity between ' fname ' and ' second ' from FVC2002 : ']);
    S(i)=match(ffnew,ff{i},0);
    if (S(i)>GT)
        GT=S(i);
        sec_file=second;
    end
    T1=transform( ffnew, 1 );
    T2=transform( ff{i}, 1 );
    sm=score( T1, T2 );
        if (sm >0.50) 
             GAR=GAR+1; 
        else
            FRR=FRR+1;
        end
    s=score(ffnew,ff{i});
    %fprintf(fid,'%s \t %s \t\t %f\n',fname,second,S(i));  
    %xlswrite('bmss.xlsx',s);
    %xlswrite('bmss.xlsx',s,sheet);
   
    fprintf([num2str(S(i)) '\n']);
 %   fprintf([num2str(sm) '\n']);
 %   drawnow
end
    fprintf(fid,'%s \t %s \t\t %f\n',fname,sec_file,GT); 
%display(GAR); 
%display(FRR); 
%fprintf(fid,'%f \t %f \n',GAR,FRR); 

end
fclose(fid);
%Matched_FingerPrints=find(S > 0.65);
