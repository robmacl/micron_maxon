% Though perhaps becoming somewhat quaint, I've gone through the motions of
% supporting all of the old calibration data formats.  Possibly the format
% is through evolving, or at least the new result record format at least
% allows future added content without breaking existing code, and without
% an insane number of positional return values.
%
% filename: name of the file to load.  If no name part, then default to calibration_ref.dat
%
% load_format:
%   0: old style data.
%   1: hexapod calibration with 2 lights.
%   2: asap_calibration.vi output V1, num lights determined by file.
%   3: asap_calibration.vi output V2, num lights determined by file.

function [res] = read_data(filename, data_format)

if (nargin < 2)
  data_format = [];
end

if (isempty(data_format))
  data_format = 3;
end

[pathstr, name, ext] = fileparts(filename);
if (isempty(name))
  filename = [filename 'calibration_ref.dat'];
end

if (data_format == 3)  
  res = read_data_motion_v2(filename);
else
  Rxyz = [];
  if (data_format == 0)
    [measured, desired] = load_cal_points('calibrate_ref.dat', pathstr);
  elseif (data_format == 1)
    [measured, desired, Rxyz] = read_data_hex(filename, 2);
  elseif (data_format == 2)
    [measured, desired, Rxyz] = read_data_motion_v1(filename);
  else
    error('Unknown data format: %d', data_format);
  end
  res.axis_pos = measured;
  if (isempty(Rxyz))
    res.poses = [desired zeros(size(desired, 1), 3)];
  else
    res.poses = [desired Rxyz];
  end
end
