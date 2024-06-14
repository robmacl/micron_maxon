% Represent a waveform by a vector of its Fourier coefficients.  The first
% is the fundamental amplitude, fundamental * 2, etc.
function res = square_wave (f_max, even_harmonic_leakage)
res = zeros(1, f_max);
res(1) = 1;
for ix = 3:2:f_max
  res(ix) = 1/ix;
end
for ix = 2:2:f_max
  res(ix) = 1/ix * even_harmonic_leakage;
end
