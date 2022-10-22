function build_datab_FVC2002(ICount, JCount)
cd 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\FVC2002\DB1_B\image\'
    p=0;
    for i=1:ICount
        for j=1:JCount
            if i==10
            filename=['1' num2str(mod(i-1,10)+1) '_' num2str(mod(j-1,8)+1) '.bmp']; 
            else
             filename=['10' num2str(mod(i-1,10)+1) '_' num2str(mod(j-1,8)+1) '.bmp'];
            end 
            img = imread(filename); 
           img=imresize(img, [300 300]);
            p=p+1;
            if ndims(img) == 3; img = rgb2gray(img); end   % colour image
            disp(['extracting features from ' filename ' ...']);
            ff{p}=ext_finger_FVC2004(img,1,filename);
        end
    end
    save('db.mat','ff');
    %save('dbfvc2004.mat','ff');
end

