% Simulation of diffraction phenomena of light based Huygens-Fresnel principle

t= tic();
close all

% Simulation parameters

landa = 800*10^-9;           % Wavelength (m)

total_distance = 10;         % Distance between emitter and plane (m)

s_total_size = 0.08*10^-3;   % Emitter side size (infinite height for slits) (m)

s_d_slit_spacing = 10^-3;    % Double slit spacing (m)

r_total_size = 1;            % Receiver/screen total side size (m)

s_pixel_size = 2*10^-6;      % Source pixel size (m2)
r_pixel_size = 5*10^-4;      % Receiver pixel size(m2)

use_image = false;           % If set to 'true', will simulates image, if set to 'false', will simulate a circular hole of diameter s_total_size
image_name = 'star.bmp';     % Simulates the specified image, in which white is the hole, and black the cover (place image in directory with sources)

% Results display parameter - quantile selection of the truncated signal

q = 0.8;



% Checks toolboxes

if toolboxRequiredAndMissing() == true
    return
end

% Configures parameters

fprintf("Configuring parameters...\n")

parameters = configureParameters(landa,total_distance,s_total_size,s_d_slit_spacing,r_total_size,s_pixel_size,r_pixel_size,q,use_image,image_name);


% Results calculations

fprintf("Computing results...\n")

results = computeResults(parameters);

fprintf("Computing time: %1.2fsecs\n",toc(t))


% Displays results

fprintf("Preparing results...\n")

displayResults(results,parameters);


fprintf("Total time: %1.2fsecs\n",toc(t))
