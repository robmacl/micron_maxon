function [base, dir] = get_ray(T, K, sensor, uv)

% Ray base is translation part of sensor pose transform (last column)
% Think of this as a coordinate transform on the origin (0 0 0 1)
base = (T(:,:,sensor) * [0 0 0 1]')';

% The ray direction is given by the inverse sensor projection function applied
% to the image plane position, normalized, then transformed into world
% coordinates.
dir = K(:,:,sensor) * [uv 0 1]';
dir = [dir(1:3)/norm(dir(1:3)); 0];
dir = (T(:,:,sensor) * dir)';
