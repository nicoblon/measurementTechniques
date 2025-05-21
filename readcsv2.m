%Set up serial port
serialPort = "/dev/cu.usbmodem14401"; % Change to your actual port
baudRate = 115200;
s = serialport(serialPort, baudRate);
% Configure line terminator
configureTerminator(s, "LF");
flush(s);

% Send "enter" to Arduino
writeline(s, "enter");
disp("Sent 'enter' to Arduino. Waiting 3 seconds...");
pause(3); % Wait 3 seconds

% Prepare to collect data
data = []; % dynamic array
disp("Reading data for 30 seconds...");

% Set up a timer to stop after 30 seconds
startTime = tic;  % Start timer

% Configure callback for serial port - Triggered when bytes are available
configureCallback(s, "byte", 1, @(src, event) readSerialData(src));

% Timer to stop after 30 seconds
while toc(startTime) < 30
    % Just let the callback handle the data collection
    pause(0.1);  % Small pause to allow callback to run
end

% Save data to CSV
filename = "arduino_data.csv";
writematrix(data, filename);
disp("Data saved to " + filename);

% Disconnect from serial port
clear s;  % Close the serial port connection
disp("Serial connection closed.");

% Callback function to process incoming serial data
function readSerialData(src)
    % Read the line from the serial port
    line = readline(src);
    
    % Convert the line to numeric values
    values = str2double(split(char(line), ','));
    
    % Check if values are valid and append to data
    if numel(values) == 2 && all(~isnan(values))
        data(end+1, :) = values';  % Append row
    else
        warning("Skipped invalid line: %s", line);
    end
end
