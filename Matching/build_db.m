% BUILDING FINGERPRINT MINUTIAE DATABASE
%
% Usage:  build_db(ICount, JCount);
%
% Argument:   ICount -  Number of FingerPrints 
%             JCount -  Number of Images Per FingerPrint
%               

% Vahid. K. Alilou
% Department of Computer Engineering
% The University of Semnan
%
% July 2013

function build_db(ICount, JCount)
    p=0;
    for i=1:ICount
        for j=1:JCount
             filename=['10' num2str(fix((j-1)/8)+1) '_' num2str(mod(j-1,8)+1) '.tif'];
            img = imread(filename); 
            p=p+1;
            if ndims(img) == 3; img = rgb2gray(img); end   % colour image
            disp(['extracting features from ' filename ' ...']);
            ff{p}=ext_finger(img,1);
        end
            i=i+1;
    end
    save('db.mat','ff');
end