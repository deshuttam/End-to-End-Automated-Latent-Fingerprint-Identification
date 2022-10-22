%function [ ret ] = Copy_2_of_build_db(file_names,index1,g)
% ————————————————————————————————–
clear all;
clc;
addpath(genpath(pwd));
ICount = 1;
JCount = 2;
S=zeros(JCount,1);
build_db(ICount,JCount);
%fprintf('Matching.');
load('db.mat');
%% EXTRACT FEATURES FROM AN ARBITRARY FINGERPRINT
[filename_q] = uigetfile('.jpg;  .png;  .tif;  .jpeg;  .bmp');
img = imread(['H:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\DB1_B\101_8.tif']);
cd  'H:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\copy_db';
% filename=['10' num2str(fix((i-1)/8)+1) '_' num2str(mod(i-1,8)+1) '.tif'];
%img = imread(filename);
disp(['Extracting features from ' filename_q ' ...']);
%load('fnmr.mat');
%load('fmr.mat');
ffnew=ext_finger(img,1);
imshow(ffnew)
figure(8)



files = dir('H:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\DB1_B\*.tif');
cd  'H:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\copy_db';
p=1;
%IMPRESSIONS_PER_FINGER=1;
%file_names = {files.name};

%index1 = 1;
%while index1 <=JCount
%   for g=0:IMPRESSIONS_PER_FINGER-1
for i=1:ICount
for j=1:JCount
      
%img = imread(char(file_names(index1 + j)));
%filename=char(file_names(index1 + j));
filename=['10' num2str(fix((j-1)/8)+1) '_' num2str(mod(j-1,8)+1) '.tif'];
img = imread(filename);


fid=fopen('fp_far1.txt','wt');
GAR=0; FAR=0; FRR=0;
figure(1)
imshow(img)
%binim, mask, cimg1, cimg2, oimg1, oimg2=f_enhance(img);
oimg = ridgeorient(img, 1, 3, 3); 
%Res=extract_finger(filename);
img=imresize(img, [300,300] );
if ndims(img) == 3; img = rgb2gray(img); 
end


    
    
% Binarize the image
disp(['Extractingfeaturesfrom' filename ' ...']);
JK=imadjust(img,[0.3;0.7],[]);
img(:,:,1)>160;
figure(2)
imshow(JK)
% Ridge thining is to eliminate the redundant pixels of s till the 
% ridges are just one pixel wide.  
set(gcf,'position', [1 1 600 600]);
K=bwmorph(~JK,'thin','inf');
figure(3)
imshow(~K)



%{
%% extFinger Function
% ------------------------------------------------------------------------
%ffnew=load('ext_finger.m','img','K');
disp(['Extracting features from ' filename ' ...']);
%load('fnmr.mat');
%load('fmr.mat');
ffnew=ext_finger(img,1);
imshow(ffnew)
figure(8)
%filename='101_2.tif';
%img=imread(filename);
%ff{i}=ext_finger(img,1);
%imshow(ff{i})
%figure(9)
%[confusion_matrix, Fmeasure]=kNN();
%[ binim, mask, cimg, cimg2, orient_img, orient_img_m ] = f_enhance(img);
%[neighborIds, neighborDistances] = kNearestNeighbors(orient_img, orient_img_m, 3);
%}

%%
% We filter the thinned ridge map by the filter "minutie". "minutie"
% compute the number of one-value of each 3x3 window:
% * if the central is 1 and has only 1 one-value neighbor, then the central 
% pixel is a termination.  
% * if the central is 1 and has 3 one-value neighbor, then the central 
% pixel is a bifurcation. 
% * if the central is 1 and has 2 one-value neighbor, then the central 
% pixel is a usual pixel. 
%img=imread(img);
%img=rgb2gray(img);
%int32_K = int32(K);
% fun=@minutie;
%fun = inline('median(x(:))');
L = nlfilter(K,[3 3],@minutie);
%% Termination
LTerm=(L==1);
imshow(LTerm)
LTermLab=bwlabel(LTerm);
propTerm=regionprops(LTermLab,'Centroid');
CentroidTerm=round(cat(1,propTerm(:).Centroid));
imshow(~K)
set(gcf,'position',[1 1 600 600]);
hold on
plot(CentroidTerm(:,1),CentroidTerm(:,2),'ro')



LBif=(L==3);
LBifLab=bwlabel(LBif);
propBif=regionprops(LBifLab,'Centroid','Image');
CentroidBif=round(cat(1,propBif(:).Centroid));
figure(5)
imshow(img)
hold on
plot(CentroidBif(:,1),CentroidBif(:,2),'go');
hold off
figure(6)
imshow(img)
hold on
plot(CentroidTerm(:,1),CentroidTerm(:,2),'ro')
plot(CentroidBif(:,1),CentroidBif(:,2),'go');
hold off
D=10;

%% Process 1
Distance=DistEuclidian(CentroidBif,CentroidTerm);
SpuriousMinutae=Distance < D;
[ii, jj] =find(SpuriousMinutae);
CentroidBif(ii,:)=[];
CentroidTerm(jj,:)=[];
%% Process 2
D=7;
Distance=DistEuclidian(CentroidBif);
SpuriousMinutae=Distance < D;
[ii, jj] =find(SpuriousMinutae);
CentroidBif(ii,:)=[];
CentroidTerm(jj,:)=[];

D=6;
%% Process 3
Distance=DistEuclidian(CentroidTerm);
SpuriousMinutae=Distance<D;
[ii,jj]=find(SpuriousMinutae);
CentroidTerm(ii,:)=[];
hold off
imshow(~K)
hold on

plot(CentroidTerm(:,1),CentroidTerm(:,2),'ro')
plot(CentroidBif(:,1),CentroidBif(:,2),'go')
hold off



Kopen=imclose(img,strel('square',7));
KopenClean= imfill(Kopen,'holes');
KopenClean=bwareaopen(KopenClean,5);
KopenClean([1 end],:)=0;
KopenClean(:,[1 end])=0;
ROI=imerode(KopenClean,strel('disk',10));
%% Suppress extrema minutiae
[m,n]=size(K(:,:,1));
indTerm=sub2ind([m,n],CentroidTerm(:,1),CentroidTerm(:,2));
Z=zeros(m,n);
Z(indTerm)=1;
ZTerm=Z.*ROI';
[CentroidTermX,CentroidTermY]=find(ZTerm);
indBif=sub2ind([m,n],CentroidBif(:,1),CentroidBif(:,2));
Z=zeros(m,n);
Z(indBif)=1;
ZBif=Z.*ROI';
[CentroidBifX,CentroidBifY]=find(ZBif);
figure(7)
imshow(K)
hold on
imshow(ROI)
alpha(0.5)
hold on
plot(CentroidTermX,CentroidTermY,'ro','linewidth',2)
plot(CentroidBifX,CentroidBifY,'go','linewidth',2)
hold off
m1=max(length(CentroidTermX),length(CentroidTermY));
m2=max(length(CentroidBifX),length(CentroidBifY));
m3=max(m1,m2);
a1 = [CentroidTermX(1 : length(CentroidTermX),1); zeros([m3 - length(CentroidTermX), 1])];
a2 = [CentroidTermY(1 : length(CentroidTermY),1); zeros([m3 - length(CentroidTermY), 1])];
a3 = [CentroidBifX(1 : length(CentroidBifX),1); zeros([m3 - length(CentroidBifX), 1])];
a4 = [CentroidBifY(1: length(CentroidBifY),1); zeros([m3 - length(CentroidBifY),1])];
a5= [a1, a2, a3, a4] ;

%% Orientation
% Once we determined the differents minutiae, we have to find the
% orientation of each one
Table=[3*pi/4 2*pi/3 pi/2 pi/3 pi/4 
       5*pi/6 0 0 0 pi/6
       pi 0 0 0 0
      -5*pi/6 0 0 0 -pi/6
      -3*pi/4 -2*pi/3 -pi/2 -pi/3 -pi/4];
%% Termination Orientation 
% We have to find the orientation of the termination. 
% For finding that, we analyze the position of the pixel on the boundary of
% a 5 x 5 bounding box of the termination. We compare this position to the
% Table variable. The Table variable gives the angle in radian.
%OrientationTerm(ii,jj)=Table(1,length(CentroidTermX));
%OrientationTerm(:,:,1);
for ind=1:length(CentroidTermX)
    Klocal=K(CentroidTermY(ind)-2:CentroidTermY(ind)+2,CentroidTermX(ind)-2:CentroidTermX(ind)+2);
    Klocal(2:end-1,2:end-1)=0;
    [ii, jj]=find(Klocal);
   % if (~((isequal(i,5) && isequal(j,5))))
   % OrientationTerm(ind,1)=Table(i,j);
   if length(ii)~=1
        CentroidTermY(ind)=NaN;
        CentroidTermX(ind)=NaN;
        OrientationTerm(ind,1)=NaN;
   else
        OrientationTerm(ind,1)=Table(ii,jj);
   end
end
dxTerm=sin(OrientationTerm)*5;
dyTerm=cos(OrientationTerm)*5;
figure
imshow(K)
set(gcf,'position',[1 1 600 600]);
hold on
plot(CentroidTermX,CentroidTermY,'ro','linewidth',2)
plot([CentroidTermX CentroidTermX+dyTerm]',... 
     [CentroidTermY CentroidTermY-dxTerm]','r','linewidth',2)
 
%% Bifurcation Orientation
%  For each bifurcation, we have three lines. So we operate the same
%  process than in termination case three times.
% OrientationBif(ind)=0;
%    OrientationTerm(ii,jj)=Table(1,length(CentroidBifX));
for ind=1:length(CentroidBifX)
    Klocal=K(CentroidBifY(ind)-2:CentroidBifY(ind)+2,CentroidBifX(ind)-2:CentroidBifX(ind)+2);
    Klocal(2:end-1,2:end-1)=0;
    [ii,jj]=find(Klocal);
    if length(ii)~=3
        CentroidBifY(ind)=NaN;
        CentroidBifX(ind)=NaN;
        OrientationBif(ind)=NaN;
    else
        for k=1:3
            OrientationBif(ind,k)=Table(ii(k),jj(k));
            dxBif(ind,k)=sin(OrientationBif(ind,k))*5;
            dyBif(ind,k)=cos(OrientationBif(ind,k))*5;

        end
    end
end
for ind=1:length(CentroidBifX)
    for k=1:3
dxBif=dxBif(1:ind,k);
dyBif=dyBif(1:ind,k);
    end
end

plot(CentroidBifX,CentroidBifY,'go','linewidth',2)
%OrientationLinesX=[CentroidBifX CentroidBifX+dyBif(:,1);CentroidBifX CentroidBifX+dyBif(:,2);CentroidBifX CentroidBifX+dyBif(:,3)]';
%OrientationLinesY=[CentroidBifY CentroidBifY-dxBif(:,1);CentroidBifY CentroidBifY-dxBif(:,2);CentroidBifY CentroidBifY-dxBif(:,3)]';
%plot(OrientationLinesX,OrientationLinesY,'g','linewidth',2)
%% Validation
% In this step, we validate the minutiae (cf GUI)

%% Save in a text file
% In this step, we are going to save the minutia in a file
MinutiaTerm=[CentroidTermX,CentroidTermY,OrientationTerm];
MinutiaBif=[CentroidBifX,CentroidBifY];%OrientationBif];
name=filename;
saveMinutia(name,MinutiaTerm,MinutiaBif)

%s1 = size(MinutiaFin,1);
%s2 = size(MinutiaSep,1);
s1 = size(MinutiaTerm,1);
s2 = size(MinutiaBif,1);
A = {s1,s2}; xlswrite('bms.xlsx',A);
%output(k,1) = s1; %output(k,2) = s2;
% offset = offset + 1; end

%% Minutia Match
% Given two set of minutia of two fingerprint images, the minutia match
% algorithm determines whether the two minutia sets are from the same
% finger or not. 
% two steps:
% 1. Alignment stage
% 2. Match stage
%
% For this step, I would need a database I don't have...



%FOR EACH FINGERPRINT TEMPLATE, CALCULATE MATCHING SCORE IN COMPARISION WITH FIRST ONE
%S=zeros(JCount,1);
%for i=1:ICount
  %  second=['10' num2str(fix((j-1)/8)+1) '_' num2str(mod(j-1,8)+1)];
    fprintf(['Computing similarity between ' filename_q ' and ' filename ' from FVC2002 : ']);
    img=imread(filename);
    %ff{j}=ext_finger(img,1);
    ff=ext_finger(img,1);
    %imshow(ff{j})
    imshow(ff)
    figure(9)
    %S(j)=match(ffnew,ff{j},1);
    S(j)=match(ffnew,ff,1);
    T1=transform( ffnew, j );
    T2=transform( ff{j}, j );
    sm=score( T1, T2 );
    if (sm >0.50) 
        GAR=GAR+1; 
    else FRR=FRR+1; 
    end
   % s(i)=score(ffnew,ff{i});
    % xlswrite('bmss.xlsx',s);
   
    fprintf([num2str(S(j)) '\n']);
    fprintf([num2str(sm) '\n']);
    drawnow

display(GAR); 
display(FRR); 
fprintf(fid,'%f \t %f \n',GAR,FRR); 
fclose(fid);

Matched_FingerPrints=find(S > 0.65);

% GUI
% TODO: créer le GUI associé
end
end    
%index1 = index1 + IMPRESSIONS_PER_FINGER;
%end
  