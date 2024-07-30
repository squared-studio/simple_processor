/*
Write a markdown documentation for this systemverilog module:
Author : Md Abdullah Al Samad (mdsam.raian@gmail.com)
*/

`include "sp_pkg.sv"

// Module for basic logic gates operations
module logic_gates 
  import sp_pkg::*;  // Import the package if necessary
(
  input logic [DATA_WIDTH-1:0] rs1_data_i,  // Input data 1
  input logic [DATA_WIDTH-1:0] rs2_data_i,  // Input data 2
  input func_t opcode_i,                    // Operation code
  output logic [DATA_WIDTH-1:0] logic_out_o // Output data
);

  // Always block for combinational logic based on opcode_i
  always_comb begin
    case(opcode_i)
      4'b0101: logic_out_o = rs1_data_i & rs2_data_i; // AND operation
      4'b1101: logic_out_o = rs1_data_i | rs2_data_i; // OR operation
      4'b1111: logic_out_o = rs1_data_i ^ rs2_data_i; // XOR operation
      4'b0111: logic_out_o = ~rs1_data_i;             // NOT operation (only uses rs1_data_i)
      default: logic_out_o = 'bz;                     // High impedance state for unhandled cases
    endcase
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (DATA_WIDTH > 32) begin
      $display("\033[1;33mWarning: DATA_WIDTH exceeds 32 bits. Simulation may not accurately reflect hardware behavior.\033[0m");
    end
  end
`endif  // SIMULATION

endmodule