function [T, K, K_inv, measured, desired, F] = ...
    calibrate(data_dir, cal_dir, light_num, load_fmt)

% compute calibration for camera internal and external parameters to minimize
% reconstructed 3D error.
%
% The result is two transform matrices for each sensor.  T is the 6DOF camera
% pose or external calibration.  K is a transform that implements internal
% calibration for the sensor.  It maps an image plane (u,v) coordinate into an
% unnormalized direction vector in sensor coordinates.  K_inv is the standard
% camera transform, mapping a [x y z 1]' point into a [s*u s*v s] point (which
% must be normalized by s to get the uv position.)
%
% T, K and K_inv have three dimensions, the third being the sensor index
%
% The calibration result is also saved in the data directory as transform.mat
% for future use by read_calibrated_data(), etc.
%
% data_dir: directory holding calibration data and results.
% cal_file: transform.mat to use as basis for incremental calibration.  If
%   unsupplied or empty, find initial calibration using the Tsai C code.
% light_num: the light number to use for calibration
% load_format:
%   0: old style data.
%   1: hexapod calibration with 2 lights.
%   2: asap_calibration.vi output, number of lights determined by file.

if (nargin < 2 || isempty(cal_dir))
  cal_dir = data_dir;
end

if (nargin < 3 || isempty(light_num))
  light_num = 1;
end

if (nargin < 4 || isempty(load_fmt))
  load_fmt = [];
end

[measured, desired] = load_format(data_dir, load_fmt);
measured = measured(:,:,light_num); % pick which light to use.

if (~isempty(cal_dir))
  load([cal_dir 'transform.mat'], 'T', 'K', 'S');
  if (~exist('S', 'var'))
    S = [];
  end
  measured = rectify_sensor(measured, S);
  [Tfix, K, K_inv] = calibrate_3d(measured, desired, T, K);
else
  [Tfix1, K1, K_inv1, Cxy1] = tsai_calibrate(measured(:, 1:2), desired, ...
					     data_dir, 's1cal');
  
  [Tfix2, K2, K_inv2, Cxy2] = tsai_calibrate(measured(:, 3:4), desired, ...
					     data_dir, 's2cal');

  K = cat(3, K1, K2);
  K_inv = cat(3, K_inv1, K_inv2);
  Tfix = cat(3, Tfix1, Tfix2);
  S = [];
end

% Now we have to define the ASAP coordinates, as opposed to the
% fixture coordinates.  We construct the pose of ASAP in the
% fixture coordinates as follows:
% -- Y axis points straight out from camera pair (mean of two rays).  This is
%    pure depth. 
% -- Z is normal to the plane defined by the sensor axes, 
% -- X is defined orthogonal to YZ (lateral motion, no depth change.)
%
% Defined in this way, the resulting ASAP coordinates are
% completely indepenent of fixture coordinates at the time of
% calibration, and are defined purely by the geometry of the
% instrument itself.

[base_s1, dir_s1] = get_ray(Tfix, K, 1, [0, 0]);
[base_s2, dir_s2] = get_ray(Tfix, K, 2, [0, 0]);
origin = find_intersection(base_s2, dir_s2, base_s1, dir_s1);
origin_match_error = origin(4)
origin = origin(1:3);
y_basis = normalize((dir_s1(1:3) + dir_s2(1:3))/2)';
z_basis = normalize(cross(dir_s2(1:3), dir_s1(1:3)))';
x_basis = normalize(cross(y_basis, z_basis));

% F is the fixture transform, which represents the pose of ASAP in
% the fixture coordinates, or alternatively, transforms points and
% vectors in ASAP coordinates into fixture coordinates.
%
% This should be the same thing that is estimated by fixture_transform.m, but
% if the test pattern is symmetrical then the orientation can't be fully
% recovered by fixture_transform.m.  That function presumes some pre-existing
% calibration which we want to test the validity of, whereas here we are
% constructing the a-priori meaning of the ASAP coordinates which will be
% embodied in the calibration.
F = [x_basis y_basis z_basis origin'];
F = [F; 0 0 0 1];

% Now we need to find the correct T, the sensor pose in ASAP coordinates.
% What we have is Tfix, which is the sensor pose in fixture coordinates.  Tfix
% will generate rays in fixture coordinates, and we want to transform those
% into ASAP coordinates, so we must multiply by inv(F).
F_inv = inv(F);
T = cat(3, F_inv * Tfix(:, :, 1), F_inv * Tfix(:, :, 2));

savefile = [data_dir 'transform.mat'];
delete(savefile); % make sure old one is gone.
save(savefile, 'T', 'K', 'K_inv', 'S');

savefile = [data_dir 'calibration.dat'];
delete(savefile); % make sure old one is gone.
fid = fopen(savefile, 'w');

ns3 = diag([nominal_scale, nominal_scale, nominal_scale, 1]);
K_scaled = zeros(size(K));
for ix = 1:2
  K_scaled(:, :, ix) = K(:, :, ix) * ns3;
end

write_matrix(fid, 'T', T);
write_matrix(fid, 'K', K_scaled);
write_matrix(fid, 'S', S);
fclose(fid);
