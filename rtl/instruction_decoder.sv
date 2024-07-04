/*
This module separates out the different register address and function to execute with them
Author : Shahid Uddin Ahmed (shahidshakib0@gmail.com)
*/

`include "sp_pkg.sv"

module instruction_decoder
  import sp_pkg::*;
(
    // INPUT INSTRUCTUIN CODE, ILEN = 16 BIT
    input logic [ILEN-1:0] code_i,

    // VALID, 0 OR 1
    output logic                       func_valid_o,
    // OPPCODE, ENUM TYPEDEF
    output func_t                      func_o,
    // DESTINATION REGISTER, REG_ADD_WIDTH = 3 BIT
    output logic  [REG_ADDR_WIDTH-1:0] rd_o,
    // SOURCE REGISTER 1
    output logic  [REG_ADDR_WIDTH-1:0] rs1_o,
    // SOURCE REGISTER 2
    output logic  [REG_ADDR_WIDTH-1:0] rs2_o,
    // IMMEDIATE VALUE, XLEN = 32 BIT
    output logic  [          XLEN-1:0] imm_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Address bit 13 to 15 for destination register
  assign rd_o = code_i[15:13];

  // Address bit 10 to 12 for source register 1
  assign rs1_o = code_i[12:10];

  // Address bit 7 to 9 for source register 2
  assign rs2_o = code_i[9:7];

  // Address bit 4 to 9 for immediate value
  assign imm_o[5:0] = code_i[9:4];

  // Remain 26 bit will be filled with the MSB of immediate value
  assign imm_o[31:6] = code_i[9] ? '1 : '0;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // deciding the func_o and func_valid_o
  always_comb begin
    case (code_i[3:0])

      //VALID = 0 FOR DEFAULT VALUE OR INVALID VALUE
      default: begin
        func_o = INVAL;
        func_valid_o = '0;
      end

      //RD = RS1 + IMM
      'b0001: begin
        func_o = ADDI;
        func_valid_o = '1;
      end

      //RD = RS1 + RS2
      'b0011: begin
        func_o = ADD;
        func_valid_o = '1;
      end

      //RD = RS1 - RS2
      'b1011: begin
        func_o = SUB;
        func_valid_o = '1;
      end

      //RD = RS1 & RS2
      'b0101: begin
        func_o = AND;
        func_valid_o = '1;
      end

      //RD = RS1 | RS2
      'b1101: begin
        func_o = OR   ;
        func_valid_o = '1;
      end

      //RD = RS1 ^ RS2
      'b1111: begin
        func_o = XOR;
        func_valid_o = '1;
      end

      //RD = ~RS1
      'b0111: begin
        func_o = NOT;
        func_valid_o = '1;
      end

      //RD = mem[RS1]
      'b0010: begin
        func_o = LOAD;
        func_valid_o = '1;
      end

      //mem[RS1] = RS2
      'b1010: begin
        func_o = STORE;
        func_valid_o = '1;
      end

      //RD = RS1 >> RS2
      'b0110: begin
        func_o = SLL;
        func_valid_o = '1;
      end

      //RD = RS1 << RS2
      'b0100: begin
        func_o = SLR;
        func_valid_o = '1;
      end

      //RD = RS1 >> IMM
      'b1110: begin
        func_o = SLLI;
        func_valid_o = '1;
      end

      //RD = RS1 << IMM
      'b1100: begin
        func_o = SLRI;
        func_valid_o = '1;
      end
    endcase
  end

endmodule
