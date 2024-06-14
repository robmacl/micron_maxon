% Alias spectra x according to fs.  We alias into the third dimension.  To
% find the sampled amplitudes, use sum(..., 3).  We assume DC and its alias
% fs are uninteresting, so the result has rows length (fs-1)/2
function res = alias (x, fs)
if (rem(fs, 2) == 0)
  error('Even fs?');
end

% fs may not divide spectra evenly.  zero pad.
nwraps = ceil(size(x, 2)/fs);
fs_fold = [x zeros(size(x, 1), nwraps*fs - size(x, 2))];
fs_fold = reshape(fs_fold, size(x, 1), fs, nwraps);

% now fs_fold has been stacked out into the third dimension, but each row still
% goes from 1 to fs.
fn = floor(fs/2);
res = cat(4, fs_fold(:, 1:fn, :), fs_fold(:, (fn*2):-1:(fn+1), :));
res = reshape(res, size(x, 1), fn, nwraps*2);
