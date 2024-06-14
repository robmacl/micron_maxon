ri = 29
F1=2052.55
F2=3078.82

% All frequency values are in Hz.
Fs = 29761.90   % Sampling Frequency

N     = ri*9;  % Order
Fpass = 250;  % Passband Frequency
Fstop = 500;  % Stopband Frequency
Wpass = 1;    % Passband Weight
Wstop = 1;    % Stopband Weight
dens  = 20;   % Density Factor

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Wpass Wstop], ...
           {dens});
%b = inv_rcos(N,1);
%b = b / sum(b);

ref1 = sin((0:length(b)-1)*2*pi*F1/Fs);
ref2 = sin((0:length(b)-1)*2*pi*F2/Fs);
%ref2 = sin(((0:length(b)-1)+3.5)*2*pi*F1/Fs);

[h1,f]=freqz(b.*ref1*2,1,0:4000,Fs);
ys1 = 20*log10(abs(h1));
[h2,f]=freqz(b.*ref2*2,1,0:4000,Fs);
ys2 = 20*log10(abs(h2));

set(gca, 'FontSize', 20, 'LineWidth', 2);
plot(f, ys1, f, ys2, '--', 'LineWidth', 2);
ylim([-50 5]);
xlim([0 4000]);
legend('Light 0','Light 1','Location','NorthWest');
ylabel('Frequency response (dB)');
xlabel('Frequency (Hz)');
