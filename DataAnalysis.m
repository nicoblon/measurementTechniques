% === Load Data from CSV ===
%filename = "sample3/arduino_data15.csv"; % Ensure this file exists in your working directory
filename = 'TPU-16.05.25/arduino_dataPERIODIC.csv';
rawData = readmatrix(filename);

% === Define Conversion Constants ===
distanceConversionFactor = 0.02; % Convert encoder ticks to mm or other units
forceConversionFactor = 0.0000478305936073059;    % Convert raw load cell reading to Newtons

% === Extract and Convert Columns ===
% Assuming CSV is structured as [EncoderValue, LoadCellValue]
EncoderDistance = rawData(:, 1) * distanceConversionFactor;
LoadCellReading = rawData(:, 2) * forceConversionFactor;

% === Plot Force vs Distance ===
figure;
plot(EncoderDistance, LoadCellReading, '-o');
xlabel('Distance [mm]');
ylabel('Force [N]');
title('Force vs. Distance');
grid on;
%xlim([0 0.8]);  % Only show x >= 0
%ylim([0 150]);  % Only show y >= 0
yticks(0:10:150);        % Adds a line every 0.5 units

% Get axes position in normalized figure units
ax = gca;
pos = ax.Position;

% Arrow on x-axis
annotation('arrow', [pos(1) pos(1) + pos(3)], [pos(2) pos(2)]);

% Arrow on y-axis
annotation('arrow', [pos(1) pos(1)], [pos(2) pos(2) + pos(4)]);

set(gca, 'TickDir', 'out');      % or 'none' to remove completely
set(gca, 'Box', 'off');          % removes top and right axes


