% IYOB KINFE
% egyik3@nottingham.ac.uk


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
%a = arduino;

for i = 1:10
    %Turn the LED on
    writeDigitalPin(a, "D10",1);
    pause(0.5)
    
    %Turn the LED off
    writeDigitalPin(a, 'D10', 0);
    pause(0.5)
end
%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]


%b) read data 
duration = 60;
numReadings = duration; 

% Initialize arrays to store time data and temprature data
timeData = zeros(1, numReadings);
tempData = zeros(1, numReadings);

% Define constants from data sheet
zero_deg_vol = 500; % voltage value in mV
Temp_coeff = 10;  % temprature coefficient in mV/C

% Set up Arduino connection 
a = arduino();

% Loop to acquire data every second
for i = 1:numReadings
    %read the voltage from the sensor 
    voltage_out = readVoltage(a,'A0');

   
    % Convert voltage to temperature
    temperature = (voltage_out - zero_deg_vol) / Temp_coeff;

    % Store time and temprature values in designated arrays
    timeData(i) = i;  % Time in second
    tempData(i) = temperature; % Temprature in C

    % Pause for 1 second
    pause(1);
end

% Calculate the minimum, maximum, and average temperature
minTemp = min(tempData);
maxTemp = max(tempData);
avgTemp = mean(tempData);


%C) plot a graph
% Plot a graph of Temperature vs Time
figure;  
plot(timeData, tempData, '-o');  % Plot temperature data
xlabel('Time (s)');  % Label for x-axis
ylabel('Temperature (°C)');  % Label for y-axis
title('Temperature vs Time');  % Plot title
grid on;  % Show grid on the plot

%D)Output to screen formatting 

% Display the statistical results
fprintf('Minimum Temperature: %.2f °C\n', minTemp);
fprintf('Maximum Temperature: %.2f °C\n', maxTemp);
fprintf('Average Temperature: %.2f °C\n', avgTemp);


%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert reflective statement here (400 words max)


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answershere, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.