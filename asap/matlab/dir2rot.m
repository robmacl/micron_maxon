% Create a rotation matrix from two direction vectors (need not be normal).
% The rotation maps the "from" vector onto the "to" vector, defining the
% unspecified rotation component so that there is no component of rotation
% about the "from" axis.  This is useful for pointing in a direction when we
% don't care about rotation around the axis (or we want it to be zero.)

function r = dir2rot(from, to)

from = normalize(from);
to = normalize(to);

% Because we cross with the "from" unit vector, the rotation axis has no
% component in that direction.  For example, if "from" is [0 0 1], then the
% rotation vector lies in the XY plane.
raxis = cross(from, to);

% Fix signs for rotations > 90 degrees.
if (dot(from, to) < 0)
  sz = -1;
else
  sz = 1;
end

% Magnitude of cross product is sine of the angle between the new and old
% axes.  As the magnitude goes to zero, the direction of the rotation axis
% becomes ill-defined (can't be normalized) so we switch to the identity
% for vanishingly small rotations.
stheta = norm(raxis);
if (stheta < eps)
  r = eye(3);
else
  theta = sz*asin(stheta);
  r = rotvec(raxis, theta);
  r = sz*r(1:3, 1:3);
end
