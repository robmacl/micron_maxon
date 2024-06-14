% Return the camera pose, camera ray matrix, the central XY position
% (along the optical axis) and radial distortion parameter.  This is
% done by calling a C program which generates a matlab script that we
% load.
%
% The results are expressed with respect to fixture coordinates,
% that is whatever coordinates in which the measured points are in
% fact in their desired positions.

function [Tcam, K, K_inv, Cxy, kappa1] = ...
  tsai_calibrate(measured, desired, data_dir, name)

% Micron offset of 3D input data to move origin away from center of FOV.
%pos_offset = 0; 
pos_offset = 1000; 

% We've told the calibrate app that the pixel size is 1 micron.  This results
% in a "pixel" corresponding to approx 6 microns when the ratio of front:back
% focus is approx 6:1.  These values are optimized by the calibrate app, so we
% use the output values.  As in, and in collaboration with nominal_scale.m,
% this gives physical units to the sensor coordinates.  The algorithms in no
% way depend on this, but it is somewhat convenient for debugging.

% offset on sensor pos in "pixels".  This insures all measurements are positive.
pix_offset = 5000;

offset = [repmat(pos_offset, size(desired, 1), 3) repmat(pix_offset, size(desired, 1), 2)];
cal_data = [desired(:,1:3) measured] + offset;


% There's something funny with script caching or something so that
% sometimes a new calibration doesn't actually "take" until you
% restart matlab.  Let's clear any old value and put a random
% number in the temp file names.
clear(name);
secret = fix(rand*1e6);
data_name = sprintf('%s%s_%06d.dat', data_dir, name, secret);
script_name = sprintf('%s%s_script_%06d', data_dir, name, secret);

% Clear out any previous temp files for this sensor.  Its useful to leave
% the most recent files for each sensor in the cal directory for debugging.
delete([data_dir name '_script*.m']);
delete([data_dir name '_*.dat']);

fid = fopen(data_name, 'w');
fprintf(fid, '%f %f %f %f %f\n', cal_data');
fclose(fid);


cmd = ['..\tsai_cal\asap_cal.exe ' data_name ' ' name ' ' script_name '.m'];
[status,output]=system(cmd);
if (status)
  fprintf(1, 'Command failed: %s\n%s', output, cmd);
else
  fprintf(1, '%s', output);
end

run(script_name);

% result is the inverse of what we're wanting, and is also translated.
res = eval(name);

% The basic idea behind generating K is to find the physical location of the
% image-plane point with respect to the projection point (eg. pinhole.)  The
% ray that passes from the image plane point through the projection point is
% the ray that we want.  Since the projection point is the origin, we don't
% need to subtract to find the displacement between the two points.

% Subtract pixel offset back off (added to make "pixel position" positive.)
Cxy = res.Cxy - repmat(pix_offset, 1, 2);

% We build K up as several transforms that we compose together by
% multiplication.  This is more-or-less the inverse of the normal camera
% transform, which is implemented by various negations and reciprocals.

% First, translate pixel coord using calibrated centering info,
% accounting for initial offset that we added on.  Now uv = [0,0]
% is on the optical center
trans_xy = eye(4);
trans_xy(1:2, 4) = -Cxy';

% Next, scale uv into the physical distance from the image center.
% This is done using the nominal pixel size res.dpxy and the calibrated
% aspect ratio factor res.sx.  FWIW, there does seem to be some slight XY
% asymmetry, and this might be due to the thickness of the PSD creating a
% slightly different back focus in the two dimensions.
prescale = diag([res.dpxy .* [1/res.sx 1] 1 1]);

% Finally, translate the image plane out the optical axis (Z) by the
% calibrated focal length, res.f.  This uses the projection convention
% where the image plane is on the same side of the projection point as
% the object, but this gives the same result (except for image
% reversal) as the optical model where the image plane is behind the
% pinhole.
%
trans_z = eye(4);
trans_z(3, 4) = res.f;

% When we compose all of these transforms, the final transformed location of
% the uv point is on the ray from the optical center to the actual point.
K=trans_z * prescale * trans_xy;


% This is the standard camera transform, mapping a [x y z 1]' point into a
% [s*u s*v s] point (which must be normalized by s to get the uv position.)
% Symbolically, K_inv * [x y z 1]' is:
%
%    Cxy1*z + (f*sx*x)/dpxy1
%	Cxy2*z + (f*y)/dpxy2
%			   z
%
% So there is some interaction of Z with Cxy, but largely the Z effect is
% simply a division by distance (hidden in the normalization step.)

K_inv = [
    res.f*res.sx/res.dpxy(1)	0	Cxy(1)	0
     0		res.f/res.dpxy(2)	Cxy(2)	0
     0				0	1	0];


% Currently radial distortion is forced to zero in the C code, since the
% simple lens in ASAP doesn't have radial distortion.
kappa1 = res.kappa1;

% The camera pose Tcam is computed fairly straightforwardly from
% the rotation matrix and translation vector reported out by
% asap_cal by concatenating and taking the inverse.
Tcam=inv([[res.R; 0 0 0] [res.T 1]']);
Tcam(1:3, 4) = Tcam(1:3, 4) - repmat(pos_offset, 3, 1);
