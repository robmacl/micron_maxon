function res = carrier (wave, n)
res = reshape([zeros(n - 1, length(wave)); wave], 1, []);
res = res(1:length(wave));
