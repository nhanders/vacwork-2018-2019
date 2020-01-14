% Investigating matched filters
% 4 December 2018
% Nick Anderson
%---------------------------------------------

%Create transmitted signal
Ts = 0.1;
fs = 1/Ts;
t = 0:Ts:10;
N = numel(t);
x_tx = [ones(1,10) zeros(1,numel(t)-10)];

figure(1);
clf;
subplot(2,1,1);
plot(t,x_tx);
ylim([-1,3]);

%Create received signal
A = 0.5;
noise = 0.1*randn(1,numel(t));
%noise = noise-mean(noise);
x_rx = A*[zeros(1,30) ones(1,10) zeros(1,numel(t)-40)]+noise;

subplot(2,1,2);
plot(t,x_rx);
ylim([-1,3]);

%Freqy stuff
X_TX = fft(x_tx);
S_TX = fft(noise);
X_RX = fft(x_rx);

f = -1/(2*Ts):1/(N*Ts):(N/2-1)/(N*Ts);

figure(2);
clf;
plot(f, fftshift(abs(X_TX)));
hold on;
plot(f, fftshift(abs(S_TX)));
plot(f, fftshift(abs(X_RX)));
legend();
hold off;

%Convolution
y_rx = conv(x_rx, x_tx);

t2 = 0:Ts:20; 

figure(3);
clf;
plot(t2, y_rx);

%Matched filter
td = 2;
H = conj(X_TX).*exp(1j*2*pi*f*td);

Y_RX = H.*X_RX;
y_rx2 = ifft(Y_RX);

figure(4);
clf;
plot(t, y_rx2);

