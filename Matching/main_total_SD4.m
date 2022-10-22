clear all; 
clc; addpath(genpath(pwd));
myFolder = 'F:\PhD\Fingerprint Data Base\nist-special-database-4\';
if exist(myFolder, 'dir') ~= 7
  Message = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(Message));
  return;
end

%% BUILD FINGERPRINT TEMPLATE DATABASE
row=100;
col=6;
for i=1:3500
ff{i} = 0 * zeros(row,col,1,'double');
end
% build_db(9,8);        %THIS WILL TAKE ABOUT 30 MINUTES
%build_datab_FVC2004(10,8);
build_datab_SD4(10);
load('dbSD4.mat');
%%
    filePattern = fullfile(myFolder, '*.png');
    jpegFiles   = dir(filePattern);
for k = 1:length(jpegFiles)
    file_names = jpegFiles(k).name;
    fullFileName = fullfile(myFolder, file_names);
 
%file_names = {files.name};
sheet = 1;
%% EXTRACT FEATURES FROM AN ARBITRARY FINGERPRINT

%for k = 1:10%length(file_names)
  rep_fname=jpegFiles(k).name;
      pattern = '.png';
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

