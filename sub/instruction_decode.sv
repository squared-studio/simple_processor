module instruction_decode(
  input [15:0] instruction,
  output reg [3:0] opcode,
  output reg [2:0] rd,
  output reg [2:0] rs1,
  output reg [2:0] rs2,
  output reg [5:0] imm
  );

  always @ (instruction) begin
    opcode = instruction[3:0];
    case (opcode)
      4'b0001: begin // ADDI
        rd = instruction[15:13];
        rs1 = instruction[12:10];
        imm = instruction[9:4];
      end
      4'b0011, 4'b1011, 4'b0101, 4'b1101, 4'b1111, 4'b1010, 4'b0110, 4'b0100: begin // ADD, SUB, AND, OR, XOR, STORE, SLL, SLR
        rd = instruction[15:13];
        rs1 = instruction[12:10];
        rs2 = instruction[9:7];
        end
      4'b0010, 4'b1100: begin // NOT, LOAD
        rd = instruction[15:13];
        rs1 = instruction[12:10];
      end
      4'b1110, 4'b1100: begin // SLLI, SLRI
        rd = instruction[15:13];
        rs1 = instruction[12:10];
        imm = instruction[9:4];
      end
      default: begin
        rd = 4'd0;
        rs1 = 4'd0;
        rs2 = 4'd0;
        imm = 4'd0;
      end
    endcase
  end

endmodule

