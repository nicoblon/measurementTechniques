% === Load Data from CSV ===
filename = "TPU-16.05.25/arduino_dataPERIODIC.csv"; % Ensure this file exists in your working directory
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

% === Frequency Analysis Preparation ===
% Assuming periodic force variation from a moving stepper motor

%{
% Uncomment the section below to perform frequency analysis once data is periodic.

% === Define Sampling Rate ===
% You must define the true sampling rate from your experiment
Fs = 100; % [Hz] <-- Set this to the actual rate at which data was recorded

% === Calculate FFT ===
L = length(LoadCellReading);           % Number of samples
Y = fft(LoadCellReading);              % Perform FFT
P2 = abs(Y / L);                       % Two-sided spectrum
P1 = P2(1:L/2+1);                      % One-sided spectrum
P1(2:end-1) = 2 * P1(2:end-1);         % Scale amplitude

f = Fs * (0:(L/2)) / L;                % Frequency axis

% === Plot Frequency Spectrum ===
figure;
plot(f, P1)
xlabel('Frequency [Hz]');
ylabel('|P1(f)|');
title('Single-Sided Amplitude Spectrum of Load Cell Signal');
grid on;

% Optional: Apply a window function or filter to improve frequency resolution
%}