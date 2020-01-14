function [numSteps] = calculate_steps_v2(IMUdata)
%calculate_steps_v2 - Calculate the number of steps using BNO05 LINEARACCEL data
%   This scipt bandpass filters the LINEARACCEL XYZ data, takes
%   mganitude of the result, removes the moving mean from the data,
%   and uses a dynamic threshold to find and return the number of peaks, or "steps".
    
    disp("---------------------------------------");
    disp("Calculating the number of steps...")
    windows = 10; %number of isolated data windows.
   
    %Suppress find peaks warning
    temp = findpeaks([1 1 1 1]);
    [~, id] = lastwarn;
    warning('off',id);
    
    %--------------------------------------------
    % Data acquisition and manipulation
    %--------------------------------------------
    %Store time data.
    t = IMUdata(:,1);

    %Store x,y,z LINEARACCEL data.
    LINEARACCEL_data = IMUdata(:,2:4);

    %----------------------------------------------
    % FILTERING
    %----------------------------------------------
    %Typical max and min period of steps for humans
    Tstep_max = 0.2;
    Tstep_min = 2;
    N = numel(t);
    Ts = t(2)-t(1);
    Fs = 1/Ts;

    fstep_max = 1/Tstep_max;
    fstep_min = 1/Tstep_min;
    
    %Bandpass filter x,y,z acc data.
    %filt_LINEARACCEL_data = bandpass(LINEARACCEL_data, [fstep_min fstep_max], Fs);
    filt_LINEARACCEL_data = LINEARACCEL_data;
    filt_x_LINEARACCEL = filt_LINEARACCEL_data(:,1);
    filt_y_LINEARACCEL = filt_LINEARACCEL_data(:,2);
    filt_z_LINEARACCEL = filt_LINEARACCEL_data(:,3);
   
    %Recalculate magnitude using filtered x,y,z
    filter_mag_LINEARACCEL = sqrt(filt_x_LINEARACCEL.^2+filt_y_LINEARACCEL.^2+filt_z_LINEARACCEL.^2);
    
    %Remove mean with moving mean
    filter_magNoG_LINEARACCEL_2 = filter_mag_LINEARACCEL-movmean(filter_mag_LINEARACCEL, N/windows);

    %UNCOMMENT to view comparison of filtering methods
    %{
    x_LINEARACCEL =  IMUdata(:,14);
    y_LINEARACCEL =  IMUdata(:,15);
    z_LINEARACCEL =  IMUdata(:,16);
    
    %Find the magnitude of the vector data.
    mag_LINEARACCEL = sqrt(x_LINEARACCEL.^2+y_LINEARACCEL.^2+z_LINEARACCEL.^2);

    %Convert to zero mean data.
    magNoG_LINEARACCEL = mag_LINEARACCEL-mean(mag_LINEARACCEL);
 
    %Bandpass filter magnitude data.
    filter_magNoG_LINEARACCEL = bandpass(magNoG_LINEARACCEL, [fstep_min fstep_max], Fs);
    
    figure(30)
    clf;
    subplot(4,1,1)
    plot(t,LINEARACCEL_data);
    ylabel("Original Data.");
    subplot(4,1,2)
    plot(t,magNoG_LINEARACCEL);
    ylabel("Original Data.");
    subplot(4,1,3)
    plot(t,filter_magNoG_LINEARACCEL);
    ylabel("Filtered Data.");
    subplot(4,1,4)
    plot(t,filter_magNoG_LINEARACCEL_2);
    ylabel("Filtered_2 Data.");
    %}
    
    % Old method for peak finding.
    %{
    %Set the miniumum peak height to be counted.
    for i = 1:1:windows 
        minPeakHeight((i-1)*N/windows+1:i*N/windows) = std(filter_magNoG_LINEARACCEL_2((i-1)*N/windows+1:i*N/windows));
    end
    
    %Find the peaks and locations.
    total_pks=[]; total_locs=[];
    min_thresh=1; %Ignore values less than this.
    for i=1:1:windows
        if (minPeakHeight(1+(i-1)*N/windows) < min_thresh)
            [pks, locs] = findpeaks(filter_magNoG_LINEARACCEL_2((i-1)*N/windows+1:i*N/windows), 'MINPEAKHEIGHT', min_thresh);
        else
            [pks, locs] = findpeaks(filter_magNoG_LINEARACCEL_2((i-1)*N/windows+1:i*N/windows), 'MINPEAKHEIGHT', minPeakHeight(1+(i-1)*N/windows));
        end
        locs = locs+(i-1)*N/windows;
        total_pks = [total_pks, pks'];
        total_locs = [total_locs, locs'];
    end
    %}
   
    [pks, locs, minPeakHeight] = peakfinder(filter_magNoG_LINEARACCEL_2, 20);
    
    figure(32)
    clf;
    subplot(3,1,1)
    plot(t,LINEARACCEL_data);
    %title('Steps - BP Filter, Moving Mean, Dynamics Threshold');
    ylabel("Original Data.");
    subplot(3,1,2)
    plot(t,filter_mag_LINEARACCEL);
    ylabel("Mag of filtered data.");
    subplot(3,1,3)
    plot(t, filter_magNoG_LINEARACCEL_2);
    hold on;
    plot(t(locs), pks, 'r', 'Marker', 'v', 'LineStyle', 'none');
    plot(t, minPeakHeight,'--');
    xlabel('Time (s)');
    ylabel('Acc Mag (m/s^2)');
    hold off;
    
    numSteps = numel(pks);
    disp(['Number of steps: ',num2str(numSteps)]);
end

