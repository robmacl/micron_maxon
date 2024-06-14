function [xyz, times, Fs] = ...
    read_calibrated_data(filename, num_lights, cal_file)

% Read asap data from filename and apply calibration, returning the
% data.
%
% cal_file is the .mat file holding the calibration transforms,
% default '..\cal_data\21x10\transform.mat'
%
% xyz is a N x 4 x 2 array.  Each row is a measurement:
%    (x, y, z, match_err)
%
% XYZ and match_err are in microns.  Match error is the distance by
% which the two measurement rays missed each other.  If this number
% is large, something is wrong.
%
% Dimension 3 selects the desired light, 1 or 2.
% 
% times are the timestamps of each data point and Fs is the
% sampling frequency.

if (nargin < 2 | isempty(num_lights))
  num_lights = 2;
end

if (nargin < 3 | isempty(cal_file))
  cal_file = '..\cal_data\21x10\transform.mat';
end

[data,times] = read_data_old(filename, num_lights);
Fs = (length(times) - 1)/(times(end) - times(1));
load(cal_file, 'T', 'K');
xyz = apply_calibration(T, K, data);
