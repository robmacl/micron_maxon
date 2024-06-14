% Create an output file for use with check_calibration that contains both
% linear and angular stepping.  This is like a collision between mesh_grid
% and rot_mesh, without mesh_grid's point_toward function.
%
%  make_6DOF_mesh('check.dat', 3, 3, 3, 12.5, 2, 2, 2, 10);
%
function make_6DOF_mesh (out_file, tx, ty, tz, t_spacing, rx, ry, rz, r_spacing)

% Add "key" point, like mesh_grid
t_res = make_mesh(tx, ty, tz, t_spacing);
t_res = [t_res(1,:); (t_res(1,:) + t_res(2,:))*0.5; t_res(2:end,:)];

r_res = make_mesh(rx, ry, rz, r_spacing);

res = zeros(0, 6);

for ix=1:size(r_res, 1)
  res = [res; t_res repmat(r_res(ix, :), size(t_res, 1), 1)];
end

%plot the mesh grid
plot3(t_res(:,1), t_res(:,2), t_res(:,3), 'r-*');

grid on
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');

fprintf(1, '%d points\n', size(res, 1));
save(out_file,'res','-ascii','-tabs');
