module ring_oscillator #(
    parameter INDEX = 0  // Unique identifier for each oscillator
)(
    input enable,
    output out
);
    // Use Gowin primitives to create a ring oscillator that won't be optimized away
    
    (* syn_preserve = "true" *)
    (* syn_keep = "true" *)
    (* keep = "true" *)
    wire [4:0] chain;
    
    // Use primitive instantiation to avoid optimization
    (* syn_preserve = "true" *)
    (* syn_keep = "true" *)
    (* keep = "true" *)
    LUT4 #(
        .INIT(16'h5555 ^ (INDEX & 16'h000F))  // Use 16-bit values
    ) lut1 (
        .F(chain[0]),
        .I0(enable & chain[4]),
        .I1(1'b0),
        .I2(1'b0),
        .I3(1'b0)
    );
    
    (* syn_preserve = "true" *)
    (* syn_keep = "true" *)
    (* keep = "true" *)
    LUT4 #(
        .INIT(16'h5555 ^ ((INDEX >> 1) & 16'h000F))
    ) lut2 (
        .F(chain[1]),
        .I0(chain[0]),
        .I1(1'b0),
        .I2(1'b0),
        .I3(1'b0)
    );
    
    (* syn_preserve = "true" *)
    (* syn_keep = "true" *)
    (* keep = "true" *)
    LUT4 #(
        .INIT(16'h5555 ^ ((INDEX >> 2) & 16'h000F))
    ) lut3 (
        .F(chain[2]),
        .I0(chain[1]),
        .I1(1'b0),
        .I2(1'b0),
        .I3(1'b0)
    );
    
    (* syn_preserve = "true" *)
    (* syn_keep = "true" *)
    (* keep = "true" *)
    LUT4 #(
        .INIT(16'h5555 ^ ((INDEX >> 3) & 16'h000F))
    ) lut4 (
        .F(chain[3]),
        .I0(chain[2]),
        .I1(1'b0),
        .I2(1'b0),
        .I3(1'b0)
    );
    
    // Output - use a LUT to create the final stage
    (* syn_preserve = "true" *)
    (* syn_keep = "true" *)
    (* keep = "true" *)
    LUT1 #(
        .INIT(2'h1)  // Simple inverter
    ) out_lut (
        .F(chain[4]),
        .I0(chain[3])
    );
    
    assign out = chain[4];
endmodule