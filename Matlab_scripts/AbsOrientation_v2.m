%--------------------------------------------------------
% Tranforming data to global coordinate system.
% Nick Anderson
% 23 January 2019
%--------------------------------------------------------
%   1     2     3     4    5    6    7    8     9     10
% time, linx, liny, linz, grx, gry, grz, eulx, euly, eulz
%--------------------------------------------------------
clc;

sFile = 'IMU_Tests/AbsOrientation/Test4.csv'; %IMU test to load.
MAGDEC_CPT = -25.35; %Cape Town magnetic declination

%Load the specified IMU test data to IMUdata.
if (~exist(sFile, 'file')) %if the file does not exists, read instrumentation
    disp(['The following file does not exist: ', sFile]);
    error('Script ended.')
end

%Decode the data
disp(['Reading from ', sFile]);
IMUData = csvread(sFile);
t = IMUData(:,1);
linAcc = IMUData(:,2:4);
gravity = IMUData(:,5:7);
eul = deg2rad(IMUData(:,8:10));
N = numel(t);

% ---------------------------------------
% TRANSFORM DATA TO GLOBAL COORDINATES
% ---------------------------------------
% Decode Euler angles
roll = eul(:,1);
pitch = eul(:,2);
yaw = eul(:,3);
eul_rpy = [-roll -pitch -yaw];

% Transfromation matrix from Euler angles
tfrmMatrix = eul2rotm(eul_rpy, 'XYZ');

% Apply transformation matrix.
gravityTfrm = zeros(size(gravity));
linAccTfrm = zeros(size(linAcc));
for i=1:Nsi
    gravityTfrm(i,:) = (tfrmMatrix(:,:,i)\gravity(i,:)')'; %inv(A)*b
    linAccTfrm(i,:) = (tfrmMatrix(:,:,i)\linAcc(i,:)')';
end

%Plot untransformed data.
figure(1)
clf;
subplot(2,2,1) %Gravity
plot(t,gravity);
title("Raw IMU Data");
ylim([-10, 10]);
ylabel("Gravity");
legend('x', 'y', 'z');
subplot(2,2,2) %Linear Acceleration
plot(t,linAcc);
ylabel("Linear Acceleration")
legend('x', 'y', 'z');

%Plot transformed data
subplot(2,2,3) %Gravity
plot(t,gravityTfrm);
ylim([-10, 10]);
ylabel("Transformed Gravity")
legend('x', 'y', 'z');
subplot(2,2,4) %Linear Acceleration
plot(t,linAccTfrm);
ylabel("Transformed Linear Acceleration")
legend('x', 'y', 'z');

% ---------------------------------------
% TRANSFORM DATA TO TRUE NORTH
% ---------------------------------------

Rotz = [cosd(MAGDEC_CPT) -sind(MAGDEC_CPT) 0; 
        sind(MAGDEC_CPT) cosd(MAGDEC_CPT)  0;
        0                0                 1]; 

gravityTfrmTN = (Rotz*gravityTfrm')';
linAccTfrmTN = (Rotz*linAccTfrm')';  

%Plot untransformed data.
figure(2)
clf;
subplot(2,2,1) %Gravity
plot(t,gravityTfrm);
title("Raw IMU Data");
ylim([-10, 10]);
ylabel("Gravity");
legend('x', 'y', 'z');
subplot(2,2,2) %Linear Acceleration
plot(t,linAccTfrm);
ylabel("Linear Acceleration")
legend('x', 'y', 'z');

%Plot transformed data
subplot(2,2,3) %Gravity
plot(t,gravityTfrmTN);
ylim([-10, 10]);
ylabel("Transformed Gravity")
legend('x', 'y', 'z');
subplot(2,2,4) %Linear Acceleration
plot(t,linAccTfrmTN);
ylabel("Transformed Linear Acceleration")
legend('x', 'y', 'z');

%disp("---------------------------------------");
disp("Program Complete.");