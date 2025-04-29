function entropy_metrics = puf_entropy_analysis(responses)
    % Input: responses - Matrix of PUF responses (samples x bits).
    % Output: entropy_metrics - Structure containing entropy metrics
    
    [num_samples, num_bits] = size(responses);
    
    % Calculate probability of 1 for each bit position
    p_one = mean(responses, 1);
    
    % Calculate bit entropy using Shannon's formula
    epsilon = 1e-10; % Small value to avoid log(0)
    bit_entropy = -p_one.*log2(p_one + epsilon) - (1-p_one).*log2(1-p_one + epsilon);
    
    % Calculate total entropy
    total_entropy = sum(bit_entropy);
    max_entropy = num_bits; % Maximum possible entropy
    entropy_percentage = total_entropy / max_entropy * 100;
    
    % Create visualization of bit bias
    figure;
    bar(p_one);
    hold on;
    yline(0.5, 'r--', 'Ideal');
    xlabel('Bit Position');
    ylabel('Probability of 1');
    title('PUF Bit Bias Analysis');
    ylim([0 1]);
    grid on;
    
    % Create visualization of entropy
    figure;
    bar(bit_entropy);
    hold on;
    yline(1, 'r--', 'Maximum');
    xlabel('Bit Position');
    ylabel('Entropy (bits)');
    title('PUF Bit Entropy Analysis');
    ylim([0 1]);
    grid on;
    
    % Calculate correlation between bits
    correlation_matrix = corrcoef(responses);
    
    % Create visualization of correlation
    figure;
    imagesc(correlation_matrix);
    colorbar;
    title('Bit Correlation Matrix');
    xlabel('Bit Position');
    ylabel('Bit Position');
    
    % Package results
    entropy_metrics = struct();
    entropy_metrics.p_one = p_one;
    entropy_metrics.bit_entropy = bit_entropy;
    entropy_metrics.total_entropy = total_entropy;
    entropy_metrics.entropy_percentage = entropy_percentage;
    entropy_metrics.correlation_matrix = correlation_matrix;
    
    % Display summary
    disp(['Total Entropy: ', num2str(total_entropy), ' bits (', ...
          num2str(entropy_percentage), '% of maximum)']);
    disp(['Min Bit Entropy: ', num2str(min(bit_entropy)), ' bits (Bit ', ...
          num2str(find(bit_entropy == min(bit_entropy), 1)), ')']);
    disp(['Max Bit Entropy: ', num2str(max(bit_entropy)), ' bits (Bit ', ...
          num2str(find(bit_entropy == max(bit_entropy), 1)), ')']);
end