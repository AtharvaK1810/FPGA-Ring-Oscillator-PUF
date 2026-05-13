// 1. Define the Interface
interface puf_if(input logic clk);
    logic reset_n;
    logic [15:0] ro_outputs;
    logic uart_tx;
endinterface

// 2. The Scoreboard Class (Proves OOP Skills)
class puf_scoreboard;
    int matches = 0;
    int mismatches = 0;

    // Check function: The "Golden Model" logic
    function void check_output(logic [15:0] actual, logic [15:0] expected);
        if (actual === expected) begin
            matches++;
            $display("[SCOREBOARD] Match detected: %h", actual);
        end else begin
            mismatches++;
            $error("[SCOREBOARD] MISMATCH! Hardware: %h | Golden Model: %h", actual, expected);
        end
    endfunction
endclass

// 3. Top-Level Testbench
module puf_verification_top;
    logic clk = 0;
    always #18.5 clk = ~clk;

    puf_if inf(clk); // Instantiate Interface
    puf_scoreboard sb; // Instantiate Scoreboard

    // Connect your hardware (DUT) to the interface
    ro_puf dut (
        .clk(inf.clk),
        .reset_n(inf.reset_n),
        .ro_outputs(inf.ro_outputs)
    );

    initial begin
        sb = new();
        inf.reset_n = 0;
        #50 inf.reset_n = 1;
        
        // Example check: Proves you can verify architectural correctness
        @(posedge clk);
        sb.check_output(inf.ro_outputs, 16'hA5A5); // Replace with actual Golden Model logic
        
        $display("Final Results - Matches: %0d, Mismatches: %0d", sb.matches, sb.mismatches);
        $finish;
    end
endmodule
