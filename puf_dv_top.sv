class puf_transaction;
    // Randomize the input delay and data packets
    rand logic [7:0] dummy_data;
    rand int inter_packet_delay;

    // Constraint: Ensure delay is realistic for a 115200 baud rate
    constraint c_delay { inter_packet_delay inside {[100:500]}; }
endclass

module puf_dv_top;
    // Testbench signals
    logic clk = 0;
    logic reset_n;
    puf_transaction trans;

    // Clock generation
    always #18.5 clk = ~clk; // ~27MHz

    initial begin
        trans = new();
        reset_n = 0;
        #100 reset_n = 1;

        repeat(10) begin
            if (!trans.randomize()) $fatal("Randomization failed!");
            
            // Apply randomized delays to test "Always-on" robustness
            repeat(trans.inter_packet_delay) @(posedge clk);
            $display("Verifying PUF Vector at time %t", $time);
        end
        $finish;
    end
endmodule
