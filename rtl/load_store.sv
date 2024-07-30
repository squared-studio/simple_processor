/*
Write a markdown documentation for this systemverilog module:
Author : Md Abdullah Al Samad (mdsam.raian@gmail.com)
*/

`include "sp_pkg.sv"

module load_store 
  import sp_pkg::*;  // Import everything from the package specified

(
  input logic clk_i,                      // Clock input
  input logic arst_ni,                    // Asynchronous reset, active low
  input logic [DATA_WIDTH-1:0] rs1_addr_i,// Address input from register source 1
  input logic [DATA_WIDTH-1:0] rs2_data_i,// Data input from register source 2
  input func_t opcode_i,                  // Opcode input to specify load or store operation

  output logic dmem_req_o,                // Data memory request signal
  output logic dmem_wr_o,                 // Data memory write enable signal
  output logic [ADDR_WIDTH-1:0] dmem_addr_o, // Data memory address output
  output logic [DATA_WIDTH-1:0] dmem_wdata_o, // Data memory write data output

  input logic [DATA_WIDTH-1:0] dmem_rdata_i, // Data memory read data input
  input logic dmem_ack_i,                 // Data memory acknowledgment signal
  
  output logic [DATA_WIDTH-1:0] rd_reg_o  // Data output to register destination
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  always_ff @(posedge clk_i or negedge arst_ni) begin : load_store
    if (!arst_ni) begin
      dmem_req_o <= 0;
      dmem_wr_o <= 0;
      dmem_addr_o <= 'z;
      dmem_wdata_o <= 0;
      rd_reg_o <= 0;
    end else begin
      case(opcode_i)
        4'b0010: begin // Load operation
          dmem_req_o <= 1;
          dmem_wr_o <= 0;
          dmem_addr_o <= rs1_addr_i;
          if(dmem_ack_i) rd_reg_o <= dmem_rdata_i;
        end
        4'b1010: begin // Store operation
          dmem_req_o <= 1;
          dmem_wr_o <= 1;
          dmem_addr_o <= rs1_addr_i;
          dmem_wdata_o <= rs2_data_i;
        end
        default: begin
          dmem_req_o <= 0;
          dmem_wr_o <= 0;
          dmem_addr_o <= 'z;
          dmem_wdata_o <= 0;
        end
      endcase
    end
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
  //////////////////////////////////////////////////////////////////////////////////////////////////
`ifdef SIMULATION
  initial begin
    if (DATA_WIDTH > 2) begin
      $display("\033[1;33m%m DATA_WIDTH exceeds recommended size: %0d\033[0m", DATA_WIDTH);
    end
  end
`endif  // SIMULATION

endmodule
