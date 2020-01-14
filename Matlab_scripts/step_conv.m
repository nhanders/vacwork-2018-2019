% Looking at how effective correlation is at detecting steps.
% Method:   1) find a "step template" from the recorded data.
%           2) move the step to the origin
%           3) convolve the step with the whole data set.
%           4) Use threshold peak detection.
% -----------------------------------------------------------

sFile = 'IMU_Tests/IMU_JOG_144bpm.csv';
sFile2 = 'IMU_Tests/IMU_WALK_100bpm.csv';
disp(['Reading from ', sFile]);
IMUdata = csvread(sFile);   %Read IMU data from .csv
IMUdata2 = csvread(sFile2); 
X_LINACC = IMUdata(:,2);    %Linear acceleration data
X_LINACC2 = IMUdata2(:,2);

N = numel(IMUdata(:,1));
N_0 = 82;
N_1 = 115;
len_step = numel(IMUdata(N_0:N_1,2)');
step_plot = [zeros(1,N_0-1) IMUdata(N_0:N_1,2)' zeros(1,N-N_1)];
step = [IMUdata(N_0:N_1,2)' zeros(1,N-numel(IMUdata(N_0:N_1,2)'))];

step_conv_data = conv(step,IMUdata(:,2));
step_conv_data2 = conv(step,IMUdata2(:,2));

figure(20)
clf;
subplot(3,1,1);
plot(X_LINACC);
hold on;
plot(step_plot);
plot(IMUdata2(:,2));
hold off;
subplot(3,1,2);
plot(step_conv_data);
hold on;
plot(step_conv_data2);
hold off;

%Set the threshold.
minPeakHeight = mean(step.^2*(len_step));

%Find the peaks and locations.
[pks, locs] = findpeaks(step_conv_data, 'MINPEAKHEIGHT', minPeakHeight);

%plot the peaks and locations.
subplot(3,1,3)
plot(step_conv_data);
hold on;
plot(locs, pks, 'r', 'Marker', 'v', 'LineStyle', 'none');
hold off;


