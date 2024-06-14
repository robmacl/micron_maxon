% Find the camera projection matrices from the internal parameters:
%    Cxy: optical center of sensor (um)
%    sx: relative scale of u vs. v (dimensionless)
%     f: focal length of lens (um)
%
% K converts an image plane location into a ray in sensor coordinates.  It is
% more-or-less the inverse of the normal camera transform, but this inverse is
% implemented by various negations and reciprocals.  The projection matrix
% K_inv (also computed) can't be directly inverted because it isn't square
% (loses information).

function [K, K_inv] = find_k(Cxy, sx, f)

% We build K up as several transforms that we compose together by
% multiplication. The basic idea behind generating K is to find the physical
% location of the image-plane point with respect to the projection point
% (eg. pinhole.)  The ray that passes from the image plane point through the
% projection point is the ray that we want.  Since the projection point is the
% origin, we don't need to subtract to find the displacement between the two
% points.

% First, translate pixel coord using calibrated centering info,
% accounting for initial offset that we added on.  Now uv = [0,0]
% is on the optical center
trans_xy = eye(4);
trans_xy(1:2, 4) = -Cxy';

% Next, scale uv into the physical distance from the image center.  uv is
% already nominally in sensor plane microns, but we calibrate an aspect ratio
% factor sx.  FWIW, there does seem to be some slight XY asymmetry, and this
% might be due to the thickness of the PSD creating a slightly different back
% focus in the two dimensions.
prescale = diag([[1/sx 1] 1 1]);

% Finally, translate the image plane out the optical axis (Z) by the
% calibrated focal length, f.  This uses the projection convention where the
% image plane is on the same side of the projection point as the object, but
% this gives the same result (except for image reversal) as the optical model
% where the image plane is behind the pinhole.  The sign reversals have
% already been undone in the signal processing path before this.
%
trans_z = eye(4);
trans_z(3, 4) = f;

% When we compose all of these transforms, the final transformed location of
% the uv point is on the ray from the optical center to the actual point.
K=trans_z * prescale * trans_xy;


% K_inv is the standard camera transform, mapping an [x y z 1]' point into a
% [s*u s*v s] point (which must be normalized by s to get the uv position.)
% Symbolically, K_inv * [x y z 1]' is:
%
%    Cxy1*z + (f*sx*x)
%	Cxy2*z + (f*y)
%		   z
%
% So there is some interaction of Z with Cxy, but largely the Z effect is
% simply a division by distance (hidden in the normalization step.)

K_inv = [
    f*sx	0	Cxy(1)	0
     0		f	Cxy(2)	0
     0		0	1	0];
