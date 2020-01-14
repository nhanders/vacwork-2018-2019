function [IMUdata] = read_IMUdata(no_samp, serial_device, sFile)
%Read the BNO05 IMU data from the Arduino Nano 
    
    IMUdata = zeros(no_samp,19); %initialise IMUdata array
    %tic %start timer
    
    %Read data samples from IMU
    for i=1:no_samp   
        if (i==no_samp/4); disp("25%"); end
        if (i==no_samp/2); disp("50%"); end 
        if (i==no_samp/4*3); disp("75%"); end
        sSerialData = fscanf(serial_device); %read sensor
        flushinput(serial_device);
        t = strsplit(sSerialData,'\t'); % same character as the Arduino code
        try
            %store time
            IMUdata(i,1) = str2double(t(1));
            %store LINEARACCEL data
            IMUdata(i,2) = str2double(t(2)); 
            IMUdata(i,3) = str2double(t(3));
            IMUdata(i,4) = str2double(t(4));
            %store GYROSCOPE data
            IMUdata(i,5) = str2double(t(5)); 
            IMUdata(i,6) = str2double(t(6));
            IMUdata(i,7) = str2double(t(7));
            %{
            %store ACCELEROMETER data
            IMUdata(i,8) = str2double(t(8)); 
            IMUdata(i,9) = str2double(t(9));
            IMUdata(i,10) = str2double(t(10));
            %store MAGNETOMETER data            
            IMUdata(i,11) = str2double(t(11)); 
            IMUdata(i,12) = str2double(t(12));
            IMUdata(i,13) = str2double(t(13));
            %store EULER data
            IMUdata(i,14) = str2double(t(14)); 
            IMUdata(i,15) = str2double(t(15));
            IMUdata(i,16) = str2double(t(16));
            %store GRAVITY data
            IMUdata(i,17) = str2double(t(17)); 
            IMUdata(i,18) = str2double(t(18));
            IMUdata(i,19) = str2double(t(19));
            %}
        catch ME
            disp(ME);
            disp("Closing serial port.")
            delete(instrfindall);
            return;
        end
    end
    
    disp("100% - Done reading data.");
    disp(['Time ellapsed: ',num2str(toc)]);
    
    disp("Closing serial port.");
    delete(instrfindall);    % close the serial port
    disp(['Writing to ', sFile]);
    csvwrite(sFile,IMUdata);   % save the data to a CSV file
end

