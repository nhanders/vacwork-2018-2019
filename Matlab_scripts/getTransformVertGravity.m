function [rotm] = getTransformVertGravity(IMUdata)
% ----------------------------------------------
% Rotate the gravity by Ry only since orientation
% is known.
% Nick Anderson
% 6 December 2018
% ----------------------------------------------
%{ 
    e.g. Given gravity readings a, b, c from the IMU,
         the following transformation T should be
         calculated to give:
    
        a*i           9.80*i
        b*j  x  T  =  b   *j
        c*k           0   *k
%}
    
    disp("Calculating Tranformation Matrix.");
    
    t = IMUdata(:,1);
    GRAVITY_data = IMUdata(:,17:19);
    X_GRAVITY_data = GRAVITY_data(:,1);
    Z_GRAVITY_data = GRAVITY_data(:,3);
    N = numel(t);
    
    % -----------------------------------------
    % TRANSFORMATION
    % 1) find angle to set z to zero using Ry
    % 2) T = Rz*Rx
    % -----------------------------------------

    % 1) Find angle to set z to zero using Ry
    beta = atan2(Z_GRAVITY_data,X_GRAVITY_data);
    
    Ry = zeros(3,3,N);
    GRAVITY_0z = zeros(500,3);

    % Create N Rx matricies with N gammas.
    % Calculate new gravity with zero y.
    for i=1:N
        Ry(:,:,i) = [cos(beta(i)) 0 sin(beta(i)); 0 1 0; -sin(beta(i)) 0 cos(beta(i))];
        GRAVITY_0z(i,:) = Ry(:,:,i)*GRAVITY_data(i,:)';
    end
    
    rotm = Ry;
end

