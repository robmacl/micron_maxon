M = 21; % decimation
O = 1; % overlap
F1=2;
F2=3;
f_resp = F1; % plot response of this freq
f_ref = F2; % adjacent channel reference marker

% All frequency values are in Hz.
Fs = M;   % Sampling Frequency
Fd = Fs/M;
N     = M*O;  % Order

xs = linspace(-5, 10, 100000);
pxs = pi*xs;
ys = 20*log10(abs(sin(pxs)./pxs));
set(gca, 'FontSize', 20, 'LineWidth', 2);
plot(xs*Fd, ys, 'k', 'LineWidth', 2);
ylim([-40 5]);
xlim([-Fd*2 Fd*2]);
ylabel('Frequency response (dB)');
xlabel('Normalized frequency f/f_{d}');
set(gca,'XTick', [-2 -1 -0.5 0 0.5 1 2], 'Xgrid', 'on');

