`ifndef SP_PKG__
`define SP_PKG__

package sp_pkg;

  parameter int ADDR_WIDTH = 32;
  parameter int DATA_WIDTH = 32;

  parameter int NUM_REG = 8;
  parameter int REG_ADDR_WIDTH = $clog2(NUM_REG);

  parameter int ILEN = 16;
  parameter int XLEN = 32;

  typedef enum logic [3:0] {
    INVAL = 'b0000,
    ADDI  = 'b0001,
    ADD   = 'b0011,
    SUB   = 'b1011,
    AND   = 'b0101,
    OR    = 'b1101,
    XOR   = 'b1111,
    NOT   = 'b0111,
    LOAD  = 'b0010,
    STORE = 'b1010,
    SLL   = 'b0110,
    SLR   = 'b0100,
    SLLI  = 'b1110,
    SLRI  = 'b1100
  } func_t;

endpackage

`endif
