module instruction_memory #(
  parameter int MEM_ADDR_WIDTH = 32,
  parameter int MEM_DATA_WIDTH = 32
)
(
  input [MEM_ADDR_WIDTH-1:0] address,
  output reg [MEM_DATA_WIDTH-1:0] instruction
);

  reg [31:0] memory [0:4294967296-1];

  initial begin
    // Load instructions into memory
    memory[0]  = 16'b0001_0001_0000_0001; // ADDI
    memory[1]  = 16'b0011_0001_0010_0011; // ADD
    memory[2]  = 16'b0011_0001_0010_1011; // SUB
    memory[3]  = 16'b0011_0001_0010_0101; // AND
    memory[4]  = 16'b0011_0001_0010_1101; // OR
    memory[5]  = 16'b0011_0001_0010_1111; // XOR
    memory[6]  = 16'b0011_0001_0010_0111; // NOT
    memory[7]  = 16'b0011_0001_0010_0010; // LOAD
    memory[8]  = 16'b0011_0001_0010_1010; // STORE
    memory[9]  = 16'b0011_0001_0010_0110; // SLL
    memory[10] = 16'b0011_0001_0010_0100; // SLR
    memory[11] = 16'b0011_0001_0010_1110; // SLLI
    memory[12] = 16'b0011_0001_0010_1100; // SLRI    
  end

  always @(address) begin
    instruction = memory[address];
  end
endmodule

