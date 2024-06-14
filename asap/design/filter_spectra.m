% Idealized n'th order lowpass with corner at fc.
function res = filter_spectra (x, fc, order)

resp = ((1:size(x,2))./fc).^(-order);
resp(resp > 1) = 1;
res = x .* repmat(resp, size(x, 1), 1);
