% Calculates the contribution of one part of the emitter to one part of the
% receiver for a rectangular opening 
% r_x/r_y - Receiver pixel position
% s_x/s_y - Emitter pixel position
% dist - Perpendicuar distance between the emitter and receiver
% k - Wave number
function out=interferenceRect(r_x,r_y,dist,s_x,s_y, k)
    
    % Total distance
    distance = sqrt(dist^2 + (r_y-s_y)^2 + (r_x - s_x)^2);
    
    % Relation for a 3D spherical wave
    out = (cos(k*distance)/distance);
    
return