# Huygens-Fresnel
Simulation of diffraction of electromagnetic waves phenomenas on any configurable planar 2D surfaces, using Huygens-Fresnel principle. Project submitted for physics professor (Dr. Boero) at EPFL.

This simulation uses matlab. The controllable parameters (situated in interferenceMain.m) are the wavelength of the incident light, the distance between the aperture and the wall, the density of the grid of the receiver/aperture, the troncation of the results for visibility, and finally the custom aperture.

By default the simulation is ran on a square, slit, double-slit, and circular aperture. The circular aperture can be replaced by any chosen binary image, representing any chosen aperture.

Default parameters:

```matlab
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
```

Default simulation results:

![Alt text](screenshots/CIRCLE_HIGH.png?raw=true "Title")

Image custom simulation:

- Aperture

<p align="center">
  <img src="https://raw.githubusercontent.com/AnonymHax/Huygens-Fresnel/master/star.bmp" width="200" height="200">
</p>

- Results

![Alt text](screenshots/STAR_HIGH.png?raw=true "Title")


The file to launch is interferenceMain.

Please note that s_pixel_size and r_pixel_size are the actual physical size of the source, and receiver discrete pixels; that compose the source and receiver plane, of side size of s_total_size, and r_total_size.

Therefore the computing complexity, is directly dependent on these parameters which you can play with (I recommend lowering s_pixel_size to improve results, or augment it to improve computing time):

O  ~ (r_total_size * s_total_size )^2 / (r_pixel_size * s_pixel_size)^2  /  NB_CORES_CPU


To compensate for GPU lack, I use multi-core support of CPU in the script, therefore the number of core also plays a direct role in the computing time. 

The necessary toolboxes which are not installed will now be displayed explicitly when running interferenceMain.m.

Note: If using a custom image for diffraction pattern, one need to be careful to use much higher definition than the final source size to have good results,
