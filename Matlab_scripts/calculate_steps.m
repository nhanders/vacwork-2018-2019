function [numSteps] = calculate_steps(IMUdata)
%calculate_steps - Calculate the number of steps using LINEARACCEL data
%   Use the magnitude of the LINEARACCEL XYZ data from the BNO05 IMU
%   to calculate and return the number of steps taken.
    
    disp("Calculating the number of steps...")
    
    %Store time data.
    t = IMUdata(:,1);
    %Store x,y,z LINEARACCEL data.
    LINEARACCEL_data = IMUdata(:,14:16);
    x_LINEARACCEL =  IMUdata(:,14);
    y_LINEARACCEL =  IMUdata(:,15);
    z_LINEARACCEL =  IMUdata(:,16);
    
    %Find the magnitude of the vector data.
    mag_LINEARACCEL = sqrt(x_LINEARACCEL.^2+y_LINEARACCEL.^2+z_LINEARACCEL.^2);
    
    %Convert to zero mean data.
    magNoG_LINEARACCEL = mag_LINEARACCEL-mean(mag_LINEARACCEL);
    %magNoG_LINEARACCEL = mag_LINEARACCEL; %TEMP CHECK
    
    %Set the miniumum peak height to be counted.
    minPeakHeight = std(magNoG_LINEARACCEL);
    line_minPeakHeight = minPeakHeight*ones(numel(t));
    
    %Find the peaks and locations.
    [pks, locs] = findpeaks(magNoG_LINEARACCEL, 'MINPEAKHEIGHT', minPeakHeight);
    
    %plot the raw LINEARACCEL_data.
    figure(10);
    clf;
    subplot(3,1,1);
    plot(t, LINEARACCEL_data);
    title('LINEARACCEL')
    xlabel('Time (s)');
    ylabel('Acceleration Magnitude (m/s^2)');
    legend('X','Y','Z');
    
    %plot the peaks and locations.
    subplot(3,1,2)
    plot(t, magNoG_LINEARACCEL);
    hold on;
    plot(t(locs), pks, 'r', 'Marker', 'v', 'LineStyle', 'none');
    plot(t, line_minPeakHeight,'--');
    title('Counting Steps');
    xlabel('Time (s)');
    ylabel('Acceleration Magnitude, No Gravity (m/s^2)');
    hold off;
    
    %smooth out the data by using a moving average.
    movmean_magNoG_LINEARACCEL = movmean(magNoG_LINEARACCEL,10);
    
    %Set the miniumum peak height to be counted.
    minPeakHeight = std(movmean_magNoG_LINEARACCEL);
    line_minPeakHeight = minPeakHeight*ones(numel(t));
    
    %Find the peaks and locations.
    [pks, locs] = findpeaks(movmean_magNoG_LINEARACCEL, 'MINPEAKHEIGHT', minPeakHeight);
    
    subplot(3,1,3)
    plot(t, movmean_magNoG_LINEARACCEL);
    hold on;
    plot(t(locs), pks, 'r', 'Marker', 'v', 'LineStyle', 'none');
    plot(t, line_minPeakHeight,'--');
    title('Counting Steps with Moving Mean');
    xlabel('Time (s)');
    ylabel('Acceleration Magnitude, No Gravity, Smoothed (m/s^2)');
    hold off;
    
    %UNCOMMENT to compare mov mean sample values.
    %{ 
    movmean1_magNoG_ACCELEROMETER = movmean(magNoG_ACCELEROMETER,10);
    movmean2_magNoG_ACCELEROMETER = movmean(magNoG_ACCELEROMETER,20);
    movmean3_magNoG_ACCELEROMETER = movmean(magNoG_ACCELEROMETER,50);
    figure(11)
    clf;
    subplot(4,1,1)
    plot(t, movmean_magNoG_ACCELEROMETER);
    subplot(4,1,2)
    plot(t, movmean1_magNoG_ACCELEROMETER);
    subplot(4,1,3)
    plot(t, movmean2_magNoG_ACCELEROMETER);
    subplot(4,1,4)
    plot(t, movmean3_magNoG_ACCELEROMETER);
    %}
    
    %UNCOMMENT to try curve fitting.
    %{
    linfit_magNoG_LINEARACCEL = fit(t, magNoG_LINEARACCEL, 'smoothingspline');
    figure(12)
    clf;
    plot(linfit_magNoG_LINEARACCEL, t, magNoG_LINEARACCEL);
    %}
    
    %Count peaks and store as numSteps
    numSteps = numel(pks);
end

