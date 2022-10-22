myFolder = 'F:\PhD\Software\Matlab\Fingerprint Enhancements\Fingerprint Enhancements\Fingerprint Enhancements\Enhancements\FingerNet After Enhancement\';
if exist(myFolder, 'dir') ~= 7
  Message = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(Message));
  return;
end
filePattern = fullfile(myFolder, '*.bmp');
jpegFiles   = dir(filePattern);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
 
  img = imread(fullFileName);
  
  filename = baseFileName;
  nn='';  
  str = filename;
  expression='_enh(\W*).bmp';
  replace =num2str(nn);%.jpg' ; %num2str(nn); 
  res=regexprep(str,expression,replace);
  fn=sprintf('%s.bmp',res);
  imwrite(img,fn);
end
 
