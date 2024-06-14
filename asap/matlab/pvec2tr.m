% Create a transform matrix from the 6 element vector used for pose in the
% motion control system: [x y z Rx Ry Rz].  This is translation + Euler
% angles, but the rotations are applied z y x.  Also (for user friendliness)
% the units are mm and degrees, whereas most other places, both in the Matlab
% and Labview code, microns and radians are used.  So we scale the translation
% part and convert rotations to degrees.

function r = pvec2tr(v)
angles = v(4:6)/180*pi;
r = rotz(angles(3)) * roty(angles(2)) * rotx(angles(1));
r(1:3, 4) = v(1:3) * 1E3;
