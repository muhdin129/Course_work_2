function temp_prediction(a)
    % temp_prediction.m
    % Continuously monitors temperature and predicts future temperature
    % It also controls LEDs based on the rate of change of temperature.
    % This function reads the temperature, calculates the rate of change,
    % predicts the temperature in 5 minutes, and controls LED lights based on
    % the temperature rate of change.
    %
    % Green LED for stable temperatures, Red LED for rapid increase, and
    % Yellow LED for rapid decrease. Pass in Arduino object 'a' to control hardware.
 %a = arduino();
    % Initialize LED pins
    green_led = 'D9'; % Green LED pin
    yellow_led = 'D10'; % Yellow LED pin
    red_led = 'D2'; % Red LED pin

    % Variables to store previous temperature and time
    prev_temp = 0;  % Previous temperature in °C
    prev_time = 0;  % Previous time in seconds

    % Smoothing parameters (simple moving average)
    array_size = 5; % Number of data points to average for smoothing
    temp_buffer = zeros(1, array_size); % Buffer for smoothing
    rate_buffer = zeros(1, array_size); % Buffer for storing rate of change

    % Initialize time and temperature data
    time_counter = 0;

    % Start loop
    while true
        % Read temperature from the sensor
        temp_raw = readVoltage(a, 'A1'); % Read sensor value from A0 pin
        temp_C = (temp_raw - 0.5) * 100; % Convert sensor reading to °C

        % Get the current time (in seconds)
        current_time = toc; % Track the time elapsed since start of the loop

        % Calculate the time difference (time in seconds) and temperature change
        delta_time = current_time - prev_time;
        delta_temp = temp_C - prev_temp;

        % Calculate the rate of change (°C/min)
        if delta_time > 0
            rate_of_change = (delta_temp / delta_time) * 60; % °C per minute
        else
            rate_of_change = 0; 
        end

       

         % Smoothing the rate of change 
        rate_buffer = [rate_of_change, rate_buffer(1:end-1)]; % Shift and add new value
        smoothed_rate_of_change = mean(rate_buffer); % Compute average rate of change

        % Predict the temperature in 5 minutes
        predicted_temp = temp_C + (smoothed_rate_of_change * 5);

        % Display the current temperature, rate of change, and predicted temperature
        fprintf('Current Temp: %.2f°C, Predicted Temp in 5 mins: %.2f°C, Rate of Change: %.2f°C/min\n', ...
                temp_C, predicted_temp, smoothed_rate_of_change);

        % Control LEDs based on rate of change
        if smoothed_rate_of_change > 4
            % Rate of change > 4°C/min, show Red LED
            writeDigitalPin(a, green_led, 0);
            writeDigitalPin(a, yellow_led, 0);
            writeDigitalPin(a, red_led, 1); % Turn on Red LED
        elseif smoothed_rate_of_change < -4
            % Rate of change < -4°C/min, show Yellow LED
            writeDigitalPin(a, green_led, 0);
            writeDigitalPin(a, red_led, 0);
            writeDigitalPin(a, yellow_led, 1); % Turn on Yellow LED
        else
            % Rate of change within comfort range, show Green LED
            writeDigitalPin(a, green_led, 1); % Turn on Green LED
            writeDigitalPin(a, yellow_led, 0);
            writeDigitalPin(a, red_led, 0);
        end
        % Store current temperature and time for the next cycle
        prev_temp = temp_C;
        prev_time = current_time;

        % Pause for 1 second before the next reading
        pause(1);
    end
end
