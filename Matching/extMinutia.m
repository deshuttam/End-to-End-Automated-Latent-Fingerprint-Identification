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
function [a5] = extMinutia(I,K)
%fun=@minutie;
L = nlfilter(K,[3 3],@minutie);
LTerm=(L==1);
LTermLab=bwlabel(LTerm);
propTerm=regionprops(LTermLab,'Centroid')
CentroidTerm=round(cat(1,propTerm(:).Centroid));
figure(4)
imshow(K)
hold on
plot(CentroidTerm(:,1),CentroidTerm(:,2),'ro')
hold off
CentroidFinX=CentroidTerm(:,1);
CentroidFinY=CentroidTerm(:,2);
LSep=(L==3);
LSepLab=bwlabel(LSep);
propSep=regionprops(LSepLab,'Centroid','Image');
CentroidSep=round(cat(1,propSep(:).Centroid));
CentroidSepX=CentroidSep(:,1);
CentroidSepY=CentroidSep(:,2);
figure(5)
imshow(K)
hold on
plot(CentroidSepX,CentroidSepY,'g*')
hold off
figure(6)
imshow(K)
hold on
plot(CentroidTerm(:,1),CentroidTerm(:,2),'ro')
plot(CentroidSepX,CentroidSepY,'g*')
hold off
D=10;
% % Process 1
Distance=DistEuclidian(CentroidSep,CentroidTerm);
SpuriousMinutae=Distance < D;
[i, j] =find(SpuriousMinutae);
CentroidSepX(i)= [] ;
CentroidSepY(i)= [] ;
CentroidFinX(j)= [] ;
CentroidFinY(j)= [] ;
% % Process 2
D=7;
Distance=DistEuclidian(CentroidSep);
SpuriousMinutae=Distance < D;
[i, j] =find(SpuriousMinutae);
CentroidSepX(i)= [] ;
CentroidSepY(i)= [] ;
D=6;
% % Process 3
Distance=DistEuclidian(CentroidTerm);
SpuriousMinutae=Distance < D;
[i, j] =find(SpuriousMinutae);
CentroidTerm(i,:)=[];
Kopen=imclose(K,strel('square',7));
KopenClean= imfill(Kopen,'holes');
KopenClean=bwareaopen(KopenClean,5);
KopenClean(:,[1 end])=0;
ROI=imerode(KopenClean,strel('disk',10));
% % Suppress extrema minutiae
[m, n] =size(I(:,:,1));
indFin=sub2ind([m,n],CentroidTerm(:,1),CentroidTerm(:,2));
Z=zeros(m,n);
Z(indFin)=1;
size(ROI')
size(Z)
ZFin=Z.*ROI';
[CentroidFinX,CentroidFinY ] =find(ZFin);
indSep=sub2ind([m,n],CentroidBif(:,1),CentroidBif(:,2));
Z=zeros(m,n);
Z(indSep)=1;
ZSep=Z.*ROI';
[CentroidSepX,CentroidSepY] =find(ZSep);
figure(7)
imshow(I)
hold on
image(255*ROI)
alpha(0.5)
plot(CentroidFinX,CentroidFinY,'ro','linewidth',2)
plot(CentroidSepX,CentroidSepY,'go','linewidth',2)
hold off
m1=max(length(CentroidFinX),length(CentroidFinY));
m2=max(length(CentroidSepX),length(CentroidSepY));
m3=max(m1,m2);

a1 = [CentroidFinX(1 : length(CentroidFinX),1); zeros([m3-length(CentroidFinX), 1])];
a2 = [CentroidFinY(1 : length(CentroidFinY),1); zeros([m3-length(CentroidFinY ), 1])];
a3 = [CentroidSepX(1 : length(CentroidSepX),1); zeros([m3-length(CentroidSepX), 1])];
a4 = [CentroidSepY(1 : length(CentroidSepY),1); zeros([m3-length(CentroidSepY ), 1])];
a5= [a1, a2, a3, a4];


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
for ind=1:length(CentroidFinX)
    Klocal=K(CentroidFinY(ind)-2:CentroidFinY(ind)+2,CentroidFinX(ind)-2:CentroidFinX(ind)+2);
    Klocal(2:end-1,2:end-1)=0;
    [i, j]=find(Klocal);
    %[i,j]=find(Klocal,1,'first');
   % if (~((isequal(i,5) && isequal(j,5))))
   %OrientationTerm(ind,1)=Table(i,j);

   if length(i)~=1
       CentroidFinY(ind)=NaN;
        CentroidFinX(ind)=NaN;
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
plot(CentroidFinX,CentroidFinY,'ro','linewidth',2)
plot([CentroidFinX CentroidFinX+dyTerm]',... 
     [CentroidFinY CentroidFinY-dxTerm]','r','linewidth',2)
 
%% Bifurcation Orientation
%  For each bifurcation, we have three lines. So we operate the same
%  process than in termination case three times.
% OrientationBif(ind)=0;
%    OrientationTerm(ii,jj)=Table(1,length(CentroidBifX));
for ind=1:length(CentroidSepX)
    Klocal=K(CentroidSepY(ind)-2:CentroidSepY(ind)+2,CentroidSepX(ind)-2:CentroidSepX(ind)+2);
    Klocal(2:end-1,2:end-1)=0;
    [i,j]=find(Klocal);
    if length(i)~=3
        CentroidSepY(ind)=NaN;
        CentroidSepX(ind)=NaN;
        OrientationBif(ind)=NaN;
    else
        for k=1:3
            OrientationBif(ind,k)=Table(i(k),j(k));
            dxBif(ind,k)=sin(OrientationBif(ind,k))*5;
            dyBif(ind,k)=cos(OrientationBif(ind,k))*5;

        end
    end
end
% for ind=1:length(CentroidSepX)
%     for k=1:3
% dxBif=dxBif(1:ind,k);
% dyBif=dyBif(1:ind,k);
%     end
% end
% 
% plot(CentroidSepX,CentroidSepY,'go','linewidth',2)
% OrientationLinesX=[CentroidBifX+dyBif(:,1);CentroidBifX+dyBif(:,2);CentroidBifX+dyBif(:,3)]';
% OrientationLinesY=[CentroidBifY-dxBif(:,1);CentroidBifY-dxBif(:,2);CentroidBifY-dxBif(:,3)]';
% plot(OrientationLinesX,OrientationLinesY,'g','linewidth',2)
% %% Validation
% In this step, we validate the minutiae (cf GUI)

%% Save in a text file
% In this step, we are going to save the minutia in a file
CentroidFinX=seil(CentroidFinX);
CentroidFinY=seil(CentroidFinY);
OrientationTerm=seil(OrientationTerm);
OrientationBif=seil(OrientationBif);

MinutiaTerm=[CentroidFinX,CentroidFinY,OrientationTerm];
MinutiaBif=[CentroidSepX,CentroidSepY,OrientationBif];

name=filename;
saveMinutia(name,MinutiaTerm,MinutiaBif)

%s1 = size(MinutiaFin,1);
%s2 = size(MinutiaSep,1);
s1 = size(MinutiaTerm,1);
s2 = size(MinutiaBif,1);
A = {s1,s2}; 
xlswrite('bms.xlsx',A);
%output(k,1) = s1; %output(k,2) = s2;
% offset = offset + 1; end