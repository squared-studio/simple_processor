`include "sp_pkg.sv"
module reg_file 
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

    logic [XLEN-1:0] regfile [0:NUM_REG-1]; // 8 registers, each 32 bits wide
    assign regfile[0] = '0;                  // 1st register always zero

    // Read operations
    assign rs1_data_o = regfile[rs1_addr_i];
    assign rs2_data_o = regfile[rs2_addr_i];

    // Write operation
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
    
    

endmodule
