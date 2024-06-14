% Generate helix trajectory for exercising manipulator.
% radius, height in microns.  len is the total number of samples 
% and n_rot is the number of rotations in this period.

function res = helix_tr(radius, height, len, n_rot)
res = zeros(len, 3);

d_theta = 2*pi*n_rot/len;

z = 0;
dz = 2*height/len;

for ix = 1:len
  theta = (ix-1)*d_theta;
  res(ix, 1) = cos(theta) * radius;
  res(ix, 2) = sin(theta) * radius;
  res(ix, 3) = z;
  if (abs(z) > height/2)
    dz = -dz;
  end
  z = z + dz;
end

