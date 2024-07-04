/*
Write a markdown documentation for this systemverilog module:
Author : Md Abdullah Al Samad (mdsam.raian@gmail.com)
*/

`include "sp_pkg.sv"
module register_file 
  import sp_pkg::*;
(
  input  logic clk_i,                            // Global clock 
  input  logic arst_ni,                          // asynchronous active low reset
  input  logic [REG_ADDR_WIDTH-1:0] rd_addr_i,   // address for destination register
  input  logic [          XLEN-1:0] rd_data_i,   // data for destination register
  input  logic             rd_en_i,              // destination register enable
  input  logic [REG_ADDR_WIDTH-1:0] rs1_addr_i,  //  data address for rs1
  output logic [          XLEN-1:0] rs1_data_o,  //  read data for rs1
  input  logic  [REG_ADDR_WIDTH-1:0] rs2_addr_i, //  data address for rs2
  output logic  [          XLEN-1:0] rs2_data_o  //  read data for rs2
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  logic [XLEN-1:0] regfile [0:NUM_REG-1]; // 8 registers, each 32 bits wide
  
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Read operations
  assign regfile[0] = '0;                  // 1st register always zero
  assign rs1_data_o = regfile[rs1_addr_i];
  assign rs2_data_o = regfile[rs2_addr_i];

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //-Write operation
  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (arst_ni == 0) begin
    // Zero out the entire register file
      for (int i = 1; i < NUM_REG; i++) begin
        regfile[i] <= '0;
      end
    end else if (rd_en_i) begin
      regfile[rd_addr_i] <= rd_data_i;
    end
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
