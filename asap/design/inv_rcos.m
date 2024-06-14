function [res] = inv_rcos(N,beta)
t_width = floor(N/2*beta);
trans = (cos(linspace(0, pi, t_width))+1)/2;
%n_zeros = floor((N - t_width*2)/4);
n_zeros = 0;
n_ones = N - 2*t_width - 2*n_zeros;
res = [zeros(1,n_zeros) trans(length(trans):-1:1) ones(1,n_ones) ...
       trans zeros(1,n_zeros)];
