% Set up serial port
serialPort = "/dev/cu.usbmodem14201"; % Change to your actual port
baudRate = 115200;
s = serialport(serialPort, baudRate);

% Configure line terminator
configureTerminator(s, "LF");
flush(s);
pause(2);

% Send "enter" to Arduino
writeline(s, "enter");
disp("Sent 'enter' to Arduino. Waiting 3 seconds...");
pause(3); % Wait 3 seconds

% Prepare to collect data
data = []; % dynamic array
disp("Reading data for 30 seconds...");

% Set the timeout duration (30 seconds)
timeout = 10;
startTime = tic;  % Start timer

% Increase the serial port buffer size to handle larger amounts of data
s.InputBufferSize = 4096;  % Default is usually 512 or 1024
s.OutputBufferSize = 4096;  % Increase both if needed


while toc(startTime) < timeout
    % Check if there's serial data available
    if s.NumBytesAvailable > 0
        line = readline(s);
        values = str2double(split(char(line), ','));

        % Check if values are valid and append to data
        if numel(values) == 2 && all(~isnan(values))
            data(end+1, :) = values';  % Append row
        else
            warning("Skipped invalid line: %s", line);
        end
    end
end

% Save data to CSV
filename = "arduino_data.csv";
writematrix(data, filename);
disp("Data saved to " + filename);

% Disconnect from serial port
clear s;  % Close the serial port connection
disp("Serial connection closed.");
