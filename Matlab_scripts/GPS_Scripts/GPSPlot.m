% --------------------------------
% GPS stuff...
% ---------------------------------
clc;
sFile = 'GPSTest3.csv';

if (~exist(sFile, 'file'))
    disp(['The following file does not exist: ', sFile]); 
else   % if the file exists, load it
    GPSData = csvread(sFile);
end

%load long, lat, hdop, speed and course data.
lat = GPSData(:,1);
lon = GPSData(:,2);
hdop = GPSData(:,3);
speed = GPSData(:,4);
course = GPSData(:,5);
lon_lat = [lon lat];
course_deg = 360-course+90;

%Plot lon vs lat data
figure(1);
clf;
plot(lon,lat);

%Calculate moving mean to remove high frequencies.
speedAvg = movmean(speed,10);

%Plot speed data
figure(2);
clf;
%subplot(2,1,1)
plot(speed(1200:end));
ylabel('Speed [km/h]');
xlabel('Samples');
legend('Speed');
%subplot(2,1,2)
%plot(speedAvg);

%Calculate Haversine distance
radius=6371e3; % metres
latrad = deg2rad(lat);
lonrad = deg2rad(lon);

dlatrad = latrad(2:end)-latrad(1:end-1);
dlonrad = lonrad(2:end)-lonrad(1:end-1);

a = zeros(size(dlatrad));
c = zeros(size(dlatrad));
ddm = zeros(size(latrad));

for i = 1:size(dlatrad)
    a(i)=sin(dlatrad(i)/2)^2 + cos(latrad(i))*cos(latrad(i+1)) * sin(dlonrad(i)/2)^2;
    c(i)=2*atan2(sqrt(a(i)),sqrt(1-a(i)));
end    
ddm(2:end)=radius*c; %This is the distance


%Calculate distance using speed
ddm_est = speed/3.6*0.5; 

ddd_est = km2deg(ddm_est/1000);
ddd_course_est = [ddd_est course_deg];

dlon_lat_est = zeros(size(ddd_course_est));

for i = 1:size(ddd_est)
    dlon_lat_est(i,:) = [ddd_est(i)*cosd(course_deg(i)) ddd_est(i)*sind(course_deg(i))];
end
    
path_est = zeros(size(latrad,1),2);
path_est(1,:) = lon_lat(1,:); %Set the starting coordinates

for i = 2:size(lat)
   path_est(i,:) = path_est(i-1,:)+dlon_lat_est(i,:);
end


figure(3);
clf;
plot(lon,lat);
hold on;
plot(path_est(:,1), path_est(:,2));
hold off;