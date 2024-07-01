module instruction_fetch #(
  parameter int MEM_ADDR_WIDTH = 32,
  parameter int  MEM_DATA_WIDTH = 32
  )(
  input logic imem_ack_i,
  input logic pc_out_i
  input logic [MEM_DATA_WIDTH-1:0] imem_rdata_i,
  output logic imem_req_o,
  output logic [MEM_ADDR_WIDTH-1:0] pc_out_o,
  output logic [MEM_DATA_WIDTH-1:0] instruction_o
  );

  always @ (imem_ack_i,pc_out_i) begin
    if (imem_ack_i) begin
      instruction_o <= imem_rdata_i;
      imem_req_o <= 0;
      pc_out_o <= pc_out_i;
    end else begin
      imem_req_o <= 1;
    end
  end

endmodule
