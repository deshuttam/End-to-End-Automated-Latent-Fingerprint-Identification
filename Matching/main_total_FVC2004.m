clear all; 
clc; addpath(genpath(pwd));

myFolder = 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\';
if exist(myFolder, 'dir') ~= 7
  Message = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(Message));
  return;
end

files = dir('F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\*.bmp');
file_names = {files.name};
sheet = 1;

%% BUILD FINGERPRINT TEMPLATE DATABASE
row=100;
col=6;
for i=1:2000
ff{i} = 0 * zeros(row,col,1,'double');
end
% build_db(9,8);        %THIS WILL TAKE ABOUT 30 MINUTES
%build_datab_FVC2004(10,8);
build_datab_FVC2004(1,2);
load('db.mat');

%% EXTRACT FEATURES FROM AN ARBITRARY FINGERPRINT

for k = 1:length(file_names)
  rep_fname=files(k).name;
      pattern = '.bmp';
      replacement = '';
      res=regexprep(rep_fname,pattern,replacement);
      fn=sprintf('%s.xlsx',res);
      
    %  replace_fname=res;
    %  replace_fname(regexp(replace_fname,'_'))=[];
    %  fin_result=str2double(replace_fname);
      
       
      data=ff{k};
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
         
end

