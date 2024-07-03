`include "sp_pkg.sv"
module shift
  import sp_pkg::*;
(
    input logic  [2:0] rs1_data_i,
    input logic  [5:0] data2,
    input func_t       opcode,

    output logic [2:0] rd_data_o
);
  always_comb begin
    case ({
      opcode
    })
      SLL: rd_data_o = rs1_data_i >> data2[2:0];
      SLR: rd_data_o = rs1_data_i << data2[2:0];
      SLLI: rd_data_o = rs1_data_i >> data2;
      SLRI: rd_data_o = rs1_data_i << data2;
      default: rd_data_o = '0;
    endcase
  end
endmodule
