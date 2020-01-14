function [pks, locs, minPeakHeight] = peakfinder(data, windows)
%My function for finding the peaks of a function over a threshold value

pks = [];
locs = [];

N = numel(data);
minPeakHeight = 1.2*movstd(data, windows);
noPeakHeight = 1;

for i=1:N
    if (minPeakHeight(i)<noPeakHeight)
        minPeakHeight(i) = noPeakHeight;
    end
end

figure(200);
clf;
plot(minPeakHeight);
hold on;
plot(data);
hold off;

for i=2:N-1
    if (data(i)<minPeakHeight(i))
        continue;
    elseif (data(i)>minPeakHeight & ...
            data(i)>data(i+1) & ...
            data(i)>data(i-1))
        pks = [pks,data(i)];
        locs = [locs,i];
    end
end

end

