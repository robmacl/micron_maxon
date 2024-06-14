function sgolay_bode (N, F, dx)

%N=2 polynomial order
%F=11 window size
%dx=0.2 e.g. mm

  [b,g] = sgolay(N,F);   % Calculate S-G coefficients

  subplot(2,1,1)
  [h_int, w_int] = freqz(g(:,1));
  semilogx((1./(w_int/(2*pi)))*dx, 10*log(abs(h_int)));
  ylim([-30 inf]);
  xlim([2*dx 100]);
  ylabel('Smoothed (dB)');


  subplot(2,1,2)
  [h_d1, w_d1] = freqz(g(:,2)./dx);
  semilogx((1./(w_d1/(2*pi)))*dx, 10*log(abs(h_d1)));
  ylim([-30 inf]);
  xlim([2*dx 100]);
  ylabel('First derivitive (dB)');
  xlabel('Spatial period');
  
end
