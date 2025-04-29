function uniqueness_metrics = puf_uniqueness_analysis(response_sets)
    % Input: response_sets - Cell array of response matrices from different power cycles
    % Output: uniqueness_metrics - Structure containing uniqueness metrics
    
    num_sets = length(response_sets);
    if num_sets < 2
        error('At least two different response sets are needed for uniqueness analysis');
    end
    
    % Get number of bits from first response set
    num_bits = size(response_sets{1}, 2);
    
    % Calculate average response for each set
    avg_responses = zeros(num_sets, num_bits);
    for i = 1:num_sets
        avg_responses(i, :) = mean(response_sets{i}, 1);
    end
    
    % Calculate hamming distances between all pairs
    hamming_distances = zeros(num_sets, num_sets);
    for i = 1:num_sets
        for j = i+1:num_sets
            hamming_distances(i, j) = sum(avg_responses(i, :) ~= avg_responses(j, :));
            hamming_distances(j, i) = hamming_distances(i, j);
        end
    end
    
    % Calculate normalized hamming distance (percentage)
    norm_hamming_distances = hamming_distances / num_bits * 100;
    
    % Calculate average hamming distance
    avg_hamming_distance = mean(hamming_distances(hamming_distances > 0));
    avg_norm_hamming_distance = mean(norm_hamming_distances(norm_hamming_distances > 0));
    
    % Create visualization
    figure;
    imagesc(norm_hamming_distances);
    colorbar;
    title('Hamming Distance Between Response Sets (%)');
    xlabel('Response Set');
    ylabel('Response Set');
    
    % Package results
    uniqueness_metrics = struct();
    uniqueness_metrics.hamming_distances = hamming_distances;
    uniqueness_metrics.norm_hamming_distances = norm_hamming_distances;
    uniqueness_metrics.avg_hamming_distance = avg_hamming_distance;
    uniqueness_metrics.avg_norm_hamming_distance = avg_norm_hamming_distance;
    
    % Display summary
    disp(['Average Hamming Distance: ', num2str(avg_hamming_distance), ' bits (', ...
          num2str(avg_norm_hamming_distance), '%)']);
    disp(['Ideal Hamming Distance: 50%']);
end