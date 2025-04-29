function reliability_metrics = puf_reliability_analysis(responses)
    % Input: responses - Matrix of PUF responses (samples x bits)
    % Output: reliability_metrics - Structure containing reliability metrics
    
    [num_samples, num_bits] = size(responses);
    
    % Calculate bit stability (consistency of bits across samples)
    reliability = zeros(1, num_bits);
    for bit = 1:num_bits
        % Most common value for this bit position
        most_common = mode(responses(:, bit));
        % Percentage of time this bit matches the most common value
        reliability(bit) = sum(responses(:, bit) == most_common) / num_samples * 100;
    end
    
    % Plot reliability of each bit
    figure;
    bar(reliability);
    xlabel('Bit Position');
    ylabel('Reliability (%)');
    title('PUF Bit Reliability Across Power Cycles');
    ylim([0 100]);
    grid on;
    
    % Calculate overall reliability
    overall_reliability = mean(reliability);
    disp(['Overall Reliability: ', num2str(overall_reliability), '%']);
    
    % Identify most and least reliable bits
    [max_reliability, most_reliable_bit] = max(reliability);
    [min_reliability, least_reliable_bit] = min(reliability);
    
    % Package results
    reliability_metrics = struct();
    reliability_metrics.bit_reliability = reliability;
    reliability_metrics.overall_reliability = overall_reliability;
    reliability_metrics.most_reliable_bit = most_reliable_bit;
    reliability_metrics.max_reliability = max_reliability;
    reliability_metrics.least_reliable_bit = least_reliable_bit;
    reliability_metrics.min_reliability = min_reliability;
end