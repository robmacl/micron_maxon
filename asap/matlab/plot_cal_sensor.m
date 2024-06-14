% Plot measured points in the sensor coordinates and also the ideal desired
% position according to the calibration.

function [] = ...
    plot_cal_sensor(measured, desired, F, T, K_inv, light_num, s_ix, ...
		    exaggeration)

if (nargin < 9)
  exaggeration = 30;
end

[measured_uv, desired_uv] = ...
    sensor_project(measured, desired, F, T, K_inv, light_num, s_ix);

fs = 0.75;

measured = measured_uv ./ nominal_scale;
calib = desired_uv ./ nominal_scale;

ex_uv = (measured - calib)*exaggeration + calib;
plot(calib(:,1), calib(:,2), 'ko', ...
     [ex_uv(:,1) calib(:,1)]', ...
     [ex_uv(:,2) calib(:,2)]', 'r.-', ...
     [-fs -fs fs fs -fs], [-fs fs fs -fs -fs], 'k-');
daspect([1 1 1]);
title(sprintf('Sensor %d', s_ix));
