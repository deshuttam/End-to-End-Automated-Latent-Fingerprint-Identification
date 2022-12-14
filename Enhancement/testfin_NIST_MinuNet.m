
function [newim, binim, mask, reliability] =  testfin_NIST_MinuNet(im,filename)
    
    %if nargin == 0
	%im = imread('finger.png');
   % end
    
    % Identify ridge-like regions and normalise image
    blksze = 16; thresh = 0.1;
    [normim, mask] = ridgesegment(im, blksze, thresh);
    %show(normim,1);
    
    % Determine ridge orientations
    [orientim, reliability] = ridgeorient(normim, 1, 5, 5);
   % plotridgeorient(orientim, 20, im, 2)
   % show(reliability,6)
    
    % Determine ridge frequency values across the image
    blksze = 36; 
    [freq, medfreq] = ridgefreq(normim, mask, orientim, blksze, 5, 5, 15);
   % show(freq,3) 
    
    % Actually I find the median frequency value used across the whole
    % fingerprint gives a more satisfactory result...
    freq = medfreq.*mask;
    
    % Now apply filters to enhance the ridge pattern
    newim = ridgefilter(normim, orientim, freq, 0.5, 0.5, 1);
  %  show(newim,4);
    
    % Binarise, ridge/valley threshold is 0
    binim = newim > medfreq;
   % show(binim,5);
   % imwrite(binim,filename);
    
    % Display binary image for where the mask values are one and where
    % the orientation reliability is greater than 0.5
    relim=binim.*mask.*(reliability>0.3);
    relim=~relim;
   % show( relim, 7)
  % imwrite(relim,filename);
 