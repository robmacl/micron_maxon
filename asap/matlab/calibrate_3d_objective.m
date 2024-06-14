function [err, measured_xyz, T, K, K_inv] = ...
    calibrate_3d_objective(x, measured, desired, F, start_Tfix)

global cal3d_x_scale cal3d_x_offset cal3d_match_weight;

T = zeros(4, 4, 2);
K = zeros(4, 4, 2);
K_inv = zeros(3, 4, 2);

for (s_ix = 1:2) 
  nom_x = x(s_ix, :).*cal3d_x_scale + cal3d_x_offset;
  T(:, :, s_ix) = inv(F) * start_Tfix(:, :, s_ix) * pvec2tr(nom_x(5:10));
  [K(:, :, s_ix), K_inv(:, :, s_ix)] = ...
      find_k(nom_x(1:2), nom_x(3), nom_x(4));
end

measured_xyz = apply_calibration(T, K, measured);

% Error is formed in fixture coordinates (in microns.)  It wouldn't entirely
% matter what coordinates we use as long as they are both the same.  We also
% throw the intersection error into the result with a lower weight so that we
% aren't particularly concerned about it, but we stick to the general idea of
% making the rays intersect.
match_err = measured_xyz(:, 4);
measured_xyz(:, 4) = 1;
measured_xyz = measured_xyz * F';
err = [measured_xyz(:, 1:3) - desired(:, 1:3) match_err*cal3d_match_weight];
