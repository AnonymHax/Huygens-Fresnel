% Computes results
function results  = computeResults(parameters)

% Initialization of receivers grid (2 dimensional / 1 dimensional)
result_square = zeros(parameters.r_nb_pix, parameters.r_nb_pix);  % Square hole
result_image = zeros(parameters.r_nb_pix, parameters.r_nb_pix);   % 'Image' hole
result_s_slit = zeros(1, parameters.r_nb_pix);                    % Single slit
result_d_slit = zeros(1, parameters.r_nb_pix);                    % Double slit

% Creates a coordinate system for the receiver (for 2D source -> 2D receiver)
x = linspace( -parameters.r_total_size/2, parameters.r_total_size/2, parameters.r_nb_pix);
[r_2D_xGrid,r_2D_yGrid] = meshgrid(x);

% Creates a coordinate system for the receiver (for 1D source -> 1D receiver)
r_1D_xGrid = r_2D_xGrid(1,:);

% Creates a coordinate system for the source (hole - 2D source)
x = linspace( -parameters.s_total_size/2, parameters.s_total_size/2, parameters.s_nb_pix);
[s_2D_xGrid,s_2D_yGrid] = meshgrid(x);

% Creates a coordinate system for the source (single slit - 1D source - slit off-axis, only need one axis for horizontal symmetry reasons)
s_1D_single_xGrid = linspace( -parameters.s_total_size/2, parameters.s_total_size/2, parameters.s_nb_pix);

% Creates a coordinate system for the source (double slit - 1D source - slit off-axis, only need one axis for horizontal symmetry reasons)
s_1D_double_xGrid = linspace( -parameters.s_total_size-parameters.s_d_slit_spacing/2, -parameters.s_d_slit_spacing/2, parameters.s_nb_pix);

fprintf("Computing complexity ~ ( NB_SOURCE_PIXEL * NB_RECEIVER_PIXEL ) = ( %i^2 * %i^2 )\n", parameters.s_nb_pix, parameters.r_nb_pix);

% Calculates from each source pixel the contribution to every receiver pixel
parfor s_xi = 1:parameters.s_nb_pix
    
    % Parallel computing variable optimisation
    parameters_c = parameters;
    r_1D_xGrid_c = r_1D_xGrid;
    s_1D_single_xGrid_c = s_1D_single_xGrid;
    s_1D_double_xGrid_c = s_1D_double_xGrid;
    s_2D_xGrid_c = s_2D_xGrid
    s_2D_yGrid_c = s_2D_yGrid;
    r_2D_xGrid_c = r_2D_xGrid;
    r_2D_yGrid_c = r_2D_yGrid;
    
    % Result matrices initialization
    intensity_single_slit = zeros(1, parameters_c.r_nb_pix);
    intensity_double_slit = zeros(1, parameters_c.r_nb_pix);
    intensity_rect_hole = zeros(parameters_c.r_nb_pix);
    
    % One-dimensional slit experiments
    
    % Calculates the contribution from one pixel of the source for the all receiver pixels
    for r_xi=1:parameters_c.r_nb_pix
        
        intensity_single_slit(r_xi) = interferenceSlit(r_1D_xGrid_c(r_xi),parameters_c.total_distance,s_1D_single_xGrid_c(s_xi),parameters_c.k);
        intensity_double_slit(r_xi) = interferenceSlit(r_1D_xGrid_c(r_xi),parameters_c.total_distance,s_1D_double_xGrid_c(s_xi),parameters_c.k);
        
    end
    
    % Adds the result to the contribution to the already calculated receiver pixels
    result_s_slit = result_s_slit + intensity_single_slit;                                       % Single slit
    result_d_slit = result_d_slit + intensity_double_slit + fliplr(intensity_double_slit);       % Double slit (vertical symmetry for second slit)
    
    % Two-dimensional hole experiments
    for s_yi = 1:parameters_c.s_nb_pix
        
        % Calculates the contribution from one pixel of the source for the all receiver pixels
        for r_xi=1:parameters_c.r_nb_pix
            for r_yi = 1:parameters_c.r_nb_pix
                intensity_rect_hole(r_yi,r_xi) = interferenceRect(r_2D_xGrid_c(r_yi,r_xi),r_2D_yGrid_c(r_yi,r_xi),parameters_c.total_distance,s_2D_xGrid_c(s_yi,s_xi), s_2D_yGrid_c(s_yi,s_xi),parameters_c.k);
            end
        end
        
        % Adds the result to the contribution to the already calculated receiver pixels
        result_square = result_square + intensity_rect_hole;                                % Square slit
        result_image = result_image + intensity_rect_hole*parameters_c.image(s_yi,s_xi);     % Image hole 0 / 1 if the pixel is on
    end
end

% Elongate image of 1D single slit to make an image, as screen is
% vertically invariant (computitionally efficient)
result_s_slit = repmat(result_s_slit, [parameters.r_nb_pix 1]);
result_d_slit = repmat(result_d_slit, [parameters.r_nb_pix 1]);

% Calculates the intensity which is proportional to the square of the
% output amplitude
result_square = result_square.^2;
result_image  = result_image.^2;
result_s_slit = result_s_slit.^2;
result_d_slit = result_d_slit.^2;

results.square = result_square;
results.image  = result_image;
results.s_slit = result_s_slit;
results.d_slit = result_d_slit;

return