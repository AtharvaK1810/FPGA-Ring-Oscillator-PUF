function responses = puf_data_collection(num_samples, com_port, baud_rate)
    % Default parameters if not specified
    if nargin < 1, num_samples = 100; end
    if nargin < 2, com_port = 'COM3'; end
    if nargin < 3, baud_rate = 115200; end
    
    % Setup the serial connection
    s = serialport(com_port, baud_rate);
    s.Timeout = 5; % 5 second timeout
    
    % Display collection information
    fprintf('Collecting %d PUF responses from %s...\n', num_samples, com_port);
    
    % Pre-allocate array for responses (6-bit PUF responses for 6 LEDs)
    responses = zeros(num_samples, 6);
    
    % Collection loop
    for i = 1:num_samples
        % Wait for data with timeout handling
        start_time = tic;
        while s.NumBytesAvailable < 1
            if toc(start_time) > 2 % 2 second timeout
                warning('Timeout waiting for response on sample %d', i);
                break;
            end
            pause(0.01);
        end
        
        % Read response if available
        if s.NumBytesAvailable > 0
            % Read the byte
            response_byte = read(s, 1, "uint8");
            
            % Convert to binary array (bits)
            bit_array = de2bi(response_byte, 8, 'left-msb');
            responses(i, :) = bit_array(3:8);
            
            % Display progress
            if mod(i, 10) == 0
                fprintf('Collected %d/%d samples\n', i, num_samples);
            end
        else
            % Fill with NaN if no response
            responses(i, :) = nan(1, 6);
        end
        
        % Wait between samples
        pause(0.1);
    end
    
    % Close the connection
    clear s;
    
    % Display collection summary
    valid_samples = sum(~isnan(responses(:,1)));
    fprintf('Data collection complete. %d/%d valid samples collected.\n', valid_samples, num_samples);
end