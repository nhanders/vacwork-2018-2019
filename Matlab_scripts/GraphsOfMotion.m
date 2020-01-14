function [velocity, distance] = GraphsOfMotion(t, AccData, PlotTitle, FigNo, Label)
%Plot acceleration, velocity, position and distance
   
    velocity = cumtrapz(t, AccData);
    position = cumtrapz(t, velocity);
    distance = cumtrapz(t, abs(velocity));
    
    figure(50);
    %clf;
    subplot(3,3,Label);
    plot(t, AccData);
    title(PlotTitle); 
    ylabel("Fwd Acc (m/s^2)"); grid on;
    subplot(3,3,Label+3);
    plot(t,velocity);
    ylabel("Fwd Vel (m/s)"); grid on;
    subplot(3,3,Label+6);
    plot(t,position);
    hold on
    plot(t,distance);
    hold off;
    ylabel("Pos & Dist (m)"); grid on;
    legend('Position','Distance');
    
    figure(60);
    clf;
    subplot(3,1,1);
    plot(t, AccData); 
    ylabel("Acceleration (m/s^2)"); grid on;
    legend('Acceleration');
    subplot(3,1,2);
    plot(t,velocity);
    ylabel("Fwd Vel (m/s)"); grid on;
    legend('Velocity');
    subplot(3,1,3);
    plot(t,position);
    hold on
    plot(t,distance);
    hold off;
    ylabel("Pos & Dist (m)"); grid on;
    xlabel('time (s)');
    legend('Position','Distance');
end

