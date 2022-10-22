function rename_image(cnt)
   for i=1:cnt
 
            filename=['t' num2str(mod(i-1,258)+1) '.bmp'];
            img = imread(filename); 
            rep_fname = filename;
            pattern= '(\w)*.bmp';
            replacement = num2str(i); 
            res=regexprep(rep_fname,pattern,replacement);
           fn=sprintf('%s.bmp',res);
           imwrite(img,char(fn));  
    
   end
    end


