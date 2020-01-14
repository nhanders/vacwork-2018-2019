 % -------------------------------------------
    % Calculate the speed using the transfromed
    % -Z linear accelerometer reading.
    % Nick Anderson
    % 7 December 2018
    % -------------------------------------------
    
    disp("---------------------------------------");
    disp("Calculating speed in forward direction.");
    
    IMUdataTransform = IMUdataVertTransform;
    
    % Read in transformed IMUdata.
    t = IMUdataTransform(:,1);
    LINEARACCEL_tfrm = IMUdataTransform(:,2:4);

    % Read Z transformed linear acceleration.
    Z_LINEARACCEL_tfrm = -LINEARACCEL_tfrm(:,3);

    % Calculate speed by "integrating"
    velocity = cumtrapz(t, Z_LINEARACCEL_tfrm);

    figure(50);
    clf;
    subplot(2,1,1);
    plot(t, Z_LINEARACCEL_tfrm);
    title("Forward Acceleration (m/s^2)");
    subplot(2,1,2);
    plot(t,velocity);
    title("Forward Velocity (m/s)");

    Ts = mean(t(2:end)-t(1:end-1));
    Fs = 1/Ts;

    Z_LINEARACCEL_LP = lowpass(Z_LINEARACCEL_tfrm, 5, Fs);
    velocity_LP = cumtrapz(t, Z_LINEARACCEL_LP);

    figure(51);
    clf;
    subplot(2,1,1);
    plot(t, Z_LINEARACCEL_LP);
    title("LP Forward Acceleration (m/s^2)");
    subplot(2,1,2);
    plot(t,velocity_LP);
    title("LP Forward Velocity (m/s)");

    maxSpeed = max(velocity);
    avgSpeed = mean(velocity);
    maxAcceleration = max(Z_LINEARACCEL_tfrm); 
    
    disp(['Max Speed        : ',int2str(maxSpeed)]);
    disp(['Average Speed    : ',int2str(avgSpeed)]);
    disp(['Max Acceleration : ',int2str(maxAcceleration)]);
    disp("---------------------------------------");