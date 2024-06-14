
% This IMD model is only very approximate, since the whole thing about IMD is
% that it results from nonlinearity.  It's a rather aribitrary assumption that
% IMD can be computed in the frequency domain as the sum of pairwise
% intermodulations.  It's been shown that two-tone IMD performance is only
% weakly predictive of behavior with complex digital signals.  Anyway, what
% this model is pushing the optimization to do is to pack in the carriers up
% at the high end of the range so that the sum and difference products don't
% fall in among the carriers.  The difference products fall down at the low
% end, and the sum products are pretty well attenuated by the antialias
% filter, and then they alias down to the low end too.  Using higher carrier
% freqs helps with hum rejection too.

function res = intermodulate (x, im_efficiency)
total = sum(x);
res = zeros(size(total));
for (f1 = 1:length(total))
  for (f2 = (f1 + 1):length(total))
    ampl = min(total(f1), total(f2)) * im_efficiency;
    if ((f1 + f2) <= length(res))
      res(f1 + f2) = res(f1 + f2) + ampl;
    end
    res(abs(f1 - f2)) = res(abs(f1 - f2)) + ampl;
  end
end

res = [x; res];
