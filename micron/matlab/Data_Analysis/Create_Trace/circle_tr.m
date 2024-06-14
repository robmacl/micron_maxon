% Generate helix trajectory for exercising manipulator.
% radius, height in microns.  len is the total number of samples 
% and n_rot is the number of rotations in this period.



function res = circle_tr(radius,len)
res = zeros(len, 3);

d_theta = 2*pi/len;


for ix = 1:len
  theta = (ix-1)*d_theta;
  res(ix, 1) = cos(theta) * radius;
  res(ix, 2) = sin(theta) * radius;
  res(ix, 3) =0;
end


