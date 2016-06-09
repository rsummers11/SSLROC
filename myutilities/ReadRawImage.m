function x = ReadRawImage(filename, width, height)
% x = ReadRawImage(filename, width, height)
%
% Read a RAW DATA format image written by IPLAB.
% The raw image data is written as a series of signed
% short integers in row first order.
%
% 2/24/97 jdt wrote it
 

% Open file
id = fopen(filename, 'r');

% Read in the data.
x = fread(id, [width,height], 'short')';

% Close file
fclose(id);