`include "sp_pkg.sv"
module instruction_decoder
  import sp_pkg::*;
(
    input  logic  [          ILEN-1:0] code_i,
    output logic                       func_valid_o,
    output func_t                      func_o,
    output logic  [REG_ADDR_WIDTH-1:0] rd_o,
    output logic  [REG_ADDR_WIDTH-1:0] rs1_o,
    output logic  [REG_ADDR_WIDTH-1:0] rs2_o,
    output logic  [          XLEN-1:0] imm_o
);

  assign rd_o = code_i[15:13];
  assign rs1_o = code_i[12:10];
  assign rs2_o = code_i[9:7];
  assign imm_o[5:0] = code_i[9:4];
  assign imm_o[31:6] = code_i[9] ? '1 : '0;

  always_comb begin
    case (code_i[3:0])
      default: begin func_o = INVAL; func_valid_o = '0; end
      'b0001:  begin func_o = ADDI ; func_valid_o = '1; end
      'b0011:  begin func_o = ADD  ; func_valid_o = '1; end
      'b1011:  begin func_o = SUB  ; func_valid_o = '1; end
      'b0101:  begin func_o = AND  ; func_valid_o = '1; end
      'b1101:  begin func_o = OR   ; func_valid_o = '1; end
      'b1111:  begin func_o = XOR  ; func_valid_o = '1; end
      'b0111:  begin func_o = NOT  ; func_valid_o = '1; end
      'b0010:  begin func_o = LOAD ; func_valid_o = '1; end
      'b1010:  begin func_o = STORE; func_valid_o = '1; end
      'b0110:  begin func_o = SLL  ; func_valid_o = '1; end
      'b0100:  begin func_o = SLR  ; func_valid_o = '1; end
      'b1110:  begin func_o = SLLI ; func_valid_o = '1; end
      'b1100:  begin func_o = SLRI ; func_valid_o = '1; end
    endcase
  end

endmodule
