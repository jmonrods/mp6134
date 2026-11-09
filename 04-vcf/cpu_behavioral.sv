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

    assign rd  = Instr[11:7];
    assign rs1 = Instr[19:15];
    assign rs2 = Instr[24:20];
    assign imm = Instr[31:20];
    assign opcode = Instr[6:0];
    assign funct3 = Instr[14:12];
    assign funct7 = Instr[31:25];

    typedef enum {ADDI, ADD, SUB, AND, OR, SLT} op_e;

    op_e operation;
    int i;
    

    always @ (posedge clk) begin

        if (!rst) begin
            for (i=0; i<32; i++) register_bank[i] <= 0;
            PC <= 32'h00400000;
        end else begin

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
                ADD:  register_bank[rd] <= (rd == 5'b00000) ? 0 : register_bank[rs1] + register_bank[rs2];
                SUB:  register_bank[rd] <= (rd == 5'b00000) ? 0 : register_bank[rs1] - register_bank[rs2];
                AND:  register_bank[rd] <= (rd == 5'b00000) ? 0 : register_bank[rs1] & register_bank[rs2];
                OR:   register_bank[rd] <= (rd == 5'b00000) ? 0 : register_bank[rs1] | register_bank[rs2];
                SLT:  register_bank[rd] <= (rd == 5'b00000) ? 0 : ($signed(register_bank[rs1]) < $signed(register_bank[rs2])) ? 32'hFFFFFFFF : 32'h00000000;
                ADDI: register_bank[rd] <= (rd == 5'b00000) ? 0 : register_bank[rs1] + {{20{imm[11]}},imm};
            endcase
            
            Result <= register_bank[rd];
            PC <= PC + 4;

        end
    
    end
    
endmodule

