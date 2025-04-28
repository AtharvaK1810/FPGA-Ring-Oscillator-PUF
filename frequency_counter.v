module frequency_counter (
    input wire clk,         // System clock
    input wire reset_n,      // Active low reset
    input wire enable,      // Enable counting
    input wire oscillator_in, // Input from ring oscillator
    output reg [15:0] count // Count value
);
    reg oscillator_prev;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 16'b0;
            oscillator_prev <= 1'b0;
        end 
        else if (enable) begin
            oscillator_prev <= oscillator_in;
            // Detect rising edge of oscillator output
            if (!oscillator_prev && oscillator_in) begin
                count <= count + 1'b1;
            end
        end
    end
endmodule