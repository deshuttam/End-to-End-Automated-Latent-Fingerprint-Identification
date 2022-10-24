    
function [newim, binim, mask, reliability] =  testfin_FingerNet_fft(im,filename)
   img=im; 
   enhimg =  fft_enhance_cubs(img,6);             % Enhance with Blocks 6x6
    enhimg =  fft_enhance_cubs(enhimg,12);         % Enhance with Blocks 12x12
    [enhimg,cimg2] =  fft_enhance_cubs(enhimg,24); % Enhance with Blocks 24x24
    blksze = 5;  thresh = 0.05;                     %thresh = 0.085; FVC2002 DB1  
    % show(enhimg,10);                                               %thresh = 0.1; NIST SD27
    [normim,mask] = ridgesegment(enhimg, blksze, thresh);
   % show(normim,1);
    [oimg1, reliability] = ridgeorient(normim, 1, 3, 3);          % FVC2002 DB1
  % plotridgeorient(oimg1, 20, img, 2)
  % show(reliability,7);
    
    [enhimg,cimg1] =  fft_enhance_cubs(img, -1);
    [normim, mask] = ridgesegment(enhimg, blksze, thresh);
     [oimg2, reliability1] = ridgeorient(normim, 1, 3, 3); 
  %  plotridgeorient(oimg2, 20, img, 2)
  %  show(reliability1,6);

    [freq, medfreq] = ridgefreq(normim, mask, oimg2, 32, 5, 5, 15);
    newim = ridgefilter(normim, oimg1, medfreq.*mask, 0.5, 0.5, 0); % > 0;
 %   show(newim,6);
    % Binarise, ridge/valley threshold is 0
    binim = newim > medfreq;
        % Display binary image for where the mask values are one and where
    % the orientation reliability is greater than 0.5
 
 % show(binim.*mask.*(reliability>0.5), 7)
  
  relim=binim.*mask.*(reliability>0.5);
 % show(relim)
  %figure(8), imagesc(relim);
  imwrite(relim,filename);
  %K=bwmorph(relim,'thin','inf');
  %show(~K,6);
  %imwrite(~K,filename);
  %[newim, binim, mask, reliability] =  FingerNet_testfin_skelonly(~relim,filename);
  
end 


 