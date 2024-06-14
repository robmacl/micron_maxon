% Return the camera pose in fixture coordinates (Tfix), camera ray
% transform (K), camera projection transform (K_inv) the final optimization
% state (x) and the objective function (ofun)
%
% Fixture coordinates is whatever coordinates where the measured points are in
% fact in their desired positions.

function [Tfix, K, K_inv, x, ofun] = ...
  calibrate_3d(measured, desired, T, K)
 
% The fixture transform F converts points in ASAP coordinates into the
% coordinates of the pose in the data file.  That is, it is the pose of ASAP
% in fixture (in this case probe) coordinates.  This particular initial start_F
% value corresponds to our starting calibration ASAP coordinates so that the
% optimization can work with small deviations from that calibration.  At the
% end of calibration (elsewhere) we will generate a new F to remap our
% calibration results into the newly determined ASAP coordinates.

start_F = cal_fixture_transform(T, K, measured, desired, 1);

start_Tfix = zeros(4, 4, 2);
for ix = 1:2
  start_Tfix(:, :, ix) = start_F * T(:, :, ix);
end


global cal3d_x cal3d_x_scale cal3d_x_offset cal3d_match_weight;

% State for minimization is a 2D array, where each row is:
%  [Cxy(2) sx f delta_Tfix(6)]
% 
% ### It may be somewhat gratuitous to model the internal camera parameters
% Cxy and sx at all, given that we have an arbitrary warping in
% calibrate_sensor.m.  This could contribute to divergence of the
% calibration when a chain of sensor and 3d calibrations is repeated
%
% The values are scaled and offset so that they have nominal values of zero
% and a change in any value has roughly similar effect (an object space mm) on
% the error.  This improves the efficiency of the optimization.  To recover
% nominal units, use:
%   x(sensor_ix, :).*cal3d_x_scale + cal3d_x_offset
%
% To convert to optimization state:
%   (nom_x - cal3d_x_offset)./cal3d_x_scale
%
% In addition, the camera pose is implicitly offset by solving for a pose
% increment w.r.t. the start_Tfix.
% 

% Initial value for "x" is based on the last run, or all 1's.  Zero initial
% value seems bad for solver speed.
if isempty(cal3d_x)
  cal3d_x = ones(2, 10);
end

% Nominal focal length, um
start_f = 35e3; 

% Nominal sensor distance divided by focal length. Object space is this
% many times larger than sensor image.
tz_f = 6;

cal3d_x_scale = ...
    [1E3/tz_f 1E3/tz_f 1E3/(tz_f * nominal_scale) 1E3/tz_f ones(1, 6)];

cal3d_x_offset = ...
    [0 0 1 start_f zeros(1, 6)];


% Weight ray match error vs. point error.
cal3d_match_weight = 0.1;


% Bounds on x values.  This keeps the optimization from doing anything
% silly, and may speed it up.
x_max = ([2e3 2e3 1.05 start_f*1.5 5*ones(1, 6)] - cal3d_x_offset)./cal3d_x_scale;

ofun = @(x) ...
       calibrate_3d_objective(x, measured, desired, start_F, start_Tfix);
  options = optimset('MaxFunEvals', 2000);
  options = optimset(options, 'PlotFcns', @optimplotresnorm);
  
if (1)
  xm2 = repmat(x_max, 2, 1);
  [x,resnorm,residual,exitflag,output] = ...
      lsqnonlin(ofun, cal3d_x, -xm2, xm2, options);
  x;
else
  nom_x = [215.02 -94.387 	1.006788 34633 0 0 0 0 0 0
	   -39.398 -812.55	1.010982 34665 0 0 0 0 0 0];
  for (ix = 1:2)
    x(ix, :) = (nom_x(ix, :) - cal3d_x_offset)./cal3d_x_scale;
  end
end

nom_x = zeros(2, 10);
for ix = 1:2
  nom_x (ix, :) = x(ix, :).*cal3d_x_scale + cal3d_x_offset;
end

nom_x

cal3d_x = x;

[err, measured_xyz, T, K, K_inv] = ofun(cal3d_x);

Tfix = zeros(4, 4, 2);
for ix = 1:2
  Tfix(:, :, ix) = start_F * T(:, :, ix);
end

err_os = err(:, 1:3);
err_match = err(:, 4)./cal3d_match_weight;
fprintf(1, ['Object space error (microns):\n' ...
	    '  mean (%.1f %.1f %.1f)\n' ...
	    '  std (%.1f %.1f %.1f)\n' ...
	    '  rms %.1f max %.1f\n'], ...
	mean(err_os), std(err_os), norm(std(err_os)), ...
	max(sqrt(sum(err_os.^2, 2))));
fprintf('Ray match error (microns): RMS %.1f, max %.1f\n', ...
	sqrt(sum(err_match.^2)/length(err_match)), max(err_match));

if (0)
  % Point correspondance, for debugging.
  plot3([measured_xyz(:, 1) desired(:, 1)]', ...
	[measured_xyz(:, 2) desired(:, 2)]', ...
	[measured_xyz(:, 3) desired(:, 3)]', ...
	desired(:, 1), desired(:, 2), desired(:, 3), 'g*');
end
