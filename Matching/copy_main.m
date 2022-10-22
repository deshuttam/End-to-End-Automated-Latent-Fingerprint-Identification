

files = dir('H:\PhD\Software\Matlab\sc_minutia\sc_minutia\TEST\*.tif');
cd  'H:\PhD\Software\Matlab\sc_minutia\sc_minutia\TEST';


%files = dir('H:\PhD\Software\Matlab\sc_minutia\sc_minutia\IIITD_LDB_500ppi\*.bmp');
%cd  'H:\PhD\Software\Matlab\sc_minutia\sc_minutia\IIITD_LDB_500ppi\Minutiae';

%files = dir('H:\PhD\Software\Matlab\sc_minutia\sc_minutia\IIITD_LDB_1000ppi\*.bmp');
%cd  'H:\PhD\Software\Matlab\sc_minutia\sc_minutia\IITD_1000ppi_Minutiae\';


%files = dir('H:\PhD\Software\Matlab\sc_minutia\IIITD_LDB\*.jpg');
%cd  'H:\PhD\Software\Matlab\sc_minutia\sc_minutia\IIITD_LDB\Minutiae\';


IMPRESSIONS_PER_FINGER=1;
file_names = {files.name};

index1 = 1;
while index1 <=1
  finger_features=struct('X', [], 'TXT',[],'M', [], 'O', [], 'R', [], 'N', [], 'RO',[], 'OIMG', [], 'OREL', []); 
 %finger_features=struct('TXT',[],'M', [], 'O', [], 'R', [], 'RO',[], 'OIMG', [], 'OREL', []); 
  for i=0:IMPRESSIONS_PER_FINGER-1
       img = imread(char(file_names(index1 + i)));
       %img=imresize(img, [300,300] );
       [m,n]=size(img(:,:,1));
      %finger_features = extract_finger(files(index1).name);
    % finger_features = extract_finger(char(file_names(index1 + i)));
     finger_features = extract_finger_try_5_10_18(char(file_names(index1 + i)));
       file_a = file_names(index1 + i);
      
   %  file_a=files(index1).name;
     fOut = sprintf('%s.X', char(file_a));
    csvwrite(fOut, finger_features.X);
      
      fOut = sprintf('%s.txt', char(file_a));
      csvwrite(fOut, finger_features.TXT);
      fOut = sprintf('%s.m', char(file_a));
      csvwrite(fOut, finger_features.M);
      fOut = sprintf('%s.o', char(file_a));
      csvwrite(fOut, finger_features.O);
      fOut = sprintf('%s.r', char(file_a));
      csvwrite(fOut, finger_features.R);
      fOut = sprintf('%s.n', char(file_a));    
     csvwrite(fOut, finger_features.N); 
      fOut = sprintf('%s.ro', char(file_a));                                           
      csvwrite(fOut, finger_features.RO);   
      fOut = sprintf('%s.oi', char(file_a));                                           
      csvwrite(fOut, finger_features.OIMG);   
      fOut = sprintf('%s.or', char(file_a));                                           
      csvwrite(fOut, finger_features.OREL); 
      
       name=strrep(char(file_a),' ','_');
      filename = name;
      pattern = '.tif';
      replacement = '';
      res=regexprep(filename,pattern,replacement);
     FileName=[name '.txt']; 
      pattern = '.tif';
      replacement = '';
    grayImage = uint8(importdata(FileName));
     % imwrite(grayImage, [res, 'tif']);
     imwrite(grayImage,sprintf('%s.jpg',res));
     
   %  immg = imread(filename);
   % print(immg,'-dpdf',sprintf('%s.pdf', res));
   

   end

  file_a = file_names(index1);
 %file_a = substring(char(file_a), 0, strfind(char(file_a), '_')-2);
 str=strfind(char(file_a), '_')-2;
 %str1=str(1:1);
  %str=str-2;
 %str=(extractBefo(char(file_a),0))-2;
 file_a = strrep(char(file_a),'0','2');
  index1 = index1 + IMPRESSIONS_PER_FINGER;
end



