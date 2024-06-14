M = 21; % decimation
O = 2; % overlap
F1=2;
F2=3;
f_resp = F1; % plot response of this freq
f_ref = F2; % adjacent channel reference marker

% All frequency values are in Hz.
Fs = M;   % Sampling Frequency
Fd = Fs/M;
N = M*O;  % Order

%FIR LPF
Fpass = 0.2 * Fd;  % Passband Frequency
Fstop = 0.5 * Fd;  % Stopband Frequency
Wpass = 1;    % Passband Weight
Wstop = 1;    % Stopband Weight
dens  = 20;   % Density Factor

% Calculate the coefficients using the FIRPM function.
fir_lpf  = firpm(N-1, [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Wpass Wstop], ...
		 {dens});

%ref1 = sin(((0:N-1)+0.5)*2*pi*f_resp/Fs);
ref1 = cos(((0:N-1)+0.5)*2*pi*f_resp/Fs);

windows = [
%    fir_lpf
%    gausswin(N,2)'
    [zeros(1,ceil((N-M)/2)) ones(1,M) zeros(1,floor((N-M)/2))]
%    [zeros(1,N-M) ones(1,M)]
%    firrcos(N-1,Fs/M,0.5,Fs,'rolloff')
%    hann(N)'
    inv_rcos(N,1)
	  ];

wnames = {
%    'FIR',
%    'gauss2'
    'Rectangle'
%    'rcos'
    sprintf('%dM Hann', O)
	 };

for i = 1:size(windows,1)
  windows(i,:) = windows(i,:)./sum(windows(i,:))*M;
end

f_max = Fd*4;
f_incr = Fs/M/64;
freqs = 0:f_incr:f_max;
win_freqs = freqs - f_max/2;
res = zeros(0,length(freqs));
win_resp = zeros(0,length(freqs));
for i = 1:size(windows,1)
  res(i,:) = 20*log10(abs(freqz(windows(i,:).*ref1*2,1,freqs,Fs))/ M)';
  win_resp(i,:) = 20*log10(abs(freqz(windows(i,:),1,win_freqs,Fs))/M)';
end

figure(1);
set(gca, 'FontSize', 20, 'LineWidth', 2);
plot(freqs, res, [f_ref-f_incr f_ref f_ref+f_incr], [-500 0 -500], ...
     '-o', 'LineWidth', 2);
ylim([-60 5]);
xlim([0 f_max]);
legend(wnames,'Location','NorthWest');
ylabel('Frequency response (dB)');
xlabel('Normalized frequency f/f_{d}');

figure(2);
set(gca, 'FontSize', 20, 'LineWidth', 2);
plot(1:size(windows,2), windows', 'LineWidth', 2);
xlim([1, size(windows,2)]);
ylim([-inf 1.4]);
set(gca,'XTick', [],'YTick', []);
legend(wnames);

figure(3);
plot(1:size(windows,2), (windows .* repmat(ref1, size(windows,1), 1))');
xlim([1, size(windows,2)]);
set(gca,'XTick', [],'YTick', []);
legend(wnames);

figure(4);
set(gca, 'FontSize', 20, 'LineWidth', 2);
plot(win_freqs, win_resp, 'LineWidth', 2);
legend(wnames,'Location','Best');
ylim([-60 5]);
xlim([-Fd*2 Fd*2]);
ylabel('Frequency response (dB)');
xlabel('Normalized frequency f/f_{d}');
set(gca,'XTick', [-2 -1 -0.5 0 0.5 1 2], 'Xgrid', 'on');
