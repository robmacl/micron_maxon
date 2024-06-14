% read reference point locations and actual point data, returning
% the measured and desired positions.  Format of measured is:
%  [u1 v1 u2 v2 1]
% desired is:
%  [x y z]

function [measured, desired] = load_cal_points(ref_file, data_dir)
  [names,xd,yd,zd] = textread(ref_file,'%s%d%d%d');
  desired = [xd yd zd ones(size(xd, 1), 1)];
  measured = zeros(0, 5, 2);
  for i = 1:size(xd,1)
    points = mean(read_data_old([data_dir names{i}], 2));
    measured = [measured; points];
  end
