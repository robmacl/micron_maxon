% ## This is format is used only for the old two-light ASAP
%
% read ASAP data file, convert to axis positions.  The result
% data should be approximately in microns, but is not calibrated.  The
% result is a 3D array, with rows organized by sensor, not xyz:
%    [u1 v1 u2 v2 1]
%
% where:
%    x = u1
%    z1 = v1
%    y = u2
%    z2 = v2
%
% the third dimension is indexed by the light number.
%
% The time values for each point are returned as the second value.

function [res, times, min_sum] = read_data_old(filename, num_lights);

FILE = fopen(filename);

% 2 sensors * 2 axes * 2 signals/axis = 8 signals per light, +1 for
% timestamp.
nread = num_lights * 8 + 1;
channels = fscanf(FILE,' %f',[nread inf]);
channels = channels';
times = channels(:,1);
channels = channels(:,2:nread); % discard time
fclose(FILE);

npoints = size(channels, 1);
res = ones(npoints, 5, num_lights);

min_sum = zeros(num_lights, 4);
for light_ix = 0:num_lights-1
  for axis_ix = 0:3
    a0 = channels(:, axis_ix*4 + light_ix + 1);
    a1 = channels(:, axis_ix*4 + light_ix + 3);
    sum = a1 + a0;
    min_sum(light_ix + 1, axis_ix + 1) = min(sum);
    res(:, axis_ix + 1, light_ix + 1) = (a1 - a0) ./ sum;
  end
end

for light_ix = 1:num_lights
  res(:, :, light_ix) = res(:, :, light_ix) * nominal_scale;
end
