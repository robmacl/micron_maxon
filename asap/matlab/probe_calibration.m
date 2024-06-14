
data_dir='C:\Users\ram\Documents\work\Micron\asap\cal_data\SN1\probe_cal\';
if (1)
  data_name='result_12x15z80.dat';
  data_dims = [10 13];

  % Remove data points outside of these angle ranges.  The pattern should be
  % a grid pattern such that this removes entire rows or columns.  The
  % data_dims must be adjusted.
  rx_clip = [-21 inf]*pi/180;
  rz_clip = [-inf 30]*pi/180;
  light_ix = 1;

else

  light_ix = 2;
  data_name='result_12x15z80_new.dat';
  data_dims = [12 11];

  % Remove data points outside of these angle ranges.  The pattern should be
  % a grid pattern such that this removes entire rows or columns.  The
  % data_dims must be adjusted.
  rx_clip = [-inf inf]*pi/180;
  rz_clip = [-inf 20]*pi/180;
end  

cal_dir = 'C:\Users\ram\Documents\work\Micron\asap\cal_data\SN1\stage_new\';

sensor_ix = 1;

% Fixture transform F converts points in ASAP coordinates into the coordinates
% of the pose in the data file.  That is, it is the pose of ASAP in fixture
% (in this case probe) coordinates.  This should be the inverse the G^A (probe
% goal pose in ASAP coordinates) used in asap_stage_calibration.vi to
% establish the origin of the test pattern (via "set home" button.)
F = inv(pvec2tr([0 0 0 0 0 30])); % mm/degrees.

load([cal_dir, 'transform.mat'], 'T', 'K', 'K_inv', 'S');
if (~exist('S', 'var'))
  S = [];
end

Ts = squeeze(T(:,:,sensor_ix));

[measured, pose_xyz, Rxyz] = load_format(data_dir, [], data_name);
clip_mask = (Rxyz(:,1) < rx_clip(1)) | (Rxyz(:,1) > rx_clip(2)) ...
    | (Rxyz(:,3) < rz_clip(1)) | (Rxyz(:,3) > rz_clip(2));
measured(clip_mask, :, :) = [];
pose_xyz(clip_mask, :, :) = [];
Rxyz(clip_mask, :, :) = [];

measured = rectify_sensor(measured, S);
npoints = size(measured, 1);

poses = zeros(npoints, 4, 4);
for (ix = 1:npoints)
  poses(ix, :, :) = pvec2tr([pose_xyz(ix, 1:3)/1e3, Rxyz(ix, :)/pi*180]);
end


% State for minimization is: [C(1:3) pose(1:6)], mm X3, mm X3, degrees X3
% see probe_cal_objective.m
%
% Intial value of x based on last run.  Initial initial value is all ones,
% giving what is (in our scaling) a small initial value.  This makes
% optimization run much faster than all zeros, presumably because it
% establishes the correct order of magnitude.
if (~exist('x', 'var'))
  x = ones(1, 9);
end

ofun = @(vec) ...
       probe_cal_objective(vec, poses, measured, F, T, K_inv, ...
			   light_ix, sensor_ix);

if (1)
  options = optimset('MaxFunEvals', 2000);
%  options = optimset(options, 'PlotFcns', @optimplotresnorm);
  
  % We bound the translation adustment to F pose pretty tightly because
  % this is somewhat redundant with the other parameters and tends to run
  % away.  Allowing it to go farther than 100 um is unrealistic and doesn't
  % reduce the residue.  In particular, the y component tends to run away,
  % since it is normal to the sensor, and therefore hardly observable.
  % When the light is centered, the pose angles may not be very observable
  % either.  Ideally we should optimize this across all lights
  % simultaneously, but it's seeming that the probe error is small enough
  % that it may not be worth it.
  % 
  % Uh, except at the moment it seems we have large angle components, which
  % I guess is a way of saying that the F above isn't right.  It needs to
  % include the probe rotation w.r.t. ASAP, and stuff.
%  x_max = [20 20 20 1e-1 1e-1 1e-1 5 5 5];
  x_max = [20 20 20 1e1 1e1 1e1 90 90 90];

  [x,resnorm,residual,exitflag,output] = ...
      lsqnonlin(ofun, x, -x_max, x_max, options);
  
  x
else
  x = zeros(1, 9);
end


[err, measured_uv, desired_uv, desired_w] = ofun(x);
delta_F = pvec2tr(x(4:9));

fprintf(1, ['Image plane (uv) error (microns): mean (%.1f, %.1f) std ' ...
           '(%.1f, %.1f) rms %.1f max %.1f\n'], ...
       mean(err), std(err), norm(std(err)), max(sqrt(sum(err.^2, 2))));


figure(1)
% Sensor plane error and fitted model.  Display the sensor plane uv error
% in the XY plane and add the fitted model with a projected z component.
% The XY view is the actual sensor error residue, while the depth dimension
% helps to visualize the 3D shape of the model.

% Scaling on error displacement.
error_scale = 1;

% Measured location for display, equals "measured" when error_scale = 1,
% except we augment with a zero z value.
err_vec = zeros(npoints, 3);
for (ix = 1:npoints)
  err_vec(ix, :) = [desired_uv(ix, :) + err(ix, :) * error_scale, 0];
end

inv_Ts = inv(Ts);
desired_uvw = [desired_uv (desired_w - inv_Ts(3, 4))];

% Make into 2D arrays so that we can plot lines linking columns in the
% test pattern and result.  Improves 3D visualization.
err_vec_2d = reshape(err_vec, [data_dims 3]);
desired_uvw_2d = reshape(desired_uvw, [data_dims 3]);

plot3([desired_uvw(:, 1) err_vec(:, 1)]', ...
      [desired_uvw(:, 2) err_vec(:, 2)]', ...
      [desired_uvw(:, 3) err_vec(:, 3)]', 'r:', ...
      err_vec_2d(:, :, 1), err_vec_2d(:, :, 2), err_vec_2d(:, :, 3), ...
      desired_uvw_2d(:, :, 1), desired_uvw_2d(:, :, 2), desired_uvw_2d(:, :, 3), ...
      'g.' ...
      );

%daspect([1 1 1]);
title('Sensor plane error and fitted 3D model')
xlabel('x (um)');
ylabel('y (um)');

if (1)
% Residue surfaces

Rxyz_d = Rxyz/pi*180;
S1 = measured_uv - desired_uv;

u = reshape(S1(:,1), data_dims);
v = reshape(S1(:,2), data_dims);

Rx = reshape(Rxyz_d(:,1), data_dims);
Rx = Rx(:,1);

Rz = reshape(Rxyz_d(:,3), data_dims);
Rz = Rz(1,:);

figure(2);
surf(Rz, Rx, u);
ylabel('Rx (deg)');
xlabel('Rz (deg)');
zlabel('uv delta (um)');
daspect([1 1 1]);
title('u change');

figure(3)
surf(Rz, Rx, v);
ylabel('Rx (deg)');
xlabel('Rz (deg)');
zlabel('uv delta (um)');
daspect([1 1 1]);
title('v change');

figure(4);
[rx, ry, udx, udy] = surf_deriv(Rz, Rx, u);
surf(rx, ry, sqrt(udy.^2+udx.^2))
ylabel('Rx (deg)');
xlabel('Rz (deg)');
zlabel('du (\mum/degree)');
daspect([1 1 .05])
title('du/dRx du/dRz, vector sum');

figure(5)
[rx, ry, vdx, vdy] = surf_deriv(Rz, Rx, v);
surf(rx, ry, sqrt(vdy.^2+vdx.^2))
ylabel('Rx (deg)');
xlabel('Rz (deg)');
zlabel('du (\mum/degree)');
daspect([1 1 .05])
title('dv/dRx dv/dRz, vector sum');

figure(6)
surf(rx, ry, sqrt(udy.^2+udx.^2+vdy.^2+vdx.^2))
ylabel('Rx (deg)');
xlabel('Rz (deg)');
zlabel('|du + dv| (\mum/degree)');
daspect([1 1 .05])
title('du + dv, vector sum');

end
