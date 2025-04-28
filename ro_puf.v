module ro_puf(
    input clk,
    input reset_n,
    output [15:0] ro_outputs
);
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : ro_instances
            (* syn_preserve = "true" *)
            (* syn_keep = "true" *)
            (* keep = "true" *)
            ring_oscillator #(
                .INDEX(i)  // Each oscillator gets unique index
            ) ro_inst (
                .enable(reset_n),
                .out(ro_outputs[i])
            );
        end
    endgenerate
    
    // Add XOR sampling to ensure logic isn't optimized away
    // This is only for synthesis - doesn't affect the output
    (* syn_preserve = "true" *)
    (* syn_keep = "true" *)
    (* keep = "true" *)
    reg [15:0] xor_chain = 0;
    
    always @(posedge clk) begin
        if (!reset_n)
            xor_chain <= 16'h0;
        else
            xor_chain <= xor_chain ^ ro_outputs;
    end
endmodule