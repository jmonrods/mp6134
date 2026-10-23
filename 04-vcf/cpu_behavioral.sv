// 32-bit RISC-V Single-Cycle Processor (Behavioral)

module cpu_behavioral (
    input clk,
    input rst,
    input  [31:0] Instr,
    output logic [31:0] Result,
    output logic [31:0] PC
);

    logic [31:0] register_bank [32];

    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
    logic [11:0] imm;
    logic [6:0]  opcode;
    logic [2:0]  funct3;
    logic [6:0]  funct7;

    typedef enum {ADDI, ADD, SUB, AND, OR, SLT} op_e;

    op_e operation;
    

    always @ (posedge clk) begin

        if(!rst) begin
            int i;
            for (i=0; i<32; i++) register_bank[i] = 0;
            PC <= 32'h00400000;
        end
        
        PC <= PC + 4;           // This probably will fail, because the DUT has implemented the beq instruction, the ref model doesn't yet.

        rd  = Instr[11:7];
        rs1 = Instr[19:15];
        rs2 = Instr[24:20];
        imm = Instr[31:20];
        opcode = Instr[6:0];
        funct3 = Instr[14:12];
        funct7 = Instr[31:25];

        case (opcode)
            7'b0110011: // r-type 
            begin
                case (funct3)
                    3'b000: 
                    begin
                        if (funct7[5] == 0) operation = ADD;
                        else operation = SUB;
                    end
                    3'b010: operation = SLT;
                    3'b110: operation = OR;
                    3'b111: operation = AND;
                endcase
            end
            7'b0010011: // i-type
            begin
                operation = ADDI;
            end
        endcase

        case(operation)
            ADD:  Result <= register_bank[rs1] + register_bank[rs2];
            SUB:  Result <= register_bank[rs1] - register_bank[rs2];
            AND:  Result <= register_bank[rs1] & register_bank[rs2];
            OR:   Result <= register_bank[rs1] | register_bank[rs2];
            SLT:  Result <= ($signed(register_bank[rs1]) < $signed(register_bank[rs2])) ? 32'hFFFFFFFF : 32'h00000000;
            ADDI: Result <= register_bank[rs1] + {{20{imm[11]}},imm};
        endcase

    end
    
endmodule

