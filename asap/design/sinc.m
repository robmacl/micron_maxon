xs = linspace(-5, 3, 4000);
pxs = pi*xs;
plot(xs*1026+2052, 20*log10(abs(sin(pxs)./pxs)));
ylim([-40 0]);
xlim([0 5000]);
