function [T] = getTransformAllGravity(IMUdata)
% ----------------------------------------------
% Rotate the gravity vector to know orientation.
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
    GRAVITY_data = IMUdata(:,17:19);
    X_GRAVITY_data = GRAVITY_data(:,1);
    Y_GRAVITY_data = GRAVITY_data(:,2);
    Z_GRAVITY_data = GRAVITY_data(:,3);
    N = numel(t);

    % Calculate the magnitude of each row (x,y,z sample).
    GRAVITY_data_mag = vecnorm(GRAVITY_data')';

    % Plot the x,y,z data and the magnitude.
    % Note: the magnitude is approx 9.80 for all samples.
    %{
    figure(2);
    clf;
    plot(t,GRAVITY_data);
    hold on;
    plot(t,GRAVITY_data_mag);
    hold off;
    title("Gravity data and magnitude.");
    legend('X','Y','Z','MAG');
    %}
    
    
    % -----------------------------------------
    % TRANSFORMATION
    % 1) find angle to set z to zero using Rx
    % 2) find angle to set y to zero using Rz
    % 3) T = Rz*Rx
    % -----------------------------------------

    % 1) Find angle to set z to zero using Rx
    % Using Rx, it was simulataneously solved that:
    gamma = atan2(-Z_GRAVITY_data,Y_GRAVITY_data);
    
    Rx = zeros(3,3,N);
    GRAVITY_0z = zeros(500,3);

    % Create N Rx matricies with N gammas.
    % Calculate new gravity with zero y.
    for i=1:N
        Rx(:,:,i) = [1 0 0; 0 cos(gamma(i)) -sin(gamma(i)); 0 sin(gamma(i)) cos(gamma(i))];
        GRAVITY_0z(i,:) = Rx(:,:,i)*GRAVITY_data(i,:)';
    end
    
    % 2) Find angle to set y to zero using Rz.
    X_GRAVITY_0z = GRAVITY_0z(:,1);
    Y_GRAVITY_0z = GRAVITY_0z(:,2);
    beta =  atan2(-Y_GRAVITY_0z,X_GRAVITY_0z);
    
    Rz = zeros(3,3,N);
    GRAVITY_0yz = zeros(500,3);
    T = zeros(3,3,N);

    T_rot = [1 0 0; 0 0 -1; 0 1 0]; %Need to swap y,z

    % Create N Rz matricies with N betas.
    % Calculate new gravity with zero y and z.
    % Calculate N total transformation matricies T.
    for i=1:N
        Rz(:,:,i) = [cos(beta(i)) -sin(beta(i)) 0; sin(beta(i)) cos(beta(i)) 0; 0 0 1];
        GRAVITY_0yz(i,:) = Rz(:,:,i)*GRAVITY_0z(i,:)';
        T(:,:,i) = T_rot*Rz(:,:,i)*Rx(:,:,i);
    end
    %}
    
    %{
    % -----------------------------------------
    % TRANSFORMATION
    % 1) find angle to set y to zero using Rz
    % 2) find angle to set z to zero using Ry
    % 3) T = Ry*Rz
    % -----------------------------------------

    % 1) Find angle to set y to zero using Rz
    gamma = atan2(-Y_GRAVITY_data,X_GRAVITY_data);
    
    Rz = zeros(3,3,N);
    GRAVITY_0y = zeros(500,3);

    % Create N Rx matricies with N gammas.
    % Calculate new gravity with zero y.
    for i=1:N
        Rz(:,:,i) = [cos(gamma(i)) -sin(gamma(i)) 0; sin(gamma(i)) cos(gamma(i)) 0; 0 0 1];
        GRAVITY_0y(i,:) = Rz(:,:,i)*GRAVITY_data(i,:)';
    end
    
    % 2) Find angle to set y to zero using Ry.
    X_GRAVITY_0y = GRAVITY_0y(:,1);
    Z_GRAVITY_0y = GRAVITY_0y(:,3);
    
    beta =  atan2(Z_GRAVITY_0y,X_GRAVITY_0y);
    
    Ry = zeros(3,3,N);
    GRAVITY_0yz = zeros(500,3);
    T = zeros(3,3,N);

    T_rot = [1 0 0; 0 0 -1; 0 1 0]; %Need to swap y,z

    % Create N Rz matricies with N betas.
    % Calculate new gravity with zero y and z.
    % Calculate N total transformation matricies T.
    for i=1:N
        Ry(:,:,i) = [cos(beta(i)) 0 sin(beta(i)); 0 1 0; -sin(beta(i)) 0 cos(beta(i))];
        GRAVITY_0yz(i,:) = Ry(:,:,i)*GRAVITY_0y(i,:)';
        T(:,:,i) = Ry(:,:,i)*Rz(:,:,i);
    end
    %}
    %{
    GRAVITY_check = zeros(500,3);
    for i=1:N
        GRAVITY_check(i,:) = T(:,:,i)*GRAVITY_data(i,:)';
    end
    %}
    %{
    figure(3);
    clf;
    subplot(2,1,1)
    plot(t,GRAVITY_data);
    title("Transformation of Gravity");
    legend('X','Y','Z');
    subplot(2,1,2)
    plot(t,GRAVITY_0yz);
    legend('X1','Y1','Z1');
    %}
end
