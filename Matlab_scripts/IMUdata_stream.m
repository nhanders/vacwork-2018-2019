%--------------------------------------------------------
% Read serial data from the Arduino Nano, save to .csv
% and plot results. This is the "main" script.
% Nick Anderson
% 27 November 2018
%--------------------------------------------------------

N = 500; %number of samples to be read Arduino.
sFile = 'IMU_Tests/Nick/IMU_WALK_SPEEDUP.csv'; %file to write samples to.
overwrite = 0; %set to 1 to overwrite .csv file with new data.
BaudRate = 115200;

disp_config(sFile, overwrite, N);

if (exist(sFile, 'file') == 0 || overwrite) % if the file does not exists, read instrumentation
    delete(instrfindall);   %pre-emptively close all ports
    s1 = serial('COM5','BaudRate',BaudRate);    %define serial port to read the Arduino
    fopen(s1);
    s1.ReadAsyncMode = 'continuous';
    readasync(s1);
    disp("Waiting for data...");
    tic
    while(s1.BytesAvailable <= 0)  %wait until Arduino outputs data
        if (toc>15)
            disp("Connection Timeout.")
            disp("Closing serial port.")
            delete(instrfindall);    % close the serial port
            disp("---------------------------------------");
            disp("Program Complete.");
            return
        end
    end
    input('Press any key to start data streaming. '); %wait for user to start streaming
    disp("Data streaming.");
    mData = read_IMUdata(N, s1, sFile);    
else   % if the file exists, load it
    disp(['Reading from ', sFile]);
    mData = csvread(sFile);  
end

%plot the raw IMU data.
plot_IMUdata(mData);
%freq_analysis(mData);

%calculate the number of steps.
disp("---------------------------------------");
%numSteps = calculate_steps(mData);
%disp(['Number of steps: ',num2str(numSteps)]);

%UNCOMMNET - to calculate steps
%{
numSteps = calculate_steps_v2(mData);
disp(['Number of steps: ',num2str(numSteps)]);
%}

disp("---------------------------------------");
disp("Program Complete.");
