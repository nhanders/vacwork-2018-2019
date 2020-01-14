function [IMUdataTransform] = Transform_IMUdata(IMUdata, T)
%  Use transformation matrix T to transform IMUdata. 
%  Plot and return the results
    
    disp("Transforming IMU data.");

    % Read in the IMU data
    t = IMUdata(:,1);
    LINEARACCEL_data = IMUdata(:,2:4);
    GYROSCOPE_data = IMUdata(:,5:7);
    ACCELEROMETER_data = IMUdata(:,8:10);
    MAGNETOMETER_data = IMUdata(:,11:13);
    EULER_data = IMUdata(:,14:16);
    GRAVITY_data = IMUdata(:,17:19);
    N = numel(t);

    % Initialise IMUdata transformed vectors.
    LINEARACCEL_tfrm = zeros(size(LINEARACCEL_data));
    GYROSCOPE_tfrm = zeros(size(GYROSCOPE_data));
    ACCELEROMETER_tfrm = zeros(size(ACCELEROMETER_data));
    MAGNETOMETER_tfrm = zeros(size(MAGNETOMETER_data));
    EULER_tfrm = zeros(size(EULER_data));
    GRAVITY_tfrm = zeros(size(GRAVITY_data));

    for i=1:N
        LINEARACCEL_tfrm(i,:) = T(:,:,i)*LINEARACCEL_data(i,:)';
        GYROSCOPE_tfrm(i,:) = T(:,:,i)*GYROSCOPE_data(i,:)';
        ACCELEROMETER_tfrm(i,:) = T(:,:,i)*ACCELEROMETER_data(i,:)';
        MAGNETOMETER_tfrm(i,:) = T(:,:,i)*MAGNETOMETER_data(i,:)';
        EULER_tfrm(i,:) = T(:,:,i)*EULER_data(i,:)';
        GRAVITY_tfrm(i,:) = T(:,:,i)*GRAVITY_data(i,:)';
    end

    %{
    figure(5);
    clf;
    subplot(2,1,1)
    plot(t,LINEARACCEL_data);
    legend('X','Y','Z');
    subplot(2,1,2);
    plot(t,LINEARACCEL_tfrm);
    legend('X1','Y1','Z1');
    %}
    
    IMUdataTransform = zeros(size(IMUdata));

    IMUdataTransform(:,1) = t;
    IMUdataTransform(:,2:4) = LINEARACCEL_tfrm;
    IMUdataTransform(:,5:7) = GYROSCOPE_tfrm;
    IMUdataTransform(:,8:10) = ACCELEROMETER_tfrm;
    IMUdataTransform(:,11:13) = MAGNETOMETER_tfrm;
    IMUdataTransform(:,14:16) = EULER_tfrm;
    IMUdataTransform(:,17:19) = GRAVITY_tfrm;
end

