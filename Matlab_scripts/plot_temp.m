function [] = plot_temp(IMU1,IMU2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    time = IMU1(:,1);
    LINEARACCEL1 = IMU1(:,2:4);
    GRAVITY1 = IMU1(:,17:19);
    LINEARACCEL2 = IMU2(:,2:4);
    GRAVITY2 = IMU2(:,17:19);

    figure(100);
    clf;
    subplot(2,2,1);
    plot(time, LINEARACCEL1);
    title('LINEARACCEL')
    ylabel('Acceleration (m/s^2)');
    xlabel('time (s)');
    legend('X','Y','Z');
    subplot(2,2,2);
    plot(time, GRAVITY1);
    title('GRAVITY')
    ylabel('Acceleration (m/s^2)');
    xlabel('time (s)');
    ylim([-12 12]);
    legend('X','Y','Z');
    subplot(2,2,3);
    plot(time, LINEARACCEL2);
    title('Transformed LINEARACCEL')
    ylabel('Acceleration (m/s^2)');
    xlabel('time (s)');
    legend('X','Y','Z');
    subplot(2,2,4);
    plot(time, GRAVITY2);
    title('Transformed GRAVITY')
    ylabel('Acceleration (m/s^2)');
    xlabel('time (s)');
    ylim([-12 12]);
    legend('X','Y','Z');
end

