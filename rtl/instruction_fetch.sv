/*
Write a markdown documentation for this systemverilog module:
Author : Md Abdullah Al Samad (mdsam.raian@gmail.com)
*/

`include "sp_pkg.sv"
module instruction_fetch
  import sp_pkg::*;
(
  input  logic clk_i,
  input  logic arst_ni,

  input  logic valid_i,
  input  logic [ADDR_WIDTH-1:0] boot_addr_i,
  input  logic imem_ack_i,

  input  logic [DATA_WIDTH-1:0] imem_rdata_i,
  output logic imem_req_o,
  output logic [ADDR_WIDTH-1:0] pc_out,
  output logic [DATA_WIDTH-1:0] instruction_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  assign imem_req_o = 1;
  assign instruction_o = (imem_ack_i)?imem_rdata_i:'0;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURAL
  //////////////////////////////////////////////////////////////////////////////////////////////////
  always_ff @(posedge clk_i or negedge arst_ni) begin
    if(arst_ni==0) pc_out <= '0;
    else if (valid_i==1) pc_out <= pc_out+2;
    else pc_out <= boot_addr_i;
  end

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
