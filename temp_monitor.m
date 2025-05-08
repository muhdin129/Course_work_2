function temp_monitor(a)
    % temp_monitor.m
    % Continuously monitors temperature and controls LEDs
    % Based on temperature, LEDs blink or stay on.
    % Green LED: 18-24°C, Yellow LED: below 18°C, Red LED: above 24°C
    % Pass in Arduino object 'a' to control hardware.
    % temp_monitor.m
% This function continuously monitors the temperature from an arduino sensor, 
% controls LEDs based on the temperature range, and plots the temperature data 
% live on a graph. It operates indefinitely, updating the temperature and 
% controlling the LEDs according to the specified temperature ranges.
% Green LED: 18-24°C (constant), Yellow LED: <18°C (blinks every 0.5s), 
% Red LED: >24°C (blinks every 0.25s).

% temp_monitor(a)
% where 'a' is the Arduino odject/function passed to the purpuse build function.
%a = arduino();
    % Initialize LED pins
    green_led = 'D9'; % Green LED pin
    yellow_led = 'D10'; % Yellow LED pin
    red_led = 'D2'; % Red LED pin

   % Define constants from data sheet
    zero_deg_vol = 0.5; % voltage value in V
    Temp_coeff = 0.01;  % temprature coefficient in V/C

    % Create a figure for live plotting
    figure;
    hold on;
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    xlim([0, 100]); %Intializing an array for x axis
    ylim([0, 40]); %Intializing an array for y axis

   % Initialize arrays to store time data and temprature data
    temp_data = []; % Initialize an array to store temperature readings
    time_data = []; % Initialize an array for time stamps
    time_counter = 0; % Start time counter

    while true
        % Read temperature from sensor
        temp_raw = readVoltage(a, 'A1'); % Read sensor value from the desiginated pin
        temp_C = (temp_raw - zero_deg_vol)/Temp_coeff; % Convert to temperature in °C (adjust formula based on sensor)

        % Update live plot
        time_counter = time_counter + 1; % itirate time by one second
        temp_data = [temp_data, temp_C];  
        time_data = [time_data, time_counter];
        plot(time_data, temp_data, 'b');
        drawnow;

        % Control LEDs based on temperature
        if temp_C >= 18 && temp_C <= 24
            % Green LED ON
            writeDigitalPin(a, green_led, 1);
            writeDigitalPin(a, yellow_led, 0);
            writeDigitalPin(a, red_led, 0);
        elseif temp_C < 18
            % Yellow LED blinking
            writeDigitalPin(a, green_led, 0);
            writeDigitalPin(a, red_led, 0);
            writeDigitalPin(a, yellow_led, mod(time_counter, 2)); % Blink every 0.5 second
        else
            % Red LED blinking
            writeDigitalPin(a, green_led, 0);
            writeDigitalPin(a, yellow_led, 0);
            writeDigitalPin(a, red_led, mod(time_counter, 2)); % Blink every 0.25 second
        end

        pause(1); % Wait for 1 second before the next temperature reading
    end
