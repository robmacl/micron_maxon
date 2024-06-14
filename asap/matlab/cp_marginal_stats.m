% Find marginal statistics across the first dimension of the pose_map.  Use
% with permute to find column marginals.  res is (n, 3, 6), where
% (n, 1, :) is the mean pose, (n, 2, :) is the mean error, and (n, 3, :) is
% the standard deviation of the error (RMS w.r.t mean).  vsum is (n, 3, 2),
% taking the separate vector sum of the translation (:, :, 1) and rotation
% (:, :, 2) components.
% 
% for each row, max_var has two columns, the maximum vector magnitude for
% translation and rotation of the variation about the input column mean.
% This is the maximum error due to the row effect alone.

function [res, vsum, max_var, var2] = cp_marginal_stats(pmap, valid)
mmean = sum(pmap);
num = sum(valid);
ncols = size(pmap, 2);

% find marginal mean across columns in each row.
for ix = 1:ncols
  mmean(:, ix, :, :) = mmean(:, ix, :, :) ./ num(ix);
end

% Variation about mean.
var = pmap - repmat(mmean, [size(pmap, 1), 1, 1, 1]);
var2 = var.^2;

err2 = sum(var2);
max_var=squeeze(sqrt(max(cat(4, sum(var2(:, :, 2, 1:3), 4), sum(var2(:, :, 2, 4:6), 4)))));


% mean-squared variance
for ix = 1:ncols
  err2(:, ix, :, :) = err2(:, ix, :, :) ./ num(ix);
end

rms = sqrt(err2);
res = mmean;
res(:, :, 3, :) = rms(:, :, 2, :);
res = squeeze(res);

vsum = zeros(ncols, 3, 2);
vsum(:, :, 1) = sqrt(sum(res(:, :, 1:3).^2, 3));
vsum(:, :, 2) = sqrt(sum(res(:, :, 4:6).^2, 3));
