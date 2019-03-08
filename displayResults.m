% Display results
function displayResults(results,parameters)

% Empirical formula for size of denoising filter window, itself proportional to Airy disk size formula
res = ceil(parameters.landa/parameters.s_total_size*parameters.total_distance*parameters.r_density*8*10^-2);

smooth_square = envelope(results.square',res,'peak')';
smooth_image =  envelope(results.image',res,'peak')';
smooth_s_slit = envelope(results.s_slit',res,'peak')';
smooth_d_slit = envelope(results.d_slit',ceil(res/8),'peak')';

% Applies truncating filter on the signal, to make it easier to contrast
% the details of the diffraction pattern from the main spot + removes
% negative numbers which correspond to wrong denoising of the signal

% Finds the specified quantile value limit
q_square_limit = quantile(smooth_square(:),parameters.q);
q_image_limit  = quantile(smooth_image(:), parameters.q);
q_s_slit_limit = quantile(smooth_s_slit(:),parameters.q);
q_d_slit_limit = quantile(smooth_d_slit(:),parameters.q);

trunc_square = smooth_square;
trunc_image = smooth_image;
trunc_s_slit = smooth_s_slit;
trunc_d_slit = smooth_d_slit;

% Eliminates negative values of the denoised signal
trunc_square(trunc_square < 0) = 0;
trunc_image(trunc_image < 0) = 0;
trunc_s_slit(trunc_s_slit < 0) = 0;
trunc_d_slit(trunc_d_slit < 0) = 0;

% Truncates any value belonging to the excluded quantile
trunc_square(trunc_square > q_square_limit) = q_square_limit;
trunc_image(trunc_image > q_image_limit) = q_image_limit;
trunc_s_slit(trunc_s_slit > q_s_slit_limit) = q_s_slit_limit;
trunc_d_slit(trunc_d_slit > q_d_slit_limit) = q_d_slit_limit;

% Plots the intensity on the line traversing the middle of the
% receiver's screen, and plots the truncated (in amplitude) diffraction pattern

colormap('gray');

s = ['Troncated signal upper limit' newline sprintf('(top %1.0f %% of values)',parameters.q*100)];

subplot(4,2,1);
imagesc(trunc_square);
daspect([1 1 1]);
xticklabels = (-parameters.r_total_size/2):parameters.r_total_size/4:parameters.r_total_size/2;
xticks = linspace(1, parameters.r_nb_pix, numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', (xticklabels(:)));
yticklabels = (-parameters.r_total_size/2):parameters.r_total_size/4:parameters.r_total_size/2;
yticks = linspace(1, parameters.r_nb_pix, numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', (yticklabels(:)));
title(sprintf('Square hole screen - size : %1.2f um (denoised + troncated signal)', parameters.s_total_size*10^6));
xlabel('X-axis position (m)')
ylabel('Y-axis position (m)');
h = colorbar;
ylabel(h, 'Relative intensity')

subplot(4,2,2);
hold on
plot(linspace( -parameters.r_total_size/2, parameters.r_total_size/2, parameters.r_nb_pix), results.square(floor(parameters.r_nb_pix/2), :),'b');
plot(linspace( -parameters.r_total_size/2, parameters.r_total_size/2, parameters.r_nb_pix), smooth_square(floor(parameters.r_nb_pix/2), :),'r');
y = xlim;
plot([y(1) y(2)],[q_square_limit q_square_limit],'g')
hold off
title(sprintf('Square hole screen - size : %1.2f um', parameters.s_total_size*10^6));
xlabel('Horizontal cross-section position (m)')
ylabel('Relative intensity');
legend({'Original signal','Denoised signal',s})

subplot(4,2,3);
imagesc(trunc_image);
daspect([1 1 1]);
xticklabels = (-parameters.r_total_size/2):parameters.r_total_size/4:parameters.r_total_size/2;
xticks = linspace(1, parameters.r_nb_pix, numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', (xticklabels(:)));
yticklabels = (-parameters.r_total_size/2):parameters.r_total_size/4:parameters.r_total_size/2;
yticks = linspace(1, parameters.r_nb_pix, numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', (yticklabels(:)));
title(sprintf('''Image'' hole screen - size: %1.2f um (denoised + troncated signal)', parameters.s_total_size*10^6));
xlabel('X-axis position (m)')
ylabel('Y-axis position (m)');
h = colorbar;
ylabel(h, 'Relative intensity')

subplot(4,2,4);
hold on
plot(linspace( -parameters.r_total_size/2, parameters.r_total_size/2, parameters.r_nb_pix), results.image(floor(parameters.r_nb_pix/2), :), 'b');
plot(linspace( -parameters.r_total_size/2, parameters.r_total_size/2, parameters.r_nb_pix), smooth_image(floor(parameters.r_nb_pix/2), :),'r');
y = xlim;
plot([y(1) y(2)],[q_image_limit q_image_limit],'g')
hold off
title(sprintf('''Image'' hole screen - size: %1.2f um', parameters.s_total_size*10^6));
xlabel('Horizontal cross-section position (m)')
ylabel('Relative intensity');
legend({'Original signal','Denoised signal',s})

subplot(4,2,5);
imagesc(trunc_s_slit);
daspect([1 1 1]);
xticklabels = (-parameters.r_total_size/2):parameters.r_total_size/4:parameters.r_total_size/2;
xticks = linspace(1, parameters.r_nb_pix, numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', (xticklabels(:)));
yticklabels = (-parameters.r_total_size/2):parameters.r_total_size/4:parameters.r_total_size/2;
yticks = linspace(1, parameters.r_nb_pix, numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', (yticklabels(:)));
title(sprintf('Single slit screen - width %1.2f um (denoised + troncated signal)', parameters.s_total_size*10^6));
xlabel('X-axis position (m)')
ylabel('Y-axis position (m)');
h = colorbar;
ylabel(h, 'Relative intensity')

subplot(4,2,6);
hold on
plot(linspace( -parameters.r_total_size/2, parameters.r_total_size/2, parameters.r_nb_pix), results.s_slit(floor(parameters.r_nb_pix/2), :), 'b');
plot(linspace( -parameters.r_total_size/2, parameters.r_total_size/2, parameters.r_nb_pix), smooth_s_slit(floor(parameters.r_nb_pix/2), :),'r');
y = xlim;
plot([y(1) y(2)],[q_s_slit_limit q_s_slit_limit],'g')
hold off
title(sprintf('Single slit screen - width %1.2f um', parameters.s_total_size*10^6));
xlabel('Horizontal cross-section position (m)')
ylabel('Relative intensity');
legend({'Original signal','Denoised signal',s})

subplot(4,2,7);
imagesc(trunc_d_slit);
daspect([1 1 1]);
xticklabels = (-parameters.r_total_size/2):parameters.r_total_size/4:parameters.r_total_size/2;
xticks = linspace(1, parameters.r_nb_pix, numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', (xticklabels(:)));
yticklabels = (-parameters.r_total_size/2):parameters.r_total_size/4:parameters.r_total_size/2;
yticks = linspace(1, parameters.r_nb_pix, numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', (yticklabels(:)));
title(sprintf('Double slit screen - width %1.2f um / separation %1.2f mm (denoised + troncated signal)', parameters.s_total_size*10^6, parameters.s_d_slit_spacing*10^3));
xlabel('X-axis position (m)')
ylabel('Y-axis position (m)');
h = colorbar;
ylabel(h, 'Relative intensity')

subplot(4,2,8);
hold on
plot(linspace( -parameters.r_total_size/2, parameters.r_total_size/2, parameters.r_nb_pix), results.d_slit(floor(parameters.r_nb_pix/2), :),'b');
plot(linspace( -parameters.r_total_size/2, parameters.r_total_size/2, parameters.r_nb_pix), smooth_d_slit(floor(parameters.r_nb_pix/2), :),'r');
y = xlim;
plot([y(1) y(2)],[q_d_slit_limit q_d_slit_limit],'g')
hold off
title(sprintf('Double slit screen - width %1.2f um / separation %1.2f mm', parameters.s_total_size*10^6, parameters.s_d_slit_spacing*10^3));
xlabel('Horizontal cross-section position (m)')
ylabel('Relative intensity');
legend({'Original signal','Denoised signal',s})

sgtitle(sprintf('Diffraction patterns - wavelength : %1.0f nm / distance screen-(slit/hole) : %1.0f m', parameters.landa*10^9, parameters.total_distance));

end


