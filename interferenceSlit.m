% Calculates the contribution of one part of the emitter to one part of the
% receiver for an infinite vertical opening (no diffraction on Y axis)
% r_x - Receiver pixel position
% s_x - Emitter pixel position
% dist - Perpendicuar distance between the emitter and receiver
% k - Wave number
function out=interferenceSlit(r_x,dist,s_x, k)
    
    % Total distance
    distance = sqrt(dist^2 + (r_x - s_x)^2);
    
    % Relation for a 2D spherical wave
    out = (cos(k*distance)/sqrt(distance));
    
return