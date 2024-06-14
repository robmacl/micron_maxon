ri = 29;
F1=2052.55;
F2=3078.82;

% All frequency values are in Hz.
Fs = 29761.90;   % Sampling Frequency

N     = ri*2;  % Order

b = inv_rcos(N,1);
b = b / sum(b);

ref1 = cos((0:length(b)-1)*2*pi*F1/Fs+0*pi/2);
ref2 = cos((0:length(b)-1)*2*pi*F2/Fs);
f_max = Fs/2;
[h1,f]=freqz(b.*ref1*2,1,0:f_max,Fs);
ys1 = 20*log10(abs(h1));
[h2,f]=freqz(b.*ref2*2,1,0:f_max,Fs);
ys2 = 20*log10(abs(h2));

plot(f, ys1, f, ys2, '--', 'LineWidth', 2);
legend('ref1','ref2');
ylim([-100 5]);
xlim([0 f_max]);
ylabel('Frequency response (dB)');
xlabel('Frequency (Hz)');
