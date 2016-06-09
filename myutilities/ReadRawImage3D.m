function x = ReadRawImage3D(filename, size_scan)
% x = ReadRawImage(filename, width, height)
%
% Read a RAW DATA format image written by IPLAB.
% The raw image data is written as a series of signed
% short integers in row first order.
%
% 2/24/97 jdt wrote it
 
width = size_scan(1);
height = size_scan(2);
slice = size_scan(3);

% Open file
id = fopen(filename, 'r');

% Read in the data.
% x = fread(id, [width,height,slice], 'short')';
x = fread(id, width*height*slice, 'uint8')';

% Close file
fclose(id);