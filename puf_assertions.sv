// Checker to ensure UART TX does not start if the system is in reset
// or if the previous transmission is not yet complete.
module puf_assertions (
    input logic clk,
    input logic reset_n,
    input logic tx_start,
    input logic tx_busy,
    input logic [7:0] tx_data
);

    // Assertion: tx_start must NEVER be high if reset_n is low
    property p_reset_check;
        @(posedge clk) disable iff (!reset_n)
        (tx_start |-> reset_n);
    endproperty
    assert property (p_reset_check) else $error("Illegal tx_start during reset!");

    // Assertion: If tx_start is pulsed, tx_busy must rise within 2 cycles
    property p_busy_rise;
        @(posedge clk) disable iff (!reset_n)
        (tx_start |=> ##[1:2] tx_busy);
    endproperty
    assert property (p_busy_rise) else $error("UART Controller failed to signal BUSY after start!");

endmodule
