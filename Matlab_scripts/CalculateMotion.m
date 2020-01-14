function [] = CalculateMotion(IMUVertTransform, IMUAllTransform)
    % -------------------------------------------
    % Calculate the speed using the transfromed
    % -Z linear accelerometer reading.
    % Nick Anderson
    % 9 December 2018
    % -------------------------------------------
    
    disp("---------------------------------------");
    disp("Calculating speed in forward direction.");
    
    % Read in transformed IMUdata.
    t = IMUVertTransform(:,1);
    LINEARACCEL_tfrm = IMUVertTransform(:,2:4);

    % Read Z & YZ transformed linear acceleration.
    Z_LINEARACCEL_tfrm = -LINEARACCEL_tfrm(:,3);
    YZ_LINEARACCEL = IMUAllTransform(:,3:4);
    MAG_YZ_LINEARACCEL = vecnorm(YZ_LINEARACCEL')';
    
    % Plot unfiltered graphs
    GraphsOfMotion(t, Z_LINEARACCEL_tfrm, "Unfiltered",50,1);
    
    % Low pass & bandpass parameters
    Ts = mean(t(2:end)-t(1:end-1));
    Fs = 1/Ts;
    FUpper = 2;
    FLower = 0.1; 
    
    % Low pass accelerometer data to smooth it.
    Z_LINEARACCEL_LP = lowpass(Z_LINEARACCEL_tfrm, FUpper, Fs);
   
    % Plot low pass graphs
    GraphsOfMotion(t, Z_LINEARACCEL_LP, "Low Pass",51,2);
    
    % Bandpass to remove drift.
    Z_LINEARACCEL_BP = highpass(Z_LINEARACCEL_LP, FLower, Fs);
    
    % Plot bandpass graphs
    [velocity, distance] = GraphsOfMotion(t, Z_LINEARACCEL_BP, "Bandpass",52,3);
    
    % Calculate basic stats
    distanceTotal = distance(end);
    maxSpeed = max(abs(velocity));
    avgSpeed = mean(abs(velocity));
    maxAccFwd = max(abs(Z_LINEARACCEL_tfrm)); 
    maxAccPlane = max(MAG_YZ_LINEARACCEL);
    
    disp(['Distance Travelled (m)   : ',num2str(distanceTotal)]);
    disp(['Max Speed (m/s)          : ',num2str(maxSpeed)]);
    disp(['Average Speed (m/s)      : ',num2str(avgSpeed)]);
    disp(['Max Fwd Acc (m/s^2)      : ',num2str(maxAccFwd)]);
    disp(['Max Planar Acc (m/s^2)   : ',num2str(maxAccPlane)]);
    disp("---------------------------------------");
end

