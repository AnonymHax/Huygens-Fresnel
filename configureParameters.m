% Configures parameters
function parameters = configureParameters(landa,total_distance,s_total_size,s_d_slit_spacing,r_total_size,s_pixel_size,r_pixel_size,q,use_image,image_name)

parameters.landa = landa;
parameters.total_distance = total_distance;
parameters.s_d_slit_spacing = s_d_slit_spacing;
parameters.q = q;

parameters.k = (2*pi)/landa;             % Wave number

parameters.s_density = 1/s_pixel_size;   % Source density of pixel (pixel per m2)
parameters.r_density = 1/r_pixel_size;   % Receiver pixel density (pixel per m2)

parameters.s_nb_pix = ceil(s_total_size*(parameters.s_density));    % Source number of simulation pixels (per m)
parameters.r_nb_pix= ceil(r_total_size*(parameters.r_density));     % Receiver number of pixels (per m)

parameters.s_total_size = parameters.s_nb_pix*(s_pixel_size);       % Source rounding ajustments to total size
parameters.r_total_size = parameters.r_nb_pix*(r_pixel_size);       % Receiver rounding ajustments to total size

% Chooses the 'image' hole depending on the choice in parameters
if use_image == true
    parameters.image = imresize((double(imbinarize(rgb2gray(imread(image_name))))), [parameters.s_nb_pix parameters.s_nb_pix],'Antialiasing',true);
else
    parameters.image = imresize((circleMatrixTransformation(ones(100*parameters.s_nb_pix), 100*parameters.s_nb_pix)), [parameters.s_nb_pix parameters.s_nb_pix],'Antialiasing',true);
end

return