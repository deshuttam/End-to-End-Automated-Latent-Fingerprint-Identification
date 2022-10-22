% ————————————————————————————————–
%clearall; 
clc; 
addpath(genpath(pwd));
ICount = 9;
JCount = 8;
%build_datab();
%fprintf('Matching.');
load('db.mat');
%% EXTRACT FEATURES FROM AN ARBITRARY FINGERPRINT
[filename] = uigetfile('.jpg;  .png;  .tif;  .jpeg;  .bmp');
%img = imread(['F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\t1.bmp']);
img = imread(['F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\DB1_B\image\101_1.bmp']);
cd  'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\DB1_B\image';
%if ndims(img) == 3; img = rgb2gray(img); 
%end% Color Images
%ffnew=ext_finger(img,1);

%% FOR EACH FINGERPRINT TEMPLATE, CALCULATE MATCHING SCORE IN COMPARISION WITH FIRST ONE
%S=zeros(ICount*JCount,1);
%fprintf('..\n');
%S=zeros(2,1);
%for i=1:2
 %   second=['10' num2str(fix((i-1)/8)+1) '_' num2str(mod(i-1,8)+1)];
 %   fprintf(['Computing similarity between ' filename ' and ' second ' from FVC2002 : '])
%for i=1:ICount*JCount
%second=['10' num2str(fix((i-1)/8)+1) '_' num2str(mod(i-1,8)+1)];
%S(i)=match(ffnew,ff{i});
%drawnow
%end
%% OFFER MATCHED FINGERPRINTS
%Matched_FigerPrints=find(S>0.48);
%if size(Matched_FigerPrints,1)>0;
%disp('Fingerprint matched with database!');
%else
%disp('Fingerprint did not match with the database!');
%end
%

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
J=imadjust(img,[0.3;0.7],[]);
img(:,:,1)>160;
figure(2)
imshow(J)
% Ridge thining is to eliminate the redundant pixels of s till the 
% ridges are just one pixel wide.  
set(gcf,'position', [1 1 600 600]);
K=bwmorph(~J,'thin','inf');
figure(3)
imshow(~K)


%% extFinger Function
% ------------------------------------------------------------------------
%ffnew=load('ext_finger.m','img','K');
%disp(['Extracting features from ' filename ' ...']);
%load('fnmr.mat');
%load('fmr.mat');
%ffnew=ext_finger(img,1);
%imshow(ffnew)
%figure(8)
%filename='101_2.tif';
%img=imread(filename);
%ff{i}=ext_finger(img,1);
%imshow(ff{i})
%figure(9)
%[confusion_matrix, Fmeasure]=kNN();
%[ binim, mask, cimg, cimg2, orient_img, orient_img_m ] = f_enhance(img);
%[neighborIds, neighborDistances] = kNearestNeighbors(orient_img, orient_img_m, 3);

%% FOR EACH FINGERPRINT TEMPLATE, CALCULATE MATCHING SCORE IN COMPARISION WITH FIRST ONE
%{
S=zeros(2,1);
for i=1:2
    second=['10' num2str(fix((i-1)/8)+1) '_' num2str(mod(i-1,8)+1)];
    fprintf(['Computing similarity between ' filename ' and ' second ' from FVC2002 : ']);
    ff{i}=ext_finger(img,1);
    imshow(ff{i})
    figure(9)
    S(i)=match(ffnew,ff{i},1);
    T1=transform( ffnew, i );
    T2=transform( ff{i}, i );
    sm=score( T1, T2 );
    if (sm >0.50) 
        GAR=GAR+1; 
    else FRR=FRR+1; 
    end
   % s(i)=score(ffnew,ff{i});
    % xlswrite('bmss.xlsx',s);
   
    fprintf([num2str(S(i)) '\n']);
    fprintf([num2str(sm) '\n']);
    drawnow
end
display(GAR); 
display(FRR); 
fprintf(fid,'%f \t %f \n',GAR,FRR); 
fclose(fid);

Matched_FingerPrints=find(S > 0.65);
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
[i, j] =find(SpuriousMinutae);
CentroidBif(i,:)=[];
CentroidTerm(j,:)=[];
%% Process 2
D=7;
Distance=DistEuclidian(CentroidBif);
SpuriousMinutae=Distance < D;
[i, j] =find(SpuriousMinutae);
CentroidBif(i,:)=[];
CentroidTerm(j,:)=[];

D=6;
%% Process 3
Distance=DistEuclidian(CentroidTerm);
SpuriousMinutae=Distance<D;
[i,j]=find(SpuriousMinutae);
CentroidTerm(i,:)=[];
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
    [i, j]=find(Klocal);
   % if (~((isequal(i,5) && isequal(j,5))))
   % OrientationTerm(ind,1)=Table(i,j);
   if length(i)~=1
        CentroidTermY(ind)=NaN;
        CentroidTermX(ind)=NaN;
        OrientationTerm(ind,1)=NaN;
   else
        OrientationTerm(ind,1)=Table(i,j);
   end
end
dxTerm=sin(OrientationTerm)*5;
dyTerm=cos(OrientationTerm)*5;
figure
imshow(K)
set(gcf,'position',[1 1 600 600]);
hold on
%plot(CentroidTermX,CentroidTermY,'ro','linewidth',2)
%plot([CentroidTermX CentroidTermX+dyTerm]',... 
     %[CentroidTermY CentroidTermY-dxTerm]','r','linewidth',2)
 
%% Bifurcation Orientation
%  For each bifurcation, we have three lines. So we operate the same
%  process than in termination case three times.
% OrientationBif(ind)=0;
%    OrientationTerm(ii,jj)=Table(1,length(CentroidBifX));
for ind=1:length(CentroidBifX)
    Klocal=K(CentroidBifY(ind)-2:CentroidBifY(ind)+2,CentroidBifX(ind)-2:CentroidBifX(ind)+2);
    Klocal(2:end-1,2:end-1)=0;
    [i,j]=find(Klocal);
    if length(i)~=3
        CentroidBifY(ind)=NaN;
        CentroidBifX(ind)=NaN;
        OrientationBif(ind)=NaN;
    else
        for k=1:3
            OrientationBif(ind,k)=Table(i(k),j(k));
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
MinutiaTerm=[CentroidTermX,CentroidTermY]%,OrientationTerm];
MinutiaBif=[CentroidBifX,CentroidBifY];%OrientationBif];
name=filename;
saveMinutia(name,MinutiaTerm,MinutiaBif)

%s1 = size(MinutiaFin,1);
%s2 = size(MinutiaSep,1);
s1 = size(MinutiaTerm,1);
s2 = size(MinutiaBif,1);
A = {s1,s2}; xlswrite('bms.xlsx',A);
%output(k,1) = s1; %output(k,2) = s2;
% offset = offset + 1; 
%end

%% Minutia Match
% Given two set of minutia of two fingerprint images, the minutia match
% algorithm determines whether the two minutia sets are from the same
% finger or not. 
% two steps:
% 1. Alignment stage
% 2. Match stage
%
% For this step, I would need a database I don't have...



%% GUI
% TODO: créer le GUI associé

%end
%% ————————————————————————————————–

%{
%% Clustering 
% Create random data
[x1,y1] = pol2cart(2*pi*rand(1000,1),rand(1000,1));
[x2,y2] = pol2cart(2*pi*rand(1000,1),rand(1000,1)+2);
[x3,y3] = pol2cart(2*pi*rand(1000,1),rand(1000,1)+4);
X = [x1,y1; x2,y2; x3,y3];

% Transform to polar
[theta,rho] = cart2pol(X(:,1),X(:,2));
% k-means clustering
idx = kmeans(rho,3);

% Plot results
hold on
plot(X(idx==1,1), X(idx==1,2), 'r.')
plot(X(idx==2,1), X(idx==2,2), 'g.')
plot(X(idx==3,1), X(idx==3,2), 'b.')

%% K-means Segmentation (option: K Number of Segments)
% Alireza Asvadi
% http://www.a-asvadi.ir
% 2012
% Questions regarding the code may be directed to alireza.asvadi@gmail.com
%% initialize
clc
clear all
close all
%% Load Image
F = im2double(imread(['H:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\DB1_B\101_8.tif']));  
I=F;
% Load Image
%F = reshape(I,size(I,1)*size(I,2),3);                 % Color Features
%% K-means
K     = 8;                                            % Cluster Numbers
CENTS = F( ceil(rand(K,1)*size(F,1)) ,:);             % Cluster Centers
DAL   = zeros(size(F,1),K+2);                         % Distances and Labels
KMI   = 10;                                           % K-means Iteration
for n = 1:KMI
   for i = 1:size(F,1)
      for j = 1:K  
        DAL(i,j) = norm(F(i,:) - CENTS(j,:));      
      end
      [Distance, CN] = min(DAL(i,1:K));               % 1:K are Distance from Cluster Centers 1:K 
      DAL(i,K+1) = CN;                                % K+1 is Cluster Label
      DAL(i,K+2) = Distance;                          % K+2 is Minimum Distance
   end
   for i = 1:K
      A = (DAL(:,K+1) == i);                          % Cluster K Points
      CENTS(i,:) = mean(F(A,:));                      % New Cluster Centers
      if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
         NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
         for Ind = 1:size(NC,1)
         CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
         end
      end
   end
end

X = zeros(size(F));
for i = 1:K
idx = find(DAL(:,K+1) == i);
X(idx,:) = repmat(CENTS(i,:),size(idx,1),1); 
end
T = reshape(X,size(I,1),size(I,2),3);
%% Show
figure()
subplot(121); imshow(I); title('original')
subplot(122); imshow(T); title('segmented')
disp('number of segments ='); disp(K);
%}