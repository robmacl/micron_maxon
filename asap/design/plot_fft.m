function [] = plot_fft(dat, Fs)
  tdata = abs(fft(dat .* kaiser(length(dat), 9)));
  delta_f = Fs/length(dat);
  npoints = length(dat)/2;
  fvec = linspace(0, Fs/2, npoints);
  semilogy(fvec, tdata(1:npoints));
  ylabel('amplitude');
  xlabel('frequency (Hz)');
