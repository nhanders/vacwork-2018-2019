
N = 1000;
Fs = 100;
Ts = 1/Fs;

t = 0:Ts:(N-1)*Ts

y = sin(2*pi*1*t)

figure(1)
clf;
plot(t,y);

y_fft = abs(fft(y));

f = -1/(2*Ts):1/(N*Ts):(N/2-1)/(N*Ts);

figure(2)
clf;
plot(f, fftshift(y_fft));




