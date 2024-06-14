function [max_err_pct, rms_err, xyz_desired, xyz_calibrated, error_angles, F] = ...
    check_calibration(data_dir, cal_file, light_num, data_format, runtime)
% Check a calibration data set against a calibration.  
% 
% Arguments:
% data_dir: Holds the calibration data file. Name defaults to calibration_ref.dat
%
% cal_file: The calibration to be checked (default data_dir/transform.mat)
%
% light_num: which light to check calibration for (default 1)
% 
% data_format: see read_data(), defaults to current format.
%
% runtime: if 1 (default 0), check runtime position rather than position
% computed from raw signals.

% Return values:
% max_err_pct: maximum matching error as % of displacement
% rms_err: xyz rms_point match error.
% 
% xyz_desired, xyz_calibrated: the desired 3d points,
% measured points and points after calibration.
% 
% error_angles: angular mismatch between each measurement point and
% the mean orientation.  Assuming the actual orientation is fixed,
% this is a measure of the cross-coupling from translation to
% orientation.
% 
% F: the fixture transform.
    
 close all
 
 if (nargin < 2 || isempty(light_num))
    light_num = 1;
  end
  if (nargin < 3 || isempty(cal_file))
    cal_file = [fileparts(data_dir) '/transform.mat'];
  end
  if (nargin < 4 | isempty(data_format))
    data_format = [];
  end
  if (nargin < 5 | isempty(runtime))
    runtime = 0;
  end

  load(cal_file, 'T', 'K', 'K_inv', 'S');
  if (~exist('S', 'var'))
    S = [];
  end

  res = read_data(data_dir, data_format);
  unrectified = res.axis_pos;
  xyz_desired = pad_ones(res.poses(:, 1:3, 1) * 1e3);

  if (runtime)
    % Check runtime position solution.
    xyz_calibrated = res.light_pos;
    match_err = res.match_err;

    % Drop out bad points.
    xyz_calibrated(~res.valid, :, :) = [];
    xyz_desired(~res.valid, :, :) = [];
    match_err(~res.valid, :) = [];
    [F, xyz_calibrated] = ...
	fixture_transform(xyz_calibrated, xyz_desired, light_num);
  else
    measured = rectify_sensor(unrectified, S);
    [F, xyz_calibrated, match_err] = ...
	cal_fixture_transform(T, K, measured, xyz_desired, light_num);
  end

  err = xyz_calibrated(:, 1:3, light_num) - xyz_desired(:, 1:3);
  rms_err = sum(err.^2 / size(xyz_desired,1)).^(1/2);

  % first col magnitude of desired pos, second, error magnitude.
  err_info = [sqrt(sum(xyz_desired(:, 1:3).^2, 2)) sqrt(sum(err.^2, 2))];

  % Drop cal points < 100 microns magnitude (e.g. origin), as the displacement is
  % zero, so % error is undefined.
  origins = find(err_info(:,1)<100);
  err_info(origins,:) = [];
  err_info = [err_info err_info(:,2)./max(err_info(:,1), 1e-6)*100];
  max_err_pct = max(err_info(:,3));
  fprintf(1, 'Max position error %5.0f (%4.2f%% of reading).\n', ...
	  max(err_info(:,2)), max_err_pct);
  match_err = match_err(:, light_num);
  fprintf(1, 'Max intersection error %.0f microns, rms %.0f microns.\n', ...
	  max(match_err), sqrt(sum(match_err.^2)/size(xyz_calibrated, 1)));
  
  figure(1);
  set(gca, 'FontSize', 20, 'LineWidth', 2);
  xyz_exaggeration = 100; % increase matching error by this factor.
  ex_xyz = (xyz_calibrated(:, :, light_num) - xyz_desired)*xyz_exaggeration ...
	   + xyz_desired;
  s_xyz_desired = xyz_desired;

  % Convert back into ASAP coords.
  F_inv = inv(F)';
  ex_xyz = ex_xyz * F_inv;
  s_xyz_desired = s_xyz_desired * F_inv;

  [points,xs,ys,zs] = workspace_volume(T, K);
  % Scale to cm
  ex_xyz = ex_xyz * 1e-4;
  s_xyz_desired = s_xyz_desired * 1e-4;
  xs = xs * 1e-4;
  ys = ys * 1e-4;
  zs = zs * 1e-4;
  plot3(s_xyz_desired(:,1),s_xyz_desired(:,2),s_xyz_desired(:,3),'ko', ...
	[ex_xyz(:,1) s_xyz_desired(:,1)]', ...
  	[ex_xyz(:,2) s_xyz_desired(:,2)]', ...
	[ex_xyz(:,3) s_xyz_desired(:,3)]', 'r.-', ...
	xs, ys, zs, 'b', ... 
	'LineWidth', 2);

  set(gcf, 'Name', ...
	   sprintf('XYZ errors (%dX)', xyz_exaggeration));
  grid on;
  daspect([1,1,1]);
  xlabel('x');
  ylabel('y');
  zlabel('z');

if (0)
  figure(2);
  set(gcf, 'Name', 'Ray intersection error');
  plot3(xyz_desired(:,1), xyz_desired(:,2), calibrated(:,4), 'd-');
  xlabel('x');
  ylabel('y');
  zlabel('ray error');
end

  figure(3);

  % direction vectors for orientation at each point.
  dirs = xyz_calibrated(:, 1:3, 2) - xyz_calibrated(:, 1:3, 1);
  for i = 1:size(dirs,1)
    dirs(i,:) = dirs(i,:)/norm(dirs(i,:));
  end

  % find angle difference between the mean direction and direction
  % at each point.
  mean_dir = mean(dirs);
  angles = [];
  for i = 1:size(dirs,1)
    angles = [angles acos(dot(mean_dir, dirs(i,:)))];
  end
  error_angles = angles * 180/pi;
  fprintf(1, 'Max error angle: %.2f degrees\n', max(abs(error_angles)));

  % visualization of exaggerated angular errors.  This is visualized as a
  % displacement vector of the position error due to the anglar error over
  % a long moment arm.
  vector_len = 2500; % length of sample direction vector.
  exaggeration = 30; % exaggeration of vector divergence
  moment_arm = vector_len * exaggeration;
  err_vecs = zeros(0, 3, 0);
  for i = 1:size(dirs,1)
    vec = mean_dir*moment_arm - dirs(i,:)*moment_arm;
    base = xyz_desired(i, 1:3);
    v_end = base + mean_dir*vector_len;
    err_vecs(i, :, 1) = base;
    err_vecs(i, :, 2) = v_end;
    err_vecs(i, :, 3) = v_end + vec;
  end

  Xs = squeeze(err_vecs(:,1,:))'*1e-4;
  Ys = squeeze(err_vecs(:,2,:))'*1e-4;
  Zs = squeeze(err_vecs(:,3,:))'*1e-4;
  set(gca, 'FontSize', 15, 'LineWidth', 2);
  plot3(Xs(2,:), Ys(2,:), Zs(2,:), 'go', ...
	Xs(3,:), Ys(3,:), Zs(3,:), 'r+', ...
	Xs(1:2,:), Ys(1:2,:), Zs(1:2,:), 'g-', ...
	Xs([1 3],:), Ys([1 3],:), Zs([1 3],:), 'r-', ...
	'LineWidth', 2);
  grid on;
  daspect([1,1,1]);
  legend('Desired', 'Actual', 'Location', 'NorthOutside');

  set(gcf, 'Name', sprintf('Angular errors (%dX)', exaggeration));
  xlabel('x');
  ylabel('y');
  zlabel('z');

  if (~runtime)
    figure(5);
    set(gcf, 'Name', 'Sensor 1');
    plot_cal_sensor(measured, xyz_desired, F, T, K_inv, light_num, 1);
    figure(6);
    set(gcf, 'Name', 'Sensor 2');
    plot_cal_sensor(measured, xyz_desired, F, T, K_inv, light_num, 2);
  end
