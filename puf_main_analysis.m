% PUF Main Analysis Script
% This script analyzes Ring Oscillator PUF data manually collected from the FPGA
% Board

responses = [
    0 0 1 1 1 0;   % Observation 1
    1 0 0 1 0 1;   % Observation 2
    1 0 0 1 1 0;   % Observation 3
    0 0 0 1 1 1;   % Observation 4
    1 0 0 1 0 1;   % Observation 5
    0 0 1 1 0 1;   % Observation 6
    1 1 0 1 0 0;   % Observation 7
    0 0 1 1 1 0;   % Observation 8
    0 0 1 1 1 0;   % Observation 9
    1 0 1 1 0 0;   % Observation 10
    1 1 0 0 1 0;   % Observation 11
    1 0 1 1 0 0;   % Observation 12
    1 0 1 0 1 0;   % Observation 13
    0 1 1 0 0 1;   % Observation 14
    1 0 1 1 0 0;   % Observation 15
    0 1 0 1 0 1;   % Observation 16
    0 1 0 1 1 0;   % Observation 17
    0 1 1 0 0 1;   % Observation 18
    0 0 1 1 0 1;   % Observation 19
    1 0 1 0 0 1;   % Observation 20
    1 0 1 0 0 1;   % Observation 21
    0 1 0 0 1 1;   % Observation 22
    0 0 0 1 1 1;   % Observation 23
    0 0 1 1 1 0;   % Observation 24
    0 1 1 1 0 0;   % Observation 25
    0 1 0 1 0 1;   % Observation 26
    0 1 1 0 0 1;   % Observation 27
    1 0 0 1 0 1;   % Observation 28
    1 1 0 0 0 1;   % Observation 29
    0 0 0 1 1 1;   % Observation 30
];

% Save the data for reference
save('puf_responses.mat', 'responses');
disp('Response data saved to puf_responses.mat');

% Analyze reliability
disp('Analyzing reliability...');
reliability_metrics = puf_reliability_analysis(responses);
save('puf_reliability.mat', 'reliability_metrics');

% Prepare data for uniqueness analysis (split the dataset)
num_responses = size(responses, 1);
set1 = responses(1:floor(num_responses/2), :);
set2 = responses(floor(num_responses/2)+1:end, :);
response_sets = {set1, set2};

% Analyze uniqueness
disp('Analyzing uniqueness...');
uniqueness_metrics = puf_uniqueness_analysis(response_sets);
save('puf_uniqueness.mat', 'uniqueness_metrics');

% Analyze entropy
disp('Analyzing entropy...');
entropy_metrics = puf_entropy_analysis(responses);
save('puf_entropy.mat', 'entropy_metrics');

% Generate report
disp('Generating PUF analysis report...');
generate_puf_report(responses, reliability_metrics, uniqueness_metrics, entropy_metrics);

disp('PUF analysis complete!');