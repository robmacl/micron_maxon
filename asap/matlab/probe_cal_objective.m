% State for minimization is: [C(1:3) pose(1:6)], where C is the position (in
% mm) of the light in the fixture (test pattern) coordinates and "pose" is a
% pose vector adjustment to F (fixture transform, pose of ASAP in fixture
% coordinates.).

function [err, measured_uv, desired_uv, desired_w] = ...
    probe_cal_objective(x, poses, measured, F, T, K_inv, ...
			light_ix, sensor_ix)

npoints = size(poses, 1);
C = x(1:3)*1e3;
delta_F = pvec2tr(x(4:9));

desired_xyz = zeros(npoints, 4);
for (ix = 1:npoints)
  desired_xyz(ix, :) = squeeze(poses(ix, :, :)) * [C 1]';
end

[measured_uv, desired_uv, desired_w] = ...
    sensor_project(measured, desired_xyz, delta_F * F, T, K_inv, ...
		   light_ix, sensor_ix); 

err = measured_uv - desired_uv;
