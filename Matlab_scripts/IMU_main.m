%--------------------------------------------------------
% Read IMU data from .csv file and plot results. This is 
% the "main" script.
% Nick Anderson
% 9 January 2019
%--------------------------------------------------------
 
clc;
%Choose which IMU test to load.
sFile = 'IMU_Tests/Nick_new/IMU_Walk.csv'; %file to write samples to.

% Display a pretty looking header,
disp("=======================================");
disp("READ BNO055 IMU DATA FROM .csv FILE");
disp("=======================================");
disp('Read Configuration:');
disp(['Filename: ', sFile]);
disp("---------------------------------------");

% Load the specified IMU test data to IMUdata.
if (~exist(sFile, 'file')) % if the file does not exists, read instrumentation
    disp(['The following file does not exist: ', sFile]);
    
else   % if the file exists, load it
    disp(['Reading from ', sFile]);
    IMUdata = csvread(sFile);
    %plot the raw IMU data.
    plot_IMUdata(IMUdata, 1, 'Raw IMU Data');
    disp("Plotting complete.")

    % --------------------------------------------
    % CALCULATE THE NUMBER OF STEPS
    %---------------------------------------------
    %UNCOMMNET - to calculate steps
    %
    %numSteps = calculate_steps_v2(IMUdata);
    %}
    
    
    % --------------------------------------------
    % TRANSFORM IMU DATA
    % --------------------------------------------
    % Get the transform matrix.
    rotmAll = getTransformAllGravity(IMUdata);
    rotmVert = getTransformVertGravity(IMUdata);
    % Transform the IMU data using transfrom matrix.
    IMUdataAllTransform = Transform_IMUdata(IMUdata, rotmAll);
    IMUdataVertTransform = Transform_IMUdata(IMUdata, rotmVert); 
    disp("IMU data transformation complete.")
    % Plot transformed IMU data.
    plot_IMUdata(IMUdataAllTransform, 20, 'Transformed IMU Data - Full');
    plot_IMUdata(IMUdataVertTransform, 30, 'Transformed IMU Data - Vertical Only');
    
    %plot_temp(IMUdata, IMUdataAllTransform);
    
    % --------------------------------------------
    % CALCULATE MOTION METRICS
    % --------------------------------------------
    %CalculateMotion(IMUdataVertTransform, IMUdataAllTransform);
    
end

%disp("---------------------------------------");
disp("Program Complete.");

