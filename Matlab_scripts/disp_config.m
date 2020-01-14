function [] = disp_config(filename, overwrite, number_samples)
%disp_config displays the configuration of the specific read.
    disp("=======================================");
    disp("READ DATA FROM BNO05 USING ARDUINO NANO");
    disp("=======================================");
    disp("Read Cofiguration:");
    disp(['Filename : ', filename]);
    disp(['Overwrite: ', num2str(overwrite)]);
    disp(['Samples  : ', num2str(number_samples)]);
    disp("---------------------------------------");
end
