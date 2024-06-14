function [res] = instantiate (v, wave)
fc = v(2:end);
res = zeros(length(fc), length(wave));
for ix = 1:length(fc)
  res(ix, :) = carrier(wave, fc(ix));
end
