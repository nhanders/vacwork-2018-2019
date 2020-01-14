% Compate Euler and Quaternion

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

q = QUAT_data;
euler = zeros(size(EULER_data));
euler(:,1) = atan2(2 .* q(:,2) .* q(:,3) - 2 * q(:,1) .* q(:,4), 2 * q(:,1).*q(:,1) + 2 * q(:,2) .* q(:,2) - 1); % psi
euler(:,2) = -asin(2 * q(:,2) .* q(:,4) + 2 * q(:,1) .* q(:,3)); % theta
euler(:,3)  = atan2(2 * q(:,3) .* q(:,4) - 2 * q(:,1) .* q(:,2), 2 * q(:,1) .* q(:,1) + 2 * q(:,4) .* q(:,4) - 1); % phi
euler = euler*360/(2*pi);

EULER_data2 = quat2eul(QUAT_data, 'ZYX');
EULER_data2 = EULER_data2*360/(2*pi);

EULER_data(N,:)
euler(N,:)
EULER_data2(N,:)