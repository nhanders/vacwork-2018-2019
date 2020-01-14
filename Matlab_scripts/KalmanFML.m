% -------------------------------------------------------------
% Kalman filter implementation to improve GPS position tracking
% using GPS outputs of longitude, latitude, speed and bearing.
% Adapted from: https://www.mdpi.com/1424-8220/13/11/15307/pdf
% Nick Anderson
% 23 January 2019
% -------------------------------------------------------------
% NAMING CONVENTION
% zk - meausered GPS data vector (input to Kalman filter)
% xGPS/yGPS/thetaGPS/uGPS - measuerd x/y position, bearing/speed
% xbk - state vector 
% xk/yk/thetak/uk - estimated from Kalman
% "n" - a priori state estimate
% "p" - a posteriori state estimate
% dT - sample time
% "h" - hat/estimated state.
% -------------------------------------------------------------

%Create artificial samples of GPS data.
N = 10; %50 samples, 5 seconds
fs = 1; %1Hz
dT = 1/fs;
%Rated error from datasheet
SPDERROR = 0.05; %0.05m/s 
BEARERROR = 0.3; %0.3 degrees
XERROR = 2.5; %2.5m
YERROR = 2.5; %2.5m
%Error for noise
XERRORN = 5; %5m
YERRORN = 5; %5m
SPDERRORN = 2/3.6; %0.5km/h 
BEARERRORN = 5; %5 degrees
% GPS is simulated GPS, speed and bearing readings.
thetaGPS = 60*ones(N,1); %60 degrees CWW x-axis
uGPS = 5/3.6*ones(N,1);  %5km/h
xGPS = cumsum(uGPS*dT.*cosd(thetaGPS));
yGPS = cumsum(uGPS*dT.*sind(thetaGPS));
thetaGPS1 = thetaGPS+(rand(N,1)-0.5)*2*BEARERRORN; 
% GPS1 is simulated noisy GPS readings.
uGPS1 = uGPS+(rand(N,1)-0.5)*2*SPDERRORN; %0.5km/h error 
xGPS1 = xGPS+(rand(N,1)-0.5)*2*XERRORN;   %3m error
yGPS1 = yGPS+(rand(N,1)-0.5)*2*YERRORN;   %3m error
% GPS2 is simulated noisy bearing/speed calculations
xGPS2 = cumsum(uGPS1*dT.*cosd(thetaGPS1)); 
yGPS2 = cumsum(uGPS1*dT.*sind(thetaGPS1));

figure(1);
clf;
plot(xGPS, yGPS, '-x');
hold on
plot(xGPS1, yGPS1, 'x');
plot(xGPS2, yGPS2, 'x');
legend('Actual trajectory', 'GPS Readings', 'Bearing/Speed Readings', 'Location','NorthWest');
hold off;

%{
% Need to figure what theta I am going to use. theta as defined
% here is x-axis CCW.

% GPS readings
zk = [xGPS; yGPS; thetaGPS; uGPS];

% Output of Kalman filter.
xbk = [xk; yk; thetak; uk];

% Prediction matrix
% updates the values 
Fk =    [1 0 0 dT*cos(thetak_1p); 
         0 1 0 dT*sin(thetak_1p);
         0 0 1 0;
         0 0 0 1];

% a priori and a posteriori state estimate vectors
xk_1nh = [xkn; ykn; thetakn; ukn];  
xk_1ph = [xkp; ykp; thetakp; ukp];     

% a priori state estimate from previous a posteriori state estimate
xbknh = Fk*xk_1ph;

I4 = eye(4); Hk = I4;

% Iinitialise covariance matrices with random values 0-6.
Q = 6*rand(3).*eye(3);
R = 6*rand(3).*eye(3);

% Covariance matrix of the a priori estimate
Pkn = Fk*Pk_1p*Fk'+Qk;

% Kalman gain matrix
Kk = Pkn*Hk'*(Hk*Pkn*Hk'+Rk)^(-1);

% a posteriori estimate of the system-state using the measurements, Zk
Xkph = Xknh+Kk*(Zk-Hk*Xknh);

% Covariance matrix of the a posteriori estimate
Pkp = (I-KkHk)*Pkn;

%}