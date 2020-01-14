function []= plot_IMUdata(IMUdata, fno, ftitle)
%   plot_IMUdata - plot the saved IMU data

    time = IMUdata(:,1);
    LINEARACCEL_data = IMUdata(:,2:4);
    GYROSCOPE_data = IMUdata(:,5:7);
    ACCELEROMETER_data = IMUdata(:,8:10);
    %MAGNETOMETER_data = IMUdata(:,11:13);
    EULER_data = IMUdata(:,14:16);
    GRAVITY_data = IMUdata(:,17:19);
    QUAT_data = IMUdata(:,20:23);
    
    disp("Plotting IMU measurements.");
    figure(fno)
    clf;
    subplot(3,2,1);
    plot(time, ACCELEROMETER_data);
    title('ACCELEROMETER')
    legend('X','Y','Z');
    subplot(3,2,2);
    plot(time, QUAT_data);
    title('QUATERNION')
    legend('W','X','Y','Z');
    %plot(time, MAGNETOMETER_data);
    %title('MAGNETOMETER')
    %legend('X','Y','Z');
    subplot(3,2,3);
    plot(time, GYROSCOPE_data);
    title('GYROSCOPE')
    legend('X','Y','Z');
    subplot(3,2,4);
    plot(time, EULER_data);
    title('EULER')
    ylim([-360 360]);
    legend('X','Y','Z');
    subplot(3,2,5);
    plot(time, LINEARACCEL_data);
    title('LINEARACCEL')
    ylabel('Acceleration (m/s^2)');
    xlabel('time (s)');
    legend('X','Y','Z');
    subplot(3,2,6);
    plot(time, GRAVITY_data);
    title('GRAVITY')
    ylabel('Acceleration (m/s^2)');
    xlabel('time (s)');
    ylim([-12 12]);
    legend('X','Y','Z');
    suptitle(ftitle);
end
