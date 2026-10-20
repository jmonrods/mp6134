module cpu_tb_top (
    input logic clk,
    input logic rst,
    input logic [31:0] Instr
);

    // ToDo: Instr needs to be constrained, in order to be valid.

    // Outputs from reference behavioral model
    logic [31:0] out_spec;
    logic [31:0] PC_spec;

    // Outputs from implementation RTL
    logic [31:0] out_impl;
    logic [31:0] PC_impl;

    // Instantiate Reference Model
    cpu_behavioral u_spec (
        .clk(clk), .rst(rst), .Instr(Instr), .Result(out_spec), .PC(PC_spec)
    );                                                                       
                                                                             
    // Instantiate RTL Implementation
    cpu u_impl (
        .clk(clk), .rst(rst), .Instr(Instr), .Result(out_impl), .PC(PC_impl)
    );

    // Formal Assertions: Check that outputs match identically
    always_ff @(posedge clk) begin
        if (!rst) begin
            assert_output_match: assert (out_impl == out_spec)
                else $error("Mismatch: RTL out = %0h, Behavioral out = %0h", out_impl, out_spec);
                
            assert_zero_match: assert (PC_impl == PC_spec)
                else $error("Mismatch: RTL PC = %0b, Behavioral PC = %0b", PC_impl, PC_spec);
        end
    end

endmodule
