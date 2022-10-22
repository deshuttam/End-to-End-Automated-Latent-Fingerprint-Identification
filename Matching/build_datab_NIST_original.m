function build_datab_NIST_original(cnt)
%cd  'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\';   
cd 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\NIST SD27\FingerNetAE LLAH\Original\';
    p=0;
    for i=1:cnt
       % if i~=8||i~=44
      % if ~(ismembertol(i, [44]))
            
     
            %filename=['t' num2str(mod(i-1,258)+1) '.bmp'];
            %filename='14.bmp';
            filename=[num2str(mod(i-1,258)+1) '.bmp'];
            disp([filename]);
            img = imread(filename); 
            imshow(img);
            %img = rgb2gray(img);
            img=imresize(img,[300,300]);
            p=p+1;
            if ndims(img) == 3
                img = rgb2gray(img); 
            end   % colour image
            disp(['extracting features from ' filename ' ...']);
            ff{p}=ext_finger_skeleton(img,1,filename);
            %ff{p}=ext_finger_FVC2004(img,1,filename);
      %   end
    end
    
    %save('dbskeleton.mat','ff');
     save('db.mat','ff');
    end


