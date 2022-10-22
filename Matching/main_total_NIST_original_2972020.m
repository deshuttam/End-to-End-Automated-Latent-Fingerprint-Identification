clear all; 
clc; 
addpath(genpath(pwd));


myFolder = 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\NIST SD27\FingerNetAE LLAH\Original\';
if exist(myFolder, 'dir') ~= 7
  Message = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(Message));
  return;
end

files = dir('F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\NIST SD27\FingerNetAE LLAH\Original\*.bmp');
%cd  'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\NIST SD27\Feng Skeleton\image\';
file_names = {files.name};
sheet = 1;
%filePattern = fullfile(myFolder, '*.bmp');
%jpegFiles   = dir(filePattern);

%rename_image(258);
%% BUILD FINGERPRINT TEMPLATE DATABASE
row=100;
col=6;
for i=1:258
ff{i} = 0 * zeros(row,col,1,'double');
end
%build_db(9,8);        %THIS WILL TAKE ABOUT 30 MINUTES
build_datab_NIST_original(258);
load('db.mat');

%% EXTRACT FEATURES FROM AN ARBITRARY FINGERPRINT

for k = 1:length(file_names)
 %baseFileName = jpegFiles(k).name;
 %fullFileName=fullfile(i);
 %fullFileName = fullfile(myFolder, baseFileName);
  rep_fname=files(k).name;

%rep_fname = fullFileName;
      pattern = '.bmp';
      replacement = '';
      res=regexprep(rep_fname,pattern,replacement);
      fn=sprintf('%s.xlsx',res);
      
     % replace_fname=res;
     % replace_fname(regexp(replace_fname,'t'))=[];
     % fin_result=str2double(replace_fname);
      
       
    %  data=ff{fin_result};
       data=ff{k};
    %  data=ff{1,char(res)};
      [m,n]=size(data);
      row=m;
      col=2;
 minutiae_i = 0 * ones(row,col,1,'uint8');
      for jj=1:m
      for ii=1:2
      minutiae_i(jj,ii,:)=data(jj,ii);
      end
      end
      xlswrite(char(fn),minutiae_i,sheet);
      %dat = xlsread(char(fn),sheet,xlRange);
  
     
end

