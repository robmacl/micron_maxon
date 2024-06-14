npoints = 1000;
res = cell(npoints, 1);
tic;
for (ix = 1:npoints)
  res(ix) = {read_micron()};
end
toc;
