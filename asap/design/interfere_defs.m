% Modulation scheme is expresed by a vector of integers, multiples of the
% output sample rate.  The first is the input sample rate, and the rest are
% carriers.

% Current Micron scheme, as frequencies in Hz, and as multiples.
freqs_rational = [
    1250000/21 2500000/413 10000000/1239 5000000/413 6250000/413 ...
    25000000/1239 1250000/59];


%%% Analysis parameters:

f_max = 300; % Size of spectrum to use in analysis (~= kHz)
num_lights = 6; % Number of lights.
group_num_lights = 3; % Number of lights in group
use_square_wave = 1;
even_harmonic_leakage = 0.038; % Amount of even harmonic in square wave
sine_distortion = 0.005;

% IM products have this amplitude w.r.t. the min amplitude of the two tones.
im_efficiency = 1e-4;


%%% Optimization constraints:

fs_min = 1e3; % Minimum acceptable output sample rate
fs_timebase = 100e6; % Sample rate generator timebase
n_chans = 8;
fs_max = 500e3; % max input sample rate (all channels)

exact_divisors = 0; % Must timebase be divisible by carriers?
timebase = 100e6; % Carrier generator timebase (half period)
lcm_max = timebase / fs_min; % lcm of freqs must be less than this

%%% Search parameters:

% Range of input sample rates to search, expressed as output rate multiple.
sample_freqs = [53 55 57 59 61]; 
%sample_freqs = [59]; 
channel_range = 8:20; % Range of channels to search.

% Two-stage search.  First find carrier combinations where all carriers
% have interference below limit_if, then optimize the carrier grouping into
% two groups of three with the best isolation.
limit_if = 1e-3;
min_overall = 0;
groups_mutual = 1;


if (use_square_wave)
  carrier = square_wave(f_max, even_harmonic_leakage);
else
  % make up some kind of distortion.
  carrier = [1 ((1:(f_max-1)).^-1 * sine_distortion)];
end

if (1)
  choices = nchoosek(channel_range, num_lights);
  if (exact_divisors)
    lcms = zeros(size(choices, 1), 1);
    % Precompute LCMs for channels used. Force divisors to be even.
    for ix = 1:size(choices, 1)
      lcms(ix) = 2*lcm_vec(choices(ix, :));
    end
  
    % can drop out combinations with LCM already too large w/o sample freq
    % constriant.
    toobig = lcms > lcm_max;
    choices(toobig, :) = [];
    lcms(toobig) = [];
  end

  max_if = ones(size(choices, 1), length(sample_freqs));
  fprintf(1, 'Searching:\n');
  for fs_ix = 1:length(sample_freqs)
    sample_freq = sample_freqs(fs_ix);
    if (exact_divisors)
      lcm_sample_freq = lcm(sample_freq, n_chans);
    end
    fprintf('Fs = %d: ', sample_freq);
    for ix = 1:size(choices, 1)
      if (rem(ix, 1000) == 0)
	fprintf(1, '.');
      end
      if (exact_divisors)
	% Force ADC rate to be divisible by n_chans.
	lcm1 = lcm(lcms(ix), lcm_sample_freq);
      end
      if (~exact_divisors || ...
	  (lcm1 <= lcm_max && ...
	   (timebase/lcm1) * sample_freq * n_chans <= fs_max))
	freq1 = [sample_freq choices(ix, :)];
	ifr = find_interference(freq1, [], carrier, im_efficiency);
	max_if(ix, fs_ix) = max(sum(ifr));
      end
    end
    fprintf(1, '\n');
  end
  fprintf(1, 'done\n');
end

if (1)
  % Frequency vectors including Fs for combinations satisfying limit_if
  good_freqs = zeros(0, num_lights + 1);
  
  % Corresponding max of interference across channels.
  good_ifs = [];

  for fs_ix = 1:length(sample_freqs)
    Fs = sample_freqs(fs_ix);
    good_ix = max_if(:, fs_ix) <= limit_if;
    good_freqs = ...
	[good_freqs; [ones(sum(good_ix), 1) * Fs, choices(good_ix, :)]];
    good_ifs = max_if(good_ix, fs_ix);
  end

  if (min_overall)
    % Minimum of across-channel max values.
    [min_ifs, min_ixs] = min(good_ifs);
    freqs = good_freqs(min_ixs(1), :);
  else
    % Interference scores between groups of carriers.

    % Each row is a freqs vector (including Fs).  The grouping is implicit
    % in the channel ordering (3 and 3).
    grouped = zeros(0, num_lights + 1);
    grouped_ix = 1; % Add at index
    
    % Scores of how much each group is interfered with by the other group,
    % index corresponded to "grouped".
    grouped_if = zeros(0, 2);
    
    fprintf(1, 'Find groupings: ');
    groupings = nchoosek(1:num_lights, group_num_lights);
    for groupings_ix = 1:size(groupings, 1)
      fprintf(1, '.');
      g1_ixs = groupings(groupings_ix, :);
      g2_ixs = 1:num_lights;
      g2_ixs(g1_ixs) = [];

      for freqs_ix = 1:size(good_freqs, 1)
	freqs_both = good_freqs(freqs_ix, :);
	freqs1 = freqs_both([1 g1_ixs+1]);
	freqs2 = freqs_both([1 g2_ixs+1]);
	% Interference metric for group is mean amount interfered with (victimization).
	if1 = find_interference(freqs2, freqs1, carrier, im_efficiency);
	if2 = find_interference(freqs1, freqs2, carrier, im_efficiency);
	grouped_if(grouped_ix, :) = ...
	    [sum(sum(if1))/group_num_lights ...
	     sum(sum(if2))/group_num_lights];
	grouped(grouped_ix, :) = [freqs1 freqs2(2:end)];
	grouped_ix = grouped_ix + 1;
      end
    end
    if (groups_mutual)
      [m, min_ix] = min(max(grouped_if, [], 2));
    else
      [m, min_ix] = min(grouped_if(:, 1));
    end
    freqs = grouped(min_ix(1), :);
    fprintf(1, '\n');
  end
else
  % Nice interference, but can't generate strictly repeating with timebase
  %  freqs = [   59    12    16    17    18    19    22];

  % Currently used
  % freqs = [59 15 20 21 6 8 12];


  freqs = [57    10    12    14    16    18    19];
end

if (exact_divisors)
  out_rate = timebase/lcm_vec(freqs)/2;
else
  desired_rate = 1e3;
  out_rate = timebase/round(timebase/(desired_rate*freqs(1)*n_chans))/freqs(1)/n_chans;
end

if (0)
  fprintf(1, 'Output rate %.2f\n', out_rate);
  fprintf(1, 'Sample interval: %g\n', 1/(out_rate * freqs(1)));
  fprintf(1, 'Repeat interval: %d\n', freqs(1));
  fprintf(1, 'Half periods:\n');
  for f = freqs(2:end)
    fprintf(1, '  %g\n', (1/(out_rate * f))/2);
  end
else
  fprintf(1, 'Frequencies: %d', freqs(1));
  fprintf(1, ', %d', freqs(2:end));
  fprintf(1, '\n');
end


[if_only, aliased, adc_in] = find_interference (freqs, [], carrier, im_efficiency);

key_vals = {};
for ix = 1:(length(freqs) - 1)
  key_vals{ix} = sprintf('%d (%d)', ix-1, freqs(ix+1));
end
key_vals{length(key_vals)+1} = 'IMD';

light_nums = 0:5;
figure(1)
bar(adc_in', 'stacked');
legend(key_vals{:});

figure(2)
bar(aliased', 'stacked');
legend(key_vals{:});

figure(3)
  
bar(light_nums, if_only', 'stacked');

legend(key_vals{:}, 'location', 'northwest');

figure(4)
bar([adc_in(7,1:size(aliased,2));aliased(7,:)]');
set(gcf, 'name', 'IMD vs. frequency');
legend('unaliased', 'aliased');


figure(5)

freqs1 = freqs(1:4);
freqs2 = freqs([1 5:7]);
if1 = find_interference(freqs2, freqs1, carrier, im_efficiency);
if2 = find_interference(freqs1, freqs2, carrier, im_efficiency);

bar(0:2, if1', 'stacked');
legend(key_vals{4:7}, 'location', 'northwest');
set(gcf, 'name', 'To group 1');

figure(6)

bar(3:5, if2', 'stacked');
legend(key_vals{[1:3 7]}, 'location', 'northwest');
set(gcf, 'name', 'To group 2');