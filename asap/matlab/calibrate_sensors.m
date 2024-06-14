function [] = ...
    calibrate_sensors(data_dir, cal_dir, light_ix)
% Do PSD calibration on both sensors.  See calibrate_sensor for arg details.
% This is based on sensor{1,2}_cal.dat, and the result is store in
% transform.mat.  To make it accessible to the labview code (in
% calibration.dat), you need to do calibrate.m afterward.
if (nargin < 2 || isempty(cal_dir))
  cal_dir = data_dir;
end

if (nargin < 3 || isempty(light_ix))
  light_ix = 1;
end

load([data_dir, 'transform.mat'], 'T', 'K', 'K_inv', 'S');
if (~exist('S', 'var'))
  S = [];
end

S1 = calibrate_sensor(data_dir, 1, cal_dir, light_ix);
rsize = [size(S1), 2];
if (size(S, 1) ~= size(S1, 1))
  S = zeros(rsize);
  S(:, :, :, 1) = S1;
end

S(:, :, :, 2) = calibrate_sensor(data_dir, 2, cal_dir, light_ix);

save([data_dir, 'transform.mat'], 'T', 'K', 'K_inv', 'S');
