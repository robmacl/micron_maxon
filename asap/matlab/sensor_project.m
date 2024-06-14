% Using a calibration, project desired points into sensor plate.  Also
% extract the measured points for that sensor.  The result is two n by
% 2 arrays.  The values are in nominal scale units (sensor space
% microns.)

function [measured_uv, desired_uv, desired_w] = ...
    sensor_project(measured, desired, F, T, K_inv, light_num, s_ix)

% pull out data for this sensor
measured_uv = measured(:, [(s_ix-1)*2+1 (s_ix-1)*2+2], light_num);

% convert desired points into ASAP coords, then camera, then project, then
% normalize by (:,3), the linear homogenous scale factor (derived
% from the orginal point z).
calib_n = desired * inv(F)' * inv(T(:,:,s_ix))' * K_inv(:,:,s_ix)';
desired_w = calib_n(:,3);
desired_uv = (calib_n ./ repmat(desired_w, 1, 3));

% drop scale (now 1).
desired_uv = desired_uv(:,1:2);
