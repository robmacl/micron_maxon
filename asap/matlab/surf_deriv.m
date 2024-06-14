% Return an approximation of the partial derivitives of a surface by
% differencing.  

function [rx, ry, rdx, rdy] = surf_deriv (x, y, S)
rx = zeros(length(x) - 1, 1);
for (ix = [1:length(rx)])
  rx(ix) = (x(ix+1) + x(ix))/2;
end

ry = zeros(length(y) - 1, 1);
for (ix = [1:length(ry)])
  ry(ix) = (y(ix+1) + y(ix))/2;
end

rdx = zeros(length(ry), length(rx));
rdy = rdx;

for (ix = [1:length(rx)])
  dx = x(ix+1) - x(ix);
  for (iy = [1:length(ry)])
    dy = y(iy+1) - y(iy);
    rdx(iy, ix) = (S(iy, ix+1) - S(iy, ix))/dx;
    rdy(iy, ix) = (S(iy+1, ix) - S(iy, ix))/dy;
  end
end
