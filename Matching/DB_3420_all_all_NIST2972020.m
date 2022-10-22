
% ————————————————————————————————–
clear all;
clc;
addpath(genpath(pwd));

%% BUILD FINGERPRINT TEMPLATE DATABASE
%build_datab();
%build_datab_NIST_original(258);

%% LOAD FINGERPRINT TEMPLATE DATABASE
load('db.mat');

%% EXTRACT FEATURES FROM AN ARBITRARY FINGERPRINT
myFolder = 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\NIST SD27\FingerNetAE LLAH\Cropped\Ori';
%myFolder ='F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\NIST SD27\FingerNet Ori';
if exist(myFolder, 'dir') ~= 7
  Message = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(Message));
  return;
end
%[filename] = uigetfile('.jpg;  .png;  .tif;  .jpeg;  .bmp');
%img = imread(['F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\DB1_B\image\101_1.bmp']);
cd  'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\NIST SD27\FingerNetAE LLAH\Cropped\Ori';
%cd 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\NIST SD27\FingerNet Ori';
filePattern = fullfile(myFolder, '*.bmp');
jpegFiles   = dir(filePattern);

fid=fopen('FingerNetCropQueryFingerNetOriGallery.txt','wt');
Query='Query';
Gallery='Gallery';
Score='Score';
fprintf(fid,'%s \t %s \t %s\n',Query,Gallery,Score); 
sheet=1;
xlfilename='FingerNetCropQueryFingerNetOriGallery.xlsx';
xlFullFileName = fullfile(myFolder, xlfilename);
y = zeros(258,20); % Rank initialization of final matrix
x = zeros(258,1); % Query FP initialization of final matrix

y1_a = zeros(258,20); % Rank initialization of final matrix
y2_a = zeros(258,20); % Rank initialization of final matrix
x_a = zeros(258,1); % Query FP initialization of final matrix
%Res_All(1,2,20)=0;
old_x1=0;
old_x2=0;

for kk = 1:196%length(jpegFiles)
  baseFileName = jpegFiles(kk).name;
  fullfilename = fullfile(myFolder, baseFileName);
  filename=baseFileName;
  img = imread(baseFileName);
  %imshow(img);
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
%load('fnmr.mat');
%load('fmr.mat');
ffnew=ext_finger_skeleton(img,0,filename);

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
  ffname=str2double(fname);

GT=0;
%LFID(2:1:258)=0;
LFID(258:2)=0;

sec_file=0;
S=zeros(258,1);
    for i=1:258
    second=[num2str(mod(i-1,258)+1) '.bmp'];
    sname = second;
    pattern = '.bmp';
    replacement = '';
    sec_name=regexprep(sname,pattern,replacement);
    sec_name=sprintf('%c',sec_name);
    fprintf(['Computing similarity between ' fname ' and ' sec_name ' from NIST SD27 : ']);
    S(i)=match(ffnew,ff{i},0);

  %   LFID(1,i,:)=str2double(sec_name);
   %  LFID(2,i,:)=S(i);
      LFID(i,1)=str2double(sec_name);
      LFID(i,2)=S(i);
    
    if (S(i)>GT)
        GT=S(i);
        sec_file=sec_name;
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
    
    T = array2table(LFID);
    T.Properties.VariableNames(1:2) = {'Rank','Score'};
    %Tab=sort(T.Score,'descend');
    data = sortrows(T,{'Rank','Score'});
    % Transform the cell into a matrix (a colum in this case) and sort it. The sorting returns also the position of the sorted column (variable `idx`).
    [~, idx] = sort(T.Score,'descend');
    % Put everything back together, re-adding the first letters and using the sorted indices.
    
    %xlsappend('FengAEQueryGallerySkeleton.xlsx',Yt,sheet);  
    % x=rand(1,3); % array random numbers
    
    Y=[T.Rank(idx)];
    Res=Y(1:20); %Sorted rank 20
    Yt=Res';
    x(ffname,:) = ffname;
    y(ffname,:) = Yt; % copy previous array to kth column of the matrix
    xlswrite(xlFullFileName,x,1,'A1'); % write the matrix to xls file, starting in cell 'B2'.
    xlswrite(xlFullFileName,y,1,'B1'); % write the matrix to xls file, starting in cell 'B2'.
    
    X1 = [[T.Rank(idx)]]; %, [T.Score; T.Score(idx)]];
    X2 = [[T.Score(idx)]]; %, [T.Score; T.Score(idx)]];
    Res_All1=X1(1:20); %Sorted rank 20
    Res_All2=X2(1:20); %Sorted rank 20
   % Res_All(2:20)=X(2:20); %Sorted rank 20
    Xt1 = Res_All1';
    Xt2 = Res_All2';
    
    old_x1=(2*(ffname-1))+1;
    old_x2=(2*(ffname-1))+2;
    x_a(old_x1,:) = ffname;
    y1_a(old_x1,:) = Xt1; % copy previous array to kth column of the matrix
    y1_a(old_x2,:) = Xt2; % copy previous array to kth column of the matrix
    xlswrite(xlFullFileName,x_a,2,'A1'); % write the matrix to xls file, starting in cell 'B2'.
    xlswrite(xlFullFileName,y1_a,2,'B1'); % write the matrix to xls file, starting in cell 'B2'.
   % xlswrite(xlFullFileName,y2_a,2,'B2'); % write the matrix to xls file, starting in cell 'B2'.
   % fprintf(fid,'%s \t %s \t\t %f\n',fname,sec_file,GT); 
%display(GAR); 
%display(FRR); 
%fprintf(fid,'%f \t %f \n',GAR,FRR); 

end
fclose(fid);
%Matched_FingerPrints=find(S > 0.65);
%{
y = zeros(1); % initialization of final matrix
x=rand(1); % array random numbers
for k=2:3
 % x=rand(1,3); % array random numbers
  y(k,1) = x; % copy previous array to kth column of the matrix
end
y(10,1) = x; % copy previous array to kth column of the matrix
xlswrite(xlFullFileName,y,1,'C1'); % write the matrix to xls file, starting in cell 'B2'.
%}
