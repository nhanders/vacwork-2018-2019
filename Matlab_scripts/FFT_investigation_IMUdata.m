%---------------------------------------------
%   Investigating FFT of IMU data
%   Nick Anderson
%   27 November 2018
%---------------------------------------------

disp("Reading from .csv.")
sFile = 'IMU_DATA_SWINGINGARM_2.csv';
IMUdata = csvread(sFile);

t = IMUdata(:,1);
ACCELEROMETER_data = IMUdata(:,2:4);
MAGNETOMETER_data = IMUdata(:,5:7);
GYROSCOPE_data = IMUdata(:,8:10);
EULER_data = IMUdata(:,11:13);
LINEARACCEL_data = IMUdata(:,14:16);
GRAVITY_data = IMUdata(:,17:19);

plot_IMUdata(IMUdata);

x_LINEARACCEL =  IMUdata(:,14);
y_LINEARACCEL =  IMUdata(:,15);
z_LINEARACCEL =  IMUdata(:,16);

%Find the magnitude of the vector data.
mag_LINEARACCEL = sqrt(x_LINEARACCEL.^2+y_LINEARACCEL.^2+z_LINEARACCEL.^2);
%Make zero mean
NoM_mag_LINEARACCEL = mag_LINEARACCEL-mean(mag_LINEARACCEL);

figure(20)
clf;
plot(t, [x_LINEARACCEL,y_LINEARACCEL,z_LINEARACCEL, NoM_mag_LINEARACCEL]);
legend('X','Y','Z','mag');
title('Linear Acceleration Data');

%----------------------------------------------------
% LET'S DELVE INTO SOME FFT
% I'm trying to see if a step has a distinct fft so that 
% a match filter can be designed.
%----------------------------------------------------
Ts = 0.03; %period specified in Arduino code
Fs = 1/Ts;
N = numel(t);

%Take the fft of segments of data and plot it.
fft0_mag_LINEARACCEL = fft(NoM_mag_LINEARACCEL(1:125));
fft1_mag_LINEARACCEL = fft(NoM_mag_LINEARACCEL(126:250));
fft2_mag_LINEARACCEL = fft(NoM_mag_LINEARACCEL(251:375));
fft3_mag_LINEARACCEL = fft(NoM_mag_LINEARACCEL(376:500));
fft_mag_LINEARACCEL = fft(NoM_mag_LINEARACCEL);

%Calculate frequency axis
f = -1/(2*Ts):1/(N*Ts):(N/2-1)/(N*Ts);
N_samp = N/4;
f_samp = -1/(2*Ts):1/(N_samp*Ts):(N_samp/2-1)/(N_samp*Ts);

figure(21)
clf;
subplot(5,1,1);
plot(f_samp, fftshift(abs(fft0_mag_LINEARACCEL)));
ylabel('1-125');
subplot(5,1,2);
plot(f_samp, fftshift(abs(fft1_mag_LINEARACCEL)));
ylabel('126-250');
subplot(5,1,3);
plot(f_samp, fftshift(abs(fft2_mag_LINEARACCEL)));
ylabel('251-375');
subplot(5,1,4);
plot(f_samp, fftshift(abs(fft3_mag_LINEARACCEL)));
ylabel('376-500');
subplot(5,1,5);
plot(f, fftshift(abs(fft_mag_LINEARACCEL)));
ylabel('1-500');


 