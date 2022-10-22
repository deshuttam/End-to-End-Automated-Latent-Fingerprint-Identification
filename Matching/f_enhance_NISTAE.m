
%function [newim, binim, mask, reliability] =  f_enhance_fvc2004(im,filename)
function [ binim, mask, cimg1, cimg2, oimg1, oimg2 ] =  f_enhance_NISTAE(img,ind)     
    res = num2str(ind);  
    fn=sprintf('%s.bmp',res);
   % end
    enhimg =  fft_enhance_cubs(img,6);             % Enhance with Blocks 6x6
    enhimg =  fft_enhance_cubs(enhimg,12);         % Enhance with Blocks 12x12
    [enhimg,cimg2] =  fft_enhance_cubs(enhimg,24); % Enhance with Blocks 24x24
    
    % Identify ridge-like regions and normalise image
    blksze = 16; thresh = 0.1;
    [normim, mask] = ridgesegment(img, blksze, thresh);
    show(normim,1);
    
    % Determine ridge orientations
    [orientim, reliability] = ridgeorient(normim, 1, 5, 5);
    %plotridgeorient(orientim, 20, im, 2)
    %show(reliability,6)
    
    [enhimg,cimg1] =  fft_enhance_cubs(img, -1);
    [normim, mask] = ridgesegment(enhimg, blksze, thresh);
    [oimg2, reliability1] = ridgeorient(normim, 1, 5, 5); 
    
    % Determine ridge frequency values across the image
    blksze = 36; 
    [freq, medfreq] = ridgefreq(normim, mask, orientim, blksze, 5, 5, 15);
    show(freq,3) 
    
    % Actually I find the median frequency value used across the whole
    % fingerprint gives a more satisfactory result...
    freq = medfreq.*mask;
    
    % Now apply filters to enhance the ridge pattern
    newim = ridgefilter(normim, orientim, freq, 0.5, 0.5, 1);
    show(newim,4);
    
    % Binarise, ridge/valley threshold is 0
    binim = newim > 0;
    show(binim,5);
    imwrite(binim,fn);
    
   % show(binim.*mask.*(reliability>0.5), 7)
   % Display binary image for where the mask values are one and where
% the orientation reliability is greater than 0.5
relim = binim.*mask.*(reliability>0.5);
relim = relim > 0;
  % show(binim.*mask.*(reliability>0.5), 7)
  % figure(8), imagesc(relim);

out_im = relim;

%out_im = imresize(out_im, rescale);
%orientim = imresize(orientim, rescale);
%binim = imresize(binim, rescale);

  % figure(9), imagesc(out_im);
%figure(10), imagesc(orientim);
%figure(11), imagesc(orientim.*out_im);
%figure(12), imagesc(binim);
image = out_im(:,:,1);
[x1, x2] = find(image);
out_vec = [x1 x2];
orient_vec = oimg1(find(image));
orient_vec1= oimg2(find(image));

[neighborIds, neighborDistances] = kNearestNeighbors(orient_vec, orient_vec1, 3);
end
