module alu_tb_top (
    input logic clk,
    input logic rst,
    input logic [2:0] op,
    input logic [31:0] a,
    input logic [31:0] b
);

    // Outputs from reference behavioral model
    logic [31:0] out_spec;
    logic       zero_spec;

    // Outputs from implementation RTL
    logic [31:0] out_impl;
    logic       zero_impl;

    // Instantiate Reference Model
    alu_behavioral u_spec (
        .ALUControl(op), .A(a), .B(b), .Result(out_spec), .Zero(zero_spec), .oVerflow(), .Carry(), .Negative()
    );                                                                       
                                                                             
    // Instantiate RTL Implementation
    alu u_impl (
        .ALUControl(op), .A(a), .B(b), .Result(out_impl), .Zero(zero_impl), .oVerflow(), .Carry(), .Negative()
    );

    // Formal Assertions: Check that outputs match identically
    always_ff @(posedge clk) begin
        if (!rst) begin
            assert_output_match: assert (out_impl == out_spec)
                else $error("Mismatch: RTL out = %0h, Behavioral out = %0h", out_impl, out_spec);
                
            assert_zero_match: assert (zero_impl == zero_spec)
                else $error("Mismatch: RTL zero = %0b, Behavioral zero = %0b", zero_impl, zero_spec);
        end
    end

endmodule
