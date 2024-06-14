
res = zeros(3, 5, 2);
for ix = 1:size(res, 1)
  for jx = 1:size(res, 2)
    for kx = 1:size(res, 3)
      res(ix, jx, kx) = 100*ix + 10*jx + kx;
    end
  end
end

res

write_matrix(1, 'test', res);
