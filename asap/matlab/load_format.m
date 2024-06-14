% This function is deprecated.  See read_data.m for the new interface.
%
% load_format:
%   0: old style data.
%   1: hexapod calibration with 2 lights.
%   2: asap_calibration.vi output V1, num lights determined by file.
%   3: asap_calibration.vi output V2, num lights determined by file.

function [measured, desired, Rxyz] = load_format(data_dir, data_format, name)

if (nargin < 2)
  data_format = [];
end

if (nargin < 3)
  name = [];
end

if (isempty(name))
  name = 'calibration_ref.dat';
end

res = read_data([data_dir name], data_format);

measured = res.axis_pos;
desired = pad_ones(res.poses(:, 1:3, 1) * 1e3);
Rxyz = res.poses(:, 4:6, 1)*pi/180;
