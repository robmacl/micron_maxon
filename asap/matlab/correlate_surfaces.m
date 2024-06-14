function [corr] = correlate_surfaces (S1, S2)

S1 = reshape(S1, [], 1);
S2 = reshape(S2, [], 1);
undef_ix = isnan(S1 .* S2);
S1(undef_ix) = [];
S2(undef_ix) = [];
S1 = S1 - mean(S1);
S2 = S2 - mean(S2);
x_prod = S1 .* S2; % Recompute after mean adjustment
corr = sum(x_prod)/(((sum(S1.^2) + sum(S2.^2))/2));
