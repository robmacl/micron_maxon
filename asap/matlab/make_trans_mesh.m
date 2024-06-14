function make_trans_mesh (out_file, x, y, z, spacing, point_toward, rot_from)
% Mesh a rectangular XYZ volume.  Spacing is in mm, while XYZ are the number of
% planes in that direction.  Total size is then (XYZ - 1) * spacing.  The
% volume is centered on the origin.  An additional point is added midway
% between the first and second points, making the pattern asymmetrical to
% "key" the rotation.
%
% If non-empty, point_toward specifies the pose rotation so that it points
% toward that point coordinate (in mm).  The direction vector rot_from
% (default [0 0 1]) specifies the direction that should be made to point
% toward the point.
%
% ### point_toward is somewhat buggy, and is really only known to work with
% psd_cal.dat as below.  In particular, there seems to be a problem with some
% signs, where if you give a negative z offset, then some rays converge and
% some diverge.  For this reason, at the moment, there is an inv() call which
% makes it point the opposite direction. The PSD calibration procedure using
% this is sort of a hack, in that it ends up generating the right kind of
% pattern without using an entirely rigorous kinematics.  In particular it
% depends on the probe coordinates being defined as by "Initialize" in
% tip_calibration.vi.
%
% for example:
%    make_trans_mesh('foo.dat', 3, 3, 3, 10)
%    make_trans_mesh('psd_cal_10.dat', 10, 10, 1, 6, [0 0 204.2], [0 0 1])
%    make_trans_mesh('psd_cal.dat', 20, 20, 1, 48/19, [0 0 204.2], [0 0 1])

if (nargin < 6)
  point_torward = [];
end

if (nargin < 7)
  rot_from = [0 0 1];
end

res = make_mesh(x, y, z, spacing);
res = [res(1,:); (res(1,:) + res(2,:))*0.5; res(2:end,:)];

res=horzcat(res, zeros(length(res),3));

if (~isempty(point_toward))
  for (ix = 1:size(res, 1))
    p = res(ix, 1:3);
    dir = point_toward - p;
    res(ix, :) = tr2pvec(rt2tr(inv(dir2rot(rot_from, dir)), 1E3*p'));
  end
end

vectors = zeros(size(res, 1), 3);
rf = normalize(rot_from(1:3));
v_len = 0.2E3 * norm(point_toward);
v_from = [v_len*rf 1]';
for (ix = 1:size(res, 1))
  v = pvec2tr(res(ix, :)) * v_from;
  vectors(ix, :) = v(1:3) * 1E-3;
end

res

%plot the mesh grid
plot3(res(:,1), res(:,2), res(:,3), 'r-*');

if (~isempty(point_toward))
  hold on;
  plot3([res(:,1) vectors(:, 1)]', ...
	[res(:,2) vectors(:, 2)]', ...
	[res(:,3) vectors(:, 3)]', ...
	'g:');
  hold off;
end

grid on
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');

fprintf(1, '%d points\n', length(res));
save(out_file,'res','-ascii','-tabs');
