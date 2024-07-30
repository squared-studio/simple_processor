/*
Instruction fetch for processor
Author : Md Abdullah Al Samad (mdsam.raian@gmail.com)
*/

`include "sp_pkg.sv"
module instruction_fetch
  import sp_pkg::*;
(
  input clk_i,
  input arst_ni,

  input valid_i,
  input logic imem_ack_i,

  input logic [DATA_WIDTH-1:0] imem_rdata_i,
  output logic imem_req_o,
  output logic [ADDR_WIDTH-1:0] pc_out,
  output logic [DATA_WIDTH-1:0] instruction_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURAL
  //////////////////////////////////////////////////////////////////////////////////////////////////
  always_ff @(posedge clk_i or negedge arst_ni) begin
  if(arst_ni==0) pc_out <= '0;
  else if (valid_i==1) pc_out <= pc_out+2;
  end
  
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  assign imem_req_o = 1;
  assign instruction_o = (imem_ack_i)?imem_rdata_i:'0;

endmodule
