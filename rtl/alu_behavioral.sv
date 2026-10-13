// 32-bit ALU (Behavioral)
// Each operation needs to be replaced with proper hardware
module alu_behavioral (
    input        [2:0]  ALUControl,
    input        [31:0] A,
    input        [31:0] B,
    output logic [31:0] Result,
    output logic        oVerflow,
    output logic        Carry,
    output logic        Negative,
    output logic        Zero
);

    always_comb begin

        case (ALUControl)
            3'b000:  Result = A + B;              // add
            3'b001:  Result = A - B;              // subtract
            3'b010:  Result = A && B;             // and
            3'b011:  Result = A || B;             // or
            3'b101:  Result = (A < B) ? 1 : 0;    // slt (set if less than)
            default: Result = 32'hDEADBEEF;             // error
        endcase

    end

	// flags
    assign Zero = (Result == 0) ? 1 : 0;
    assign oVerflow = ~(A[31] ^ B[31] ^ ALUControl[0]) & (A[31] ^ Result[31]) & ~ALUControl[1];
    assign Carry = ~ALUControl[1] & Carry;
    assign Negative = Result[31];
    
endmodule

