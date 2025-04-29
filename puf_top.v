module puf_top(
    input clk,
    input reset_n,
    output [5:0] led,
    output uart_tx_pin      // Add this UART output pin
);
    wire [15:0] ro_outputs;
    reg [5:0] led_reg = 0;
    reg [23:0] sample_counter = 0;
    
    // UART signals
    reg [7:0] tx_data;
    reg tx_start;
    wire tx_busy;
    
    // Instantiate RO-PUF
    ro_puf ro_puf_inst (
        .clk(clk),
        .reset_n(reset_n),
        .ro_outputs(ro_outputs)
    );
    
    // Sample RO outputs and send via UART
    always @(posedge clk) begin
        if (!reset_n) begin
            sample_counter <= 0;
            led_reg <= 0;
            tx_start <= 0;
        end else begin
            sample_counter <= sample_counter + 1;
            tx_start <= 0; // Default state
            
            // Update LEDs and send UART data periodically
            if (sample_counter == 0) begin
                // Update LEDs
                led_reg[0] <= ro_outputs[0];
                led_reg[1] <= ro_outputs[1];
                led_reg[2] <= ro_outputs[2];
                
                // Send first byte of PUF data via UART
                tx_data <= {5'b0, ro_outputs[2:0]}; // Pack 3 bits of data
                tx_start <= 1;
            end
        end
    end
    
    // Connect LEDs
    assign led = led_reg;
    
    // Instantiate UART transmitter
    uart_tx uart_tx_inst (
        .clk(clk),
        .reset_n(reset_n),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(uart_tx_pin)
    );
endmodule