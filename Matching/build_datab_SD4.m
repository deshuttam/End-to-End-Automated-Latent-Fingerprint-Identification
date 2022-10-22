function build_datab_SD4(ICount)
        p=0;
    for i=1:ICount
            filename=['' num2str(mod(i-1,3500)+1) '.png'];
            img = imread(filename); 
           img=imresize(img, [300 300]);
            p=p+1;
            if ndims(img) == 3; img = rgb2gray(img);
            end   % colour image
            disp(['extracting features from ' filename ' ...']);
            ff{p}=ext_finger_FVC2004(img,1);
    end
    save('dbSD4.mat','ff');
    %save('dbfvc2004.mat','ff');
end

