% ENHANCING FINGERPRINT IMAGE
%
% Usage:  [ binim, mask, cimg, cimg2, orient_img, orient_img_m ] =
%          ... f_enhance( img );
%
% Argument:   img - FingerPrint Image
%               
% Returns:    binim   - binary image 
%             mask    - binary mask
%             cimg1,2 - coherence image
%             oimg1,2 - The orientation image in radians.

% Vahid. K. Alilou
% Department of Computer Engineering
% The University of Semnan
%
% July 2013

function [ binim, mask, cimg1, cimg2, oimg1, oimg2 ] = f_enhance_3420_NIST(img)

    enhimg =  fft_enhance_cubs(img,6);             % Enhance with Blocks 6x6
    enhimg =  fft_enhance_cubs(enhimg,12);         % Enhance with Blocks 12x12
    [enhimg,cimg2] =  fft_enhance_cubs(enhimg,24); % Enhance with Blocks 24x24
    blksze = 5;  thresh = 0.05; %thresh = 0.085;                  % FVC2002 DB1
    [normim,mask] = ridgesegment(enhimg, blksze, thresh);
  %  show(normim,1);
    [oimg1, reliability] = ridgeorient(normim, 1, 3, 3);          % FVC2002 DB1
   %    plotridgeorient(oimg1, 20, img, 2)
    %   show(reliability,6);

    
    [enhimg,cimg1] =  fft_enhance_cubs(img, -1);
    [normim, mask] = ridgesegment(enhimg, blksze, thresh);
     [oimg2, reliability1] = ridgeorient(normim, 1, 3, 3); 
    %    plotridgeorient(oimg2, 20, img, 2)
    %   show(reliability1,6);

    [freq, medfreq] = ridgefreq(normim, mask, oimg2, 32, 5, 5, 15);
    binim = ridgefilter(normim, oimg1, medfreq.*mask, 0.5, 0.5, 1) > 0;
    %imwrite(binim,fn);
    
    % Display binary image for where the mask values are one and where
% the orientation reliability is greater than 0.5
    relim = binim.*mask.*(reliability>0.7);
    relim = relim > 0;
  % show(binim.*mask.*(reliability>0.5), 7)
  
   %figure(8), imagesc(relim);

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