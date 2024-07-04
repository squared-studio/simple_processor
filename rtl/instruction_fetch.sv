/*
Write a markdown documentation for this systemverilog module:
Author : Md Abdullah Al Samad (mdsam.raian@gmail.com)
*/

`include "sp_pkg.sv"
module instruction_fetch
  import sp_pkg::*;
(
  input logic imem_ack_i,
  input logic [ADDR_WIDTH-1:0] pc_out_i,
  input logic [DATA_WIDTH-1:0] imem_rdata_i,
  output logic imem_req_o,
  output logic [ADDR_WIDTH-1:0] pc_out_o,
  output logic [DATA_WIDTH-1:0] instruction_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  assign imem_req_o = 1;
  assign pc_out_o = pc_out_i;
  assign instruction_o = (imem_ack_i)?imem_rdata_i:'0;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (DATA_WIDTH > 2) begin
      $display("\033[1;33m%m DATA_WIDTH\033[0m");
    end
  end
`endif  // SIMULATION

endmodule
