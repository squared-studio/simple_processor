module execution_unit(
    input logic [3:0] opcode,       // 4-bit opcode
    input logic [2:0] rs1,         // 16-bit source register 1
    input logic [2:0] rs2,         // 16-bit source register 2
    input logic [5:0] imm,         // 16-bit immediate value
    output logic [2:0] rd           // 16-bit destination register
);

    always_comb begin
        case (opcode)
            4'b0001: rd = rs1 + imm;           // ADDI
            4'b0011: rd = rs1 + rs2;           // ADD
            4'b1011: rd = rs1 - rs2;           // SUB
            4'b0101: rd = rs1 & rs2;           // AND
            4'b1101: rd = rs1 | rs2;           // OR
            4'b1111: rd = rs1 ^ rs2;           // XOR
            4'b0111: rd = ~rs1;                // NOT
       //     4'b0010: rd = mem[rs1];            // LOAD
        //    4'b1010: mem[rs1] = rs2;           // STORE
            4'b0110: rd = rs1 << rs2;          // SLL
            4'b0100: rd = rs1 >> rs2;          // SLR
            4'b1110: rd = rs1 << imm;          // SLLI
            4'b1100: rd = rs1 >> imm;          // SLRI
            default: rd = 16'h0000;            // Default case
        endcase
    end

endmodule
