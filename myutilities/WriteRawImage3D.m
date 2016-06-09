function [fid] = WriteRawImage3D(filename, Im)
% x = ReadRawImage(filename, width, height)
%
% Write image in RAW DATA format to an image.
% The raw image data is written as a series of signed
% short integers in row first order.
%
% 7/5/12 sw wrote it


fid=fopen(filename,'w+');
fwrite(fid, Im, 'uint16');
fclose(fid);

