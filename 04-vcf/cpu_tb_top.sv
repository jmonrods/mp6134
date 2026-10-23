module cpu_tb_top (
    input logic clk,
    input logic rst,
    input logic [31:0] Instr,
    input logic [4:0]  rd,
    input logic [4:0]  rs1,
    input logic [4:0]  rs2,
    input logic [11:0] imm
);

    // ToDo: Fix the instruction generation constraints, there are no valid instructions yet
    // ToDo: Data memory needs to be external, since associative arrays are non-synthesizable

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

        rd.randomize();
        rs1.randomize();
        rs2.randomize();
        imm.randomize();

        assume property (
            (Instr == {7'b0000000,rs2,rs1,3'b000,rd,7'b0110011}) || // R-type ADD
            (Instr == {7'b0100000,rs2,rs1,3'b000,rd,7'b0110011}) || // R-type SUB
            (Instr == {7'b0000000,rs2,rs1,3'b111,rd,7'b0110011}) || // R-type AND
            (Instr == {7'b0000000,rs2,rs1,3'b110,rd,7'b0110011}) || // R-type OR
            (Instr == {7'b0000000,rs2,rs1,3'b010,rd,7'b0110011}) || // R-type SLT
            (Instr == {imm,rs1,3'b000,rd,7'b0010011}) // I-type ADDI
        );

        if (!rst) begin
            assert_output_match: assert (out_impl == out_spec)
                else $error("Mismatch: RTL out = %0h, Behavioral out = %0h", out_impl, out_spec);
                
            assert_zero_match: assert (PC_impl == PC_spec)
                else $error("Mismatch: RTL PC = %0b, Behavioral PC = %0b", PC_impl, PC_spec);
        end
    end

endmodule
