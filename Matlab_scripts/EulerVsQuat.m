% Compate Euler and Quaternion
%{
t = IMUdata(:,1);
EULER_data = IMUdata(:,14:16);
QUAT_data = IMUdata(:,20:23);

EULER_calc = euler(quaternion(QUAT_data), 'YXZ', 'point');
[yaw, pitch, roll] = quat2angle(QUAT_data);
EULER_calc2 = [yaw, pitch, roll];

figure(40)
clf;
subplot(2,1,1);
plot(EULER_data);
title("Euler Data");
legend('X','Y','Z');
subplot(2,1,2);
plot(EULER_calc2);
title("Quat2Euler Data");
legend('X','Y','Z');
%}

disp("---------------------------------------");
disp("Calculating Tranformation Matrix.");

t = IMUdata(:,1);
N = numel(t);
EULER_data = IMUdata(:,14:16);
beta = EULER_data(:,2);
QUAT_data = IMUdata(:,20:23);
%EULER_data = quat2eul(QUAT_data, 'ZYX');
%rotm = quat2rotm(quatinv(QUAT_data));
%rotm = eul2rotm(EULER_data, 'ZYX');

Ry = zeros(3,3,N);

for i=1:N
    Ry(:,:,i) = [cos(beta(i)) 0 sin(beta(i)); 0 1 0; -sin(beta(i)) 0 cos(beta(i))];
    %T(:,:,i) = Ry(:,:,i)*Rz(:,:,i);
end

rotm = Ry;

figure(100);
clf;
quiver3(zeros(3,1),zeros(3,1),zeros(3,1),[1;0;0],[0;1;0],[0;0;1])
hold on;

EULER_data(:,1) = EULER_data(:,1)*0;

rotm_eul = eul2rotm(EULER_data, 'ZYX');

newx = rotm_eul(:,:,1)*[1;0;0];
newy = rotm_eul(:,:,1)*[0;1;0];
newz = rotm_eul(:,:,1)*[0;0;0];

quiver3(zeros(3,1),zeros(3,1),zeros(3,1),newx,newy,newz)

newx = rotm(:,:,1)*newx;
newy = rotm(:,:,1)*newy;
newz = rotm(:,:,1)*newz;

%quiver3(zeros(3,1),zeros(3,1),zeros(3,1),newx,newy,newz)
hold off;

q = QUAT_data;
euler = zeros(size(EULER_data));
euler(:,1) = atan2(2 .* q(:,2) .* q(:,3) - 2 * q(:,1) .* q(:,4), 2 * q(:,1).*q(:,1) + 2 * q(:,2) .* q(:,2) - 1); % psi
euler(:,2) = -asin(2 * q(:,2) .* q(:,4) + 2 * q(:,1) .* q(:,3)); % theta
euler(:,3)  = atan2(2 * q(:,3) .* q(:,4) - 2 * q(:,1) .* q(:,2), 2 * q(:,1) .* q(:,1) + 2 * q(:,4) .* q(:,4) - 1); % phi
euler = euler*360/(2*pi);

EULER_data2 = quat2eul(QUAT_data, 'ZYX');
EULER_data2 = EULER_data2*360/(2*pi);

EULER_data(N/4,:)
euler(N/4,:)
EULER_data2(N/4,:)