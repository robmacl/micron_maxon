% read calibration data from hexapod calibration driver bunch_points.vi
% This file contains information about:
%  -- commanded hexapod pivot point and position
%  -- uncalibrated sensor signals
%  -- position and match error as reported by the labview ASAP code

function [measured, desired, pivot_point, uvw, asap_xyz, asap_error] = read_data_hex(filename, num_lights)

% measured: 
% This result data should be approximately in microns, but is not
% calibrated.  The result is a 3D array, with rows organized by
% sensor, not xyz:
%    [u1 v1 u2 v2 1]
%
% where:
%    x = u1
%    z1 = v1
%    y = u2
%    z2 = v2
%
% the third dimension is indexed by the light number.

% desired position (hexapod XYZ command)
% 2D array, each row:
%    [x y z 1]

% pivot_point (hexapod center of rotation)

% uvw Euler angles from hexapod, 2D array, each row:
%    [u v w]



FILE = fopen(filename);

nread = 0;
[nread, pivot_slice] = row_slicer(nread, 3);
[nread, hex_xyz_slice] = row_slicer(nread, 3);
[nread, hex_uvw_slice] = row_slicer(nread, 3);

% Demodulated signals: 2 sensors * 2 axes * 2 signals/axis = 8
% signals per light
[nread, demod_signals_slice] = row_slicer(nread, num_lights * 8);

% ASAP position:
[nread, asap_xyz_slice] = row_slicer(nread, num_lights * 3);

% Match error:
[nread, asap_error_slice] = row_slicer(nread, num_lights * 1);

rows = fscanf(FILE,'%f',[nread inf]);
rows = rows';
nrows = size(rows, 1);                        %get number of rows
pivot_point = pad_ones(rows(1, pivot_slice) * 1e3);
desired = pad_ones(rows(:, hex_xyz_slice) * 1e3);
uvw = rows(:, hex_uvw_slice);
demod = rows(:, demod_signals_slice);
asap_xyz = reshape(rows(:, asap_xyz_slice), nrows, 3, num_lights);
asap_error = rows(:, asap_error_slice);

fclose(FILE);

measured = ones(nrows, 5, num_lights);

for light_ix = 0:num_lights-1
  for axis_ix = 0:3
    a0 = demod(:, axis_ix*4 + light_ix + 1);      %this to read from the file (read columns --> vector)
    a1 = demod(:, axis_ix*4 + light_ix + 3);
    sum = a1 + a0;
    measured(:, axis_ix + 1, light_ix + 1) = (a1 - a0) ./ sum;
  end
end

for light_ix = 1:num_lights
  measured(:, :, light_ix) = measured(:, :, light_ix) * nominal_scale;
end
