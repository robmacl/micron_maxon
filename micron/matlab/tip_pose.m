% Given a micron trace data record like:
%  data(<some sample index>, :, :)
%
% reconstruct the tip pose and return it.
function [res] = tip_pose(data_rec)
  trace_defs;
  res = eye(4);
  data_rec = squeeze(data_rec);
  res(1:3, 1:3) = data_rec(:, micron_output_rotation_0:micron_output_rotation_2)';
  res(1:3, 4) = data_rec(:, micron_position_tip);
