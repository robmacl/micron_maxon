function [] = analyze_data(filename, light, cal_file, dec_by)
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

  if (nargin < 4 | isempty(dec_by))
    dec_by = 1;
  end

  [f_data, f_times, f_Fs] = read_calibrated_data(filename, 2, cal_file);
  Fs = f_Fs/dec_by;
  times = decimate(f_times, dec_by, 'fir');
  times = times - times(1);
  data = ones(size(times,1), 4, 2);
  for i = 1:3
    for j = 1:2
      data(:,i,j) = decimate(f_data(:,i,j), dec_by, 'fir');
    end
  end

  xyz = data(:,:,light);

  close all;
  figure(1);	
  plot(times, xyz(:,1), times, xyz(:,2), times, xyz(:,3));
  legend('X', 'Y', 'Z');
  xlabel('seconds');
  ylabel('microns');
  title('XYZ signals');
  
  figure(2);
  dirs = data(:,1:3,2) - data(:,1:3,1);
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
