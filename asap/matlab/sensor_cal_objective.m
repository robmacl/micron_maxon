% State for minimization is: [x y z Rx Ry Rz] pose vector for adjustment to
% F fixture transform.

function [err_uv, measured_uv, desired_uv] = ...
    sensor_cal_objective(x, desired, measured, F, T, K_inv, ...
			 light_ix, sensor_ix)

npoints = size(measured, 1);
delta_F = pvec2tr(x);

[measured_uv, desired_uv] = ...
    sensor_project(measured, desired, delta_F * F, T, K_inv, ...
		   light_ix, sensor_ix); 


% Don't use points that lie close to edge of sensor in minimizing pose
% error.  We know there is going to be sensor error there.
fs = 1;

m_uv = measured_uv/nominal_scale;
d_uv = desired_uv/nominal_scale;
clip_ix = find(abs(d_uv(:, 1)) > fs | abs(d_uv(:, 2)) > fs);
measured_uv(clip_ix,:) = [];
desired_uv(clip_ix,:) = [];
err_uv = measured_uv - desired_uv;
