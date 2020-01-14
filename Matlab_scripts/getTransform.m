function [rotm] = getTransform(IMUdata)
% ----------------------------------------------
% User Euler angles to get to known orientation.
% Nick Anderson
% 6 December 2018
% ----------------------------------------------
%{ 
    e.g. Given gravity readings a, b, c from the IMU,
         the following transformation T should be
         calculated to give:
    
        a*i           9.80*i
        b*j  x  T  =  0   *j
        c*k           0   *k
%}
    
    disp("---------------------------------------");
    disp("Calculating Tranformation Matrix.");
    
    t = IMUdata(:,1);
    N = numel(t);
    EULER_data = IMUdata(:,14:16);
    beta = -2*pi/360*EULER_data(:,1);
    %QUAT_data = IMUdata(:,20:23);
    %EULER_data = quat2eul(QUAT_data, 'ZYX');
    %rotm = quat2rotm(quatinv(QUAT_data));
    %rotm = eul2rotm(EULER_data, 'ZYX');
    
    Ry = zeros(3,3,N);
    
    for i=1:N
        Ry(:,:,i) = [cos(beta(i)) 0 sin(beta(i)); 0 1 0; -sin(beta(i)) 0 cos(beta(i))];
        %T(:,:,i) = Ry(:,:,i)*Rz(:,:,i);
    end
    
    rotm = Ry;
    
    %rotm = eul2rotm(EULER_data, 'ZYX');
end


