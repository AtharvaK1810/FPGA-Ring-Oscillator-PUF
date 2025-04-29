function generate_puf_report(responses, reliability_metrics, uniqueness_metrics, entropy_metrics)
    % Create a comprehensive report of PUF analysis results
    
    % Handle missing inputs
    if nargin < 4
        entropy_metrics = struct();
        if nargin < 3
            uniqueness_metrics = struct();
        end
    end
    
    % Create report file
    fid = fopen('puf_analysis_report.html', 'w');
    
    % Write HTML header
    fprintf(fid, '<!DOCTYPE html>\n');
    fprintf(fid, '<html>\n<head>\n');
    fprintf(fid, '<title>Ring Oscillator PUF Analysis Report</title>\n');
    fprintf(fid, '<style>\n');
    fprintf(fid, 'body { font-family: Arial, sans-serif; margin: 40px; }\n');
    fprintf(fid, 'h1 { color: #2c3e50; }\n');
    fprintf(fid, 'h2 { color: #3498db; }\n');
    fprintf(fid, 'table { border-collapse: collapse; width: 100%%; }\n');
    fprintf(fid, 'th, td { text-align: left; padding: 8px; border: 1px solid #ddd; }\n');
    fprintf(fid, 'th { background-color: #f2f2f2; }\n');
    fprintf(fid, '.metric { font-weight: bold; }\n');
    fprintf(fid, '</style>\n');
    fprintf(fid, '</head>\n<body>\n');
    
    % Report header
    fprintf(fid, '<h1>Ring Oscillator PUF Analysis Report</h1>\n');
    fprintf(fid, '<p>Date: %s</p>\n', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
    
    % Data summary
    fprintf(fid, '<h2>Data Summary</h2>\n');
    [num_samples, num_bits] = size(responses);
    fprintf(fid, '<p>Number of samples: %d</p>\n', num_samples);
    fprintf(fid, '<p>Number of bits per response: %d</p>\n', num_bits);
    
    % Raw data table
    fprintf(fid, '<h3>Raw Response Data</h3>\n');
    fprintf(fid, '<table>\n');
    fprintf(fid, '<tr><th>Sample</th>');
    for i = 1:num_bits
        fprintf(fid, '<th>Bit %d</th>', i);
    end
    fprintf(fid, '</tr>\n');
    
    for i = 1:min(num_samples, 20)  % Show first 20 samples
        fprintf(fid, '<tr><td>%d</td>', i);
        for j = 1:num_bits
            fprintf(fid, '<td>%d</td>', responses(i,j));
        end
        fprintf(fid, '</tr>\n');
    end
    fprintf(fid, '</table>\n');
    
    % Reliability analysis
    if ~isempty(fieldnames(reliability_metrics))
        fprintf(fid, '<h2>Reliability Analysis</h2>\n');
        fprintf(fid, '<p class="metric">Overall Reliability: %.2f%%</p>\n', reliability_metrics.overall_reliability);
        fprintf(fid, '<p>Most Reliable Bit: %d (%.2f%%)</p>\n', reliability_metrics.most_reliable_bit, reliability_metrics.max_reliability);
        fprintf(fid, '<p>Least Reliable Bit: %d (%.2f%%)</p>\n', reliability_metrics.least_reliable_bit, reliability_metrics.min_reliability);
        fprintf(fid, '<p>Ideal reliability is 100%% (perfect reproducibility).</p>\n');
    end
    
    % Uniqueness analysis
    if isfield(uniqueness_metrics, 'avg_norm_hamming_distance')
        fprintf(fid, '<h2>Uniqueness Analysis</h2>\n');
        fprintf(fid, '<p class="metric">Average Hamming Distance: %.2f bits (%.2f%%)</p>\n', ...
               uniqueness_metrics.avg_hamming_distance, uniqueness_metrics.avg_norm_hamming_distance);
        fprintf(fid, '<p>Ideal uniqueness is 50%% (maximum entropy).</p>\n');
    end
    
    % Entropy analysis
    if ~isempty(fieldnames(entropy_metrics))
        fprintf(fid, '<h2>Entropy Analysis</h2>\n');
        fprintf(fid, '<p class="metric">Total Entropy: %.2f bits (%.2f%% of maximum)</p>\n', ...
               entropy_metrics.total_entropy, entropy_metrics.entropy_percentage);
        fprintf(fid, '<h3>Bit Bias</h3>\n');
        fprintf(fid, '<table>\n<tr><th>Bit Position</th><th>Probability of 1</th><th>Entropy</th></tr>\n');
        for i = 1:length(entropy_metrics.p_one)
            fprintf(fid, '<tr><td>%d</td><td>%.4f</td><td>%.4f bits</td></tr>\n', ...
                  i, entropy_metrics.p_one(i), entropy_metrics.bit_entropy(i));
        end
        fprintf(fid, '</table>\n');
        fprintf(fid, '<p>Ideal bit bias is 0.5 (equal probability of 0 and 1).</p>\n');
    end
    
    % Conclusions
    fprintf(fid, '<h2>Conclusions</h2>\n');
    fprintf(fid, '<p>Based on the analysis, this Ring Oscillator PUF implementation shows:\n');
    
    % Dynamic conclusions based on metrics
    if isfield(reliability_metrics, 'overall_reliability')
        if reliability_metrics.overall_reliability > 95
            fprintf(fid, '<br>- <strong>High reliability</strong> (%.2f%%), indicating consistent responses across power cycles.', reliability_metrics.overall_reliability);
        else
            fprintf(fid, '<br>- <strong>Moderate reliability</strong> (%.2f%%), suggesting some variability in responses.', reliability_metrics.overall_reliability);
        end
    end
    
    if isfield(uniqueness_metrics, 'avg_norm_hamming_distance')
        if abs(uniqueness_metrics.avg_norm_hamming_distance - 50) < 10
            fprintf(fid, '<br>- <strong>Good uniqueness</strong> (%.2f%%), close to the ideal value of 50%%.', uniqueness_metrics.avg_norm_hamming_distance);
        else
            fprintf(fid, '<br>- <strong>Limited uniqueness</strong> (%.2f%%), deviating from the ideal value of 50%%.', uniqueness_metrics.avg_norm_hamming_distance);
        end
    end
    
    if isfield(entropy_metrics, 'entropy_percentage')
        if entropy_metrics.entropy_percentage > 90
            fprintf(fid, '<br>- <strong>High entropy</strong> (%.2f%% of maximum), suggesting good randomness properties.', entropy_metrics.entropy_percentage);
        else
            fprintf(fid, '<br>- <strong>Moderate entropy</strong> (%.2f%% of maximum), indicating potential for improved randomness.', entropy_metrics.entropy_percentage);
        end
    end
    
    fprintf(fid, '</p>\n');
    
    % Implementation challenges
    fprintf(fid, '<h2>Implementation Challenges</h2>\n');
    fprintf(fid, '<p>Implementing Ring Oscillator PUFs on FPGAs presents several challenges:</p>\n');
    fprintf(fid, '<ul>\n');
    fprintf(fid, '<li>Synthesis tools may optimize away oscillator loops, reducing entropy</li>\n');
    fprintf(fid, '<li>FPGA architectures are more deterministic than ASICs, limiting manufacturing variations</li>\n');
    fprintf(fid, '<li>Routing constraints can make oscillator paths more uniform than desired</li>\n');
    fprintf(fid, '<li>Temperature and voltage variations affect oscillator behavior</li>\n');
    fprintf(fid, '</ul>\n');
    
    % End HTML
    fprintf(fid, '</body>\n</html>');
    fclose(fid);
    
    disp(['Report generated: puf_analysis_report.html']);
end