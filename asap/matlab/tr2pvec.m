% Convert a transform matrix into the 6 element vector used for pose in the
% motion control system: [x y z Rx Ry Rz].  This is translation + Euler
% angles, but the rotations are applied z y x.  Also (for user friendliness)
% the units are mm and degrees, whereas most other places, both in the Matlab
% and Labview code, microns and radians are used.  So we scale the translation
% part and convert rotations to degrees.

function res = tr2pvec(trans)
RzRyRx = tr2rpy(trans);
res = trans(1:3, 4) * 1E-3;
res(4:6) = RzRyRx(3:-1:1)*180/pi;
