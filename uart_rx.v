module uart_rx #(
    parameter CLKS_PER_BIT = 434 // 27MHz / 115200 baud ≈ 234
)(
    input clk,
    input reset,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_ready
);
    // States
    localparam IDLE = 2'b00;
    localparam START_BIT = 2'b01;
    localparam DATA_BITS = 2'b10;
    localparam STOP_BIT = 2'b11;
    
    reg [1:0] state;
    reg [15:0] counter;
    reg [2:0] bit_index;
    reg [7:0] rx_data_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rx_ready <= 1'b0;
            counter <= 0;
            bit_index <= 0;
            rx_data <= 0;
            rx_data_reg <= 0;
        end 
        else begin
            case (state)
                IDLE: begin
                    rx_ready <= 1'b0;
                    counter <= 0;
                    bit_index <= 0;
                    
                    if (rx == 1'b0) begin  // Start bit detected
                        state <= START_BIT;
                    end
                end
                
                START_BIT: begin
                    // Wait half of CLKS_PER_BIT to sample in the middle of the start bit
                    if (counter < (CLKS_PER_BIT - 1) / 2) begin
                        counter <= counter + 1'b1;
                    end 
                    else begin
                        // Check if still low (valid start bit)
                        if (rx == 1'b0) begin
                            counter <= 0;
                            state <= DATA_BITS;
                        end 
                        else begin
                            state <= IDLE;  // False start
                        end
                    end
                end
                
                DATA_BITS: begin
                    if (counter < CLKS_PER_BIT - 1) begin
                        counter <= counter + 1'b1;
                    end 
                    else begin
                        counter <= 0;
                        // Sample the rx line
                        rx_data_reg[bit_index] <= rx;
                        
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1'b1;
                        end 
                        else begin
                            bit_index <= 0;
                            state <= STOP_BIT;
                        end
                    end
                end
                
                STOP_BIT: begin
                    if (counter < CLKS_PER_BIT - 1) begin
                        counter <= counter + 1'b1;
                    end 
                    else begin
                        rx_ready <= 1'b1;
                        rx_data <= rx_data_reg;
                        counter <= 0;
                        state <= IDLE;
                    end
                end
                
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule