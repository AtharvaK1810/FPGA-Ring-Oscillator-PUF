module uart_tx(
    input clk,
    input reset_n,
    input [7:0] tx_data,
    input tx_start,
    output reg tx
);

parameter BAUD_RATE = 115200;
parameter CLK_FREQ = 27_000_000;
localparam BAUD_COUNT = CLK_FREQ / BAUD_RATE;

reg [3:0] state = 0;
reg [31:0] baud_counter = 0;
reg [7:0] tx_buffer;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= 0;
        tx <= 1'b1;
    end else begin
        case (state)
            0: if (tx_start) begin
                tx_buffer <= tx_data;
                state <= 1;
                baud_counter <= 0;
            end
            1: begin // Start bit
                tx <= 1'b0;
                if (baud_counter == BAUD_COUNT - 1) begin
                    baud_counter <= 0;
                    state <= 2;
                end else baud_counter <= baud_counter + 1;
            end
            2: begin // Data bits
                tx <= tx_buffer[state-2];
                if (baud_counter == BAUD_COUNT - 1) begin
                    baud_counter <= 0;
                    state <= (state == 9) ? 10 : state + 1;
                end else baud_counter <= baud_counter + 1;
            end
            10: begin // Stop bit
                tx <= 1'b1;
                if (baud_counter == BAUD_COUNT - 1)
                    state <= 0;
                else
                    baud_counter <= baud_counter + 1;
            end
        endcase
    end
end

endmodule
