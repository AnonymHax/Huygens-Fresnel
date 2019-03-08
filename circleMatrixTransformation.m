% Generates a mask of a circle on the input matrix
%  input - Input matrix on which to apply mask
%  size - Diameter of circle mask
%  output - Output matrix on wich the mask was applied
function [output] = circleMatrixTransformation(input, size)
width = size;
height = size;
radius = floor(size/2);
centerW = width/2;
centerH = height/2;
[W,H] = meshgrid(1:width,1:height);
mask = ((W-centerW).^2 + (H-centerH).^2) < radius^2;
output = input .*mask;

return