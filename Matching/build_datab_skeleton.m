function build_datab_skeleton(cnt)
    p=0;
    for i=1:cnt
       % if i~=8||i~=44
      % if ~(ismembertol(i, [44]))
            
     
            filename=['t' num2str(mod(i-1,258)+1) '.bmp'];
            %filename=[num2str(mod(i-1,258)+1) '.bmp'];
            img = imread(filename); 
           % img = rgb2gray(img);
           % img=imresize(img,[300,300]);
            p=p+1;
            if ndims(img) == 3
                img = rgb2gray(img); 
            end   % colour image
            disp(['extracting features from ' filename ' ...']);
            ff{p}=ext_finger_skeleton(img,1,filename);
      %   end
    end
    
    save('dbskeleton.mat','ff');
     %save('dbskeletonfvc2004.mat','ff');
    end


