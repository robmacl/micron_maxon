function [] = analyze_data(filename, light, cal_file)
% Read in a data from filename, convert to XYZ and altitude/azimuth info,
% then plot various stuff.
% 
% light is the number of the light to use for the XYZ info, 1 or 2,
% default 1.
% 
% cal_file is the .mat file holding the calibration transforms,
% default '..\cal_data\21x10\transform.mat'

  if (nargin < 2 | isempty(light))
    light = 1;
  end

  if (nargin < 3 | isempty(cal_file))
    cal_file = '..\cal_data\21x10\transform.mat';
  end

  [data, times, Fs] = read_calibrated_data(filename, cal_file);
  times = times - times(1);
  xyz = data(:,:,light);

  close all;
  figure(1);	
  plot(times, xyz(:,1), times, xyz(:,2), times, xyz(:,3));
  legend('X', 'Y', 'Z');
  xlabel('seconds');
  ylabel('microns');
  title('XYZ signals');
  
  figure(2);
  dirs = data(:,:,2) - data(:,:,1);
  for i = 1:size(dirs,1)
    dirs(i,:) = dirs(i,:)/norm(dirs(i,:));
  end

  % alt_az is a N x 2 array with the altitude and azimuth (in
  % radians) at each measurement.
  alt_az = [asin(dirs(:, 3)) atan2(dirs(:,2), dirs(:, 1))];
  plot(times, alt_az(:,1)*180/pi, times, alt_az(:,2)*180/pi);
  legend('altitude', 'azimuth');

  figure(3)
  plot3(xyz(:,1), xyz(:,2), xyz(:,3));
  xlabel('X');
  ylabel('Y');
  zlabel('Z');
  title('3D path');

  figure(4);
  xyz_mean = mean(xyz(:,1:3), 1)
  xyz_standard_dev = std(xyz(:,1:3), 1)
  [px, pxxc, f] = pmtm(xyz(:,1)-xyz_mean(1),[],[],Fs);
  [py, pxxc, f] = pmtm(xyz(:,2)-xyz_mean(2),[],[],Fs);
  [pz, pxxc, f] = pmtm(xyz(:,3)-xyz_mean(3),[],[],Fs);
  semilogy(f, px, f, py, f, pz);
  title('XYZ spectrum');
  legend('X', 'Y', 'Z');
  xlabel('frequency (Hz)');
  ylabel('power density (microns^2/Hz)');

  figure(5);
  alt_az_mean = mean(alt_az*180/pi, 1)
  alt_az_standard_dev = std(alt_az*180/pi, 1)
  [palt, pxxc, f] = pmtm(alt_az(:,1)*180/pi-alt_az_mean(1),[],[],Fs);
  [paz, pxxc, f] = pmtm(alt_az(:,2)*180/pi-alt_az_mean(2),[],[],Fs);
  semilogy(f, palt, f, paz);
  title('Altitude/azimuth spectrum');
  legend('altitude', 'azimuth');
  xlabel('frequency (Hz)');
  ylabel('power density (degrees^2/Hz)');

  figure(6);
  xyz_v = xyz(2:end,:) - xyz(1:size(data, 1)-1,:);
  % scale for Fs and also from microns/sec to meters/sec.
  xyz_v = [xyz_v; xyz_v(end,:)] .* Fs .* 1e-6;
  xyz_a = xyz_v(2:end,:) - xyz_v(1:size(data, 1)-1,:);
  xyz_a = [xyz_a; xyz_a(end,:)] .* Fs;
  speed = sqrt(sum((xyz_v*1e6).^2, 2));
  speed_dot = sqrt(sum((xyz_a/9.806*1e3).^2, 2));
  plot(times, speed/1e3)
  xlabel('seconds');
  ylabel('speed (mm/sec)');
  title('Linear speed');
  
  figure(7);
  plot(times, speed_dot);
  xlabel('seconds');
  ylabel('accel (mG)');
  title('Linear acceleration');

  figure(8)
  [p_v, pxxc, f] = pmtm(speed-mean(speed),[],[],Fs);
  [p_a, pxxc, f] = pmtm(speed_dot-mean(speed_dot),[],[],Fs);
  semilogy(f, p_v, f, p_a);
  title('Velocity/Acceleration spectrum');
  legend('velocity', 'acceleration');
  xlabel('frequency (Hz)');
  ylabel('power density');
