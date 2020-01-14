%--------------------------------------------------------
% Read IMU data from .csv file and plot results. This is 
% the "main" script.
% Nick Anderson
% 9 January 2019
%--------------------------------------------------------
 
clc;
%Choose which IMU test to load.
sFile = 'IMU_Tests/AbsOrientation/Test2.csv'; %file to write samples to.

%Load the specified IMU test data to IMUdata.
if (~exist(sFile, 'file')) %if the file does not exists, read instrumentation
    disp(['The following file does not exist: ', sFile]);
    
else   %if the file exists, load it
    disp(['Reading from ', sFile]);
    IMUData = csvread(sFile);
    
    %Decode the data
    t = IMUData(:,1);
    gravity = IMUData(:,2:4);
    eul = deg2rad(IMUData(:,5:7));
    N = numel(t);
    
    % Decode Euler angles
    roll = eul(:,1);
    pitch = eul(:,2);
    yaw = eul(:,3);
    eul2_rpy = [-roll -pitch -yaw]; 
    
    % Transfromation matrix from Euler angles
    tfrmMatrix = eul2rotm(eul2_rpy, 'XYZ');
    
    gravityTfrm = zeros(size(gravity));
    for i=1:N
        gravityTfrm(i,:) = (tfrmMatrix(:,:,i)\gravity(i,:)')'; %inv(A)*b
    end
    
    %Plot untransformed gravity data.
    figure(1)
    clf;
    subplot(2,1,1)
    plot(t,gravity);
    title("Gravity Tranformation");
    ylim([-10, 10]);
    ylabel("Untransformed Gravity");
    legend('x', 'y', 'z');
    
    %Plot transformed gravity
    subplot(2,1,2)
    plot(t,gravityTfrm);
    ylim([-10, 10]);
    ylabel("Transformed Gravity")
    legend('x', 'y', 'z');
    
    %{
    %Plot untransformed gravity data.
    figure(1)
    clf;
    subplot(2,1,1)
    plot(t,gravity);
    ylim([-10, 10]);
    legend('x', 'y', 'z');
    
    %Create transformation matricies using quat.
    %Uncomment to see the long way...
    %{
    wArr = qt(:,1); xArr = qt(:,2);
    yArr = qt(:,3); zArr = qt(:,4);
    tfrmMatrix = zeros(3,3,N);
    eul = zeros(N,3);
    for i = 1:N
        w = wArr(i); x = xArr(i); y = yArr(i); z = zArr(i);
        tfrmMatrix(1,1,i) = w^2 + x^2 - y^2 - z^2;
        tfrmMatrix(1,2,i) = 2*(x*y - w*z);
        tfrmMatrix(1,3,i) = 2*(w*y + x*z);
        tfrmMatrix(2,1,i) = 2*(x*y + w*z);
        tfrmMatrix(2,2,i) = w^2 - x^2 + y^2 - z^2;
        tfrmMatrix(2,3,i) = 2*(-w*x + y*z);
        tfrmMatrix(3,1,i) = 2*(-w*y + x*z);
        tfrmMatrix(3,2,i) = 2*(w*x + y*z);
        tfrmMatrix(3,3,i) = w^2 - x^2 - y^2 + z^2;
        %eul(i,1) = atan2(2*(w*x+y*z),1-2*(x^2+y^2));
        %eul(i,2) = asin(2*(w*y-x*z));
        %eul(i,3) = atan2(2*(w*z+x*y), 1-2*(y^2+z^2));
        eul(i,1) = -atan2(2*(x*z+y*w),1-2*(x^2-y^2));
        eul(i,2) = asin(2*(y*z-x*w));
        eul(i,3) = -atan2(2*(x*y+z*w),1-2*(y^2-z^2));
    end
    eul = rad2deg(eul);
    %}
    
    %Using a Matlab function
    %tfrmMatrixFunc = quat2rotm(qt);
    
    gravityTfrm = zeros(size(gravity));
    for i=1:N
        gravityTfrm(i,:) = (tfrmMatrix(:,:,i)\gravity(i,:)')'; %invA*b
    end
   
    %Plot transformed gravity
    subplot(2,1,2)
    plot(t,gravityTfrm);
    ylim([-10, 10]);
    legend('x', 'y', 'z');

    figure(2);
    plot(t,eul);
    legend('roll','pitch','yaw');
    %}
    
end

%disp("---------------------------------------");
disp("Program Complete.");