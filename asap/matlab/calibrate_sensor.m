function [res, fit_uv, measured_uv, err_uv] = ...
    calibrate_sensor(data_dir, sensor_ix, cal_dir, light_ix)
% Create portion of sensor calibration lookup table (S) for specified sensor.

if (nargin < 3 || isempty(cal_dir))
  cal_dir = data_dir;
end

if (nargin < 4 || isempty(light_ix))
  light_ix = 1;
end

load([cal_dir, 'transform.mat'], 'T', 'K', 'K_inv');

% This can be run on a 3D volume dataset (as used by calibrate.m).  Ordinarily
% we use planar data where the probe is kept oriented normal to the sensor
% (minimizing probe error contribution.)
data_3D = 0;

if (data_3D)
  fname = 'calibration_ref.dat';
else
  fname = sprintf('sensor%d_cal.dat', sensor_ix);
end

[measured, desired] = load_format(data_dir, [], fname);

if (data_3D)
  % fixture_transform works on a 3D dataset.  
  [F, xyz_calibrated] = ...
      cal_fixture_transform(T, K, measured, desired, light_ix);
else
  % Assuming data was taken with end transform (T) as constructed by
  % asap_stage_calibration using sensor 0/sensor 1 in "set home", then the end
  % transform was constructed from kinematic chain through ASAP to sensor, so
  % transform from end transform back to ASAP coordinates is just the inverse
  % of the transform from ASAP to sensor.  Only the rotation part is used
  % because that's what asap_stage_calibration does.
  % 
  % We can't use fixture_transform because pinv is ill-conditioned.
  Tz = T(:, :, sensor_ix);
  Tz(1:3, 4) = 0;
  F = inv(Tz);
  calibrated_both = apply_calibration(T, K, measured);
  xyz_calibrated = calibrated_both(:, :, light_ix) * F';
  xyz_calibrated(:, 4) = [];
end

% State for minimization is: [x y z Rx Ry Rz] pose vector for adjustment to
% F fixture transform.
% Intial value of x based on last run.  Even if the values are way off,
% have wrong signs, etc., the optimization runs much faster.  Perhaps this
% is because it establishes the correct order of magnitude.
if (~exist('x', 'var'))
  x = [1 1 1 1 1 1];
end

ofun = @(vec) ...
       sensor_cal_objective(vec, desired, measured, F, T, K_inv, ...
			    light_ix, sensor_ix);

if (1)
  options = optimset('MaxFunEvals', 2000);
%  options = optimset(options, 'PlotFcns', @optimplotresnorm);
  
  % State is in mm/degrees.
  x_max = [20 20 20 5 5 5];
  x_min = -x_max;
  
  [x,resnorm,residual,exitflag,output] = ...
      lsqnonlin(ofun, x, x_min, x_max, options);
  
  x
else
  x = [0 0 0 0 0 0];
end

[err_uv, measured_uv, desired_uv] = ofun(x);


% Interpolate data on grid.  Using interpolation at higher resolution than
% the actual data is beneficial because our interpolation here is more
% sophisticated than the bilinear interpolation used at runtime.  35 is in
% diminishing returns for a 20x20 mesh.  Note also that our test points
% don't cover the entire sensor, while the LUT does.  The fringe is
% extrapolated.  
nbins = 35;
xlin = linspace(-nominal_scale, nominal_scale, nbins);
[X,Y] = meshgrid(xlin, xlin);

% Set up fittype and options.
ft = fittype('biharmonicinterp');
opts = fitoptions(ft);
opts.Normalize = 'on';

% Fit model to data.
fit_u = fit(measured_uv, err_uv(:, 1), ft, opts);
fit_v = fit(measured_uv, err_uv(:, 2), ft, opts);
fit_uv = {fit_u, fit_v};

% Interpolate error surfaces on grid centers.
Zu = fit_u(X,Y);
Zv = fit_v(X,Y);

res = cat(3, Zu, Zv);


if (0)
% Plot error surfaces u and v vs. (u,v).  

figure;
surf(X, Y, Zu);
daspect([1, 1, 0.01])
title('u error');
xlabel('u (\mum)');
ylabel('v (\mum)');
zlabel('\Deltau (\mum)');

figure;
surf(X, Y, Zv);
daspect([1, 1, 0.01])
title('v error');
xlabel('u (\mum)');
ylabel('v (\mum)');
zlabel('\Deltav (\mum)');
end


figure;
set(gcf, 'Name', 'Sensor view');
plot_cal_sensor(measured, desired, pvec2tr(x) * F, T, K_inv, ...
		light_ix, sensor_ix, 30);


if (0)
% This is mainly to see if the point correspondance is grossly correct.
figure
s_xyz_desired = desired;
s_xyz_calibrated = xyz_calibrated;

% Convert back into ASAP coords.
F_inv = inv(F)';
s_xyz_desired = s_xyz_desired * F_inv;
s_xyz_calibrated = s_xyz_calibrated * F_inv;

[points,xs,ys,zs] = workspace_volume(T, K);

% Scale to cm
s_xyz_desired = s_xyz_desired * 1e-4;
s_xyz_calibrated = s_xyz_calibrated * 1e-4;
xs = xs * 1e-4;
ys = ys * 1e-4;
zs = zs * 1e-4;
plot3(s_xyz_desired(:,1),s_xyz_desired(:,2),s_xyz_desired(:,3),'ko', ...
      s_xyz_calibrated(:,1),s_xyz_calibrated(:,2),s_xyz_calibrated(:,3),'r+', ...
      [s_xyz_desired(:,1) s_xyz_calibrated(:,1)]', ...
      [s_xyz_desired(:,2) s_xyz_calibrated(:,2)]', ...
      [s_xyz_desired(:,3) s_xyz_calibrated(:,3)]', 'g:', ...
      xs, ys, zs, 'b', ... 
      'LineWidth', 2);
xlabel('x (cm)');
ylabel('y (cm)');
zlabel('z (cm)');
daspect([1 1 1]);
end
