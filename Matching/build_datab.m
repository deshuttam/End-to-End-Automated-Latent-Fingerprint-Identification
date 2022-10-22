function build_datab()
    p=0;
    for i=1:2
            filename=['10' num2str(fix((i-1)/8)+1) '_' num2str(mod(i-1,8)+1) '.tif'];
            img = imread(filename); 
            p=p+1;
            if ndims(img) == 3; 
                img = rgb2gray(img); 
            end   % colour image
            disp(['extracting features from ' filename ' ...']);
            ff{p}=ext_finger(img,1);
    end
    
    save('db.mat','ff');
    end


