% Find interference between lights with particular set of channels.  If
% if_freqs is nonempty, the test interference at those frequencies
% (disjoint from freqs).
%
function [if_only, aliased, adc_in] = ...
    find_interference (freqs, if_freqs, carrier, im_efficiency)
	  
driver = filter_spectra(instantiate(freqs, carrier), 26, 1);
adc_in = filter_spectra(intermodulate(driver, im_efficiency), 21, 2);
aliased = sum(alias(adc_in, freqs(1)), 3);

if (isempty(if_freqs))
  if_only = aliased(:, freqs(2:end));
  % Can't interfere with yourself.
  for ix = 1:size(if_only, 2)
    if_only(ix, ix) = 0;
  end
else
  if_only = aliased(:, if_freqs(2:end));
end
