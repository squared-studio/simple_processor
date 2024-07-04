/*
Description
Author : Md Abdullah Al Samad (mdsam.raian@gmail.com)
*/
 `include "sp_pkg.sv"
module instruction_decoder_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"
  import sp_pkg::*;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  typedef struct packed {
    logic func_valid_o;                // valid output data
    func_t func_o;                     // opcode output data
    logic [REG_ADDR_WIDTH-1:0] rd_o;   // destination reg output
    logic [REG_ADDR_WIDTH-1:0] rs1_o;  // rs1 data out
    logic [REG_ADDR_WIDTH-1:0] rs2_o;  // rs2 data out
    logic [          XLEN-1:0] imm_o;  // immediate value
  } output_t;
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i, 4ns, 6ns)

  logic arst_ni = 1;        // ASYNCHRONOUS ACTIVE LOW RESET
  logic  [ILEN-1:0] code_i; // ILEN = 16
  output_t outs;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////
  int pass;
  int fail;

  //Driver Mailbox
  mailbox #(logic  [ILEN-1:0]) dvr_instr_mbx  = new();

  //Monitor Mailbox For I/O
  mailbox #(logic  [ILEN-1:0]) mon_instr_mbx  = new();
  mailbox #(output_t) mon_out_mbx    = new();

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  instruction_decoder u_ins_dec(
    .code_i(code_i),
    .func_valid_o(outs.func_valid_o),
    .func_o(outs.func_o),
    .rd_o(outs.rd_o),
    .rs1_o(outs.rs1_o),
    .rs2_o(outs.rs2_o),
    .imm_o(outs.imm_o)
  );
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  task static apply_reset();
    #100ns;
    arst_ni <= 0;
    #100ns;
    arst_ni <= 1;
    #100ns;
  endtask
  //Driver, Monitor and Scoreboard
  task static driver_monitor_scoreboard();
    fork
      forever begin // in driver
        logic [ILEN-1:0] ins;
        dvr_instr_mbx.get(ins);
        code_i <= ins;
        @(posedge clk_i);
      end

      forever begin // in monitor
        @(posedge clk_i);
         mon_instr_mbx.put(code_i);
      end

      forever begin // out monitor
        @ (posedge clk_i);
        mon_out_mbx.put(outs);
      end

      ////////////Scoreboard//////////////

      forever begin
        logic [ILEN-1:0] instruction;
        output_t   ins_out;

        mon_instr_mbx.get(instruction);
        mon_out_mbx.get(ins_out);

        $display("inputs: %b",instruction);
        $display("Output: %p",ins_out);

        // if(instruction[3:0] ==0001) begin
        //   if(ins_out.func_o == ADDI && ins_out.func_valid_o ==1) begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if(instruction[3:0] ==0011) begin
        //   if(ins_out.func_o == ADD && ins_out.func_valid_o ==1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if(instruction[3:0]==1011) begin
        //   if(ins_out.func_o == SUB && ins_out.func_valid_o ==1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // if(instruction[3:0]==0101) begin
        //   if(ins_out.func_o == AND && ins_out.func_valid_o ==1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if(instruction[3:0]==1101) begin
        //   if(ins_out.func_o == OR && ins_out.func_valid_o ==1) begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if(instruction[3:0]==1111) begin
        //   if(ins_out.func_o == XOR && ins_out.func_valid_o ==1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // if(instruction[3:0]==0111) begin
        //   if(ins_out.func_o == NOT && ins_out.func_valid_o ==1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if(instruction[3:0]==0010) begin
        //   if(ins_out.func_o==LOAD && ins_out.func_valid_o ==1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if(instruction[3:0]==1010) begin
        //   if(ins_out.func_o==STORE && ins_out.func_valid_o ==1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if(instruction[3:0]==0110) begin
        //   if(ins_out.func_o==SLL && ins_out.func_valid_o ==1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // if(instruction[3:0]==0100) begin
        //   if(ins_out.func_o== SLR && ins_out.func_valid_o ==1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if(instruction[3:0]==1110) begin
        //   if(ins_out.func_o==SLLI && ins_out.func_valid_o =='1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if(instruction[3:0]== 1100) begin
        //   if(ins_out.func_o==SLRI && ins_out.func_valid_o =='1)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end
        // else if (instruction[3:0]== 0000||1000||1001) begin
        //   if(ins_out.func_o==INVAL && ins_out.func_valid_o =='0)  begin
        //     $display("........................**********");
        //     pass++;
        //   end
        //   else fail++;
        // end

        case(instruction[3:0])
          0001:
            if((ins_out.func_o === ADDI) && (ins_out.func_valid_o === '1)) begin
              $display(".............pass...........**********");
              pass++;
            end
            else fail++;
          0011:
            if((ins_out.func_o === ADD) && (ins_out.func_valid_o === '1)) begin
              $display("............pass............**********");
              pass++;
            end
            else fail++;
          1011:
            if((ins_out.func_o === SUB) && (ins_out.func_valid_o === '1)) begin
              $display(".............pass...........**********");
              pass++;
            end
            else fail++;
          0101:
            if((ins_out.func_o === AND) && (ins_out.func_valid_o === '1))  begin
              $display(".............pass...........**********");
              pass++;
            end
          else fail++;
          1101:
            if(ins_out.func_o === OR && ins_out.func_valid_o === '1) begin
              $display("............pass............**********");
              pass++;
            end
            else fail++;
          1111:
            if(ins_out.func_o === XOR && ins_out.func_valid_o === '1)  begin
              $display(".............pass...........**********");
              pass++;
            end
            else fail++;
          0111:
            if(ins_out.func_o === NOT && ins_out.func_valid_o === '1)  begin
              $display(".............pass...........**********");
              pass++;
            end
            else fail++;
          0010:
            if(ins_out.func_o === LOAD && ins_out.func_valid_o === '1)  begin
              $display(".............pass...........**********");
              pass++;
            end
            else fail++;
          1010:
            if(ins_out.func_o === STORE && ins_out.func_valid_o === '1)  begin
              $display("............pass............**********");
              pass++;
            end
            else fail++;
          0110:
            if(ins_out.func_o ===SLL && ins_out.func_valid_o === '1)  begin
              $display("............pass............**********");
              pass++;
            end
            else fail++;
          0100:
            if(ins_out.func_o === SLR && ins_out.func_valid_o === '1)  begin
              $display(".............pass...........**********");
              pass++;
            end
            else fail++;
          1110:
            if(ins_out.func_o === SLLI && ins_out.func_valid_o === '1)  begin
              $display(".............pass...........**********");
              pass++;
            end
            else fail++;
          1100:
            if(ins_out.func_o === SLRI && ins_out.func_valid_o === '1)  begin
              $display("..............pass..........**********");
              pass++;
            end
            else fail++;
          default:
            if(ins_out.func_o === INVAL && ins_out.func_valid_o === '0)  begin
              $display("..............pass..........**********");
              pass++;
            end
          else fail++;
        endcase
      end
    join_none
  endtask

  ///////////////End Scoreboard////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin  // main initial

    start_clk_i();
    apply_reset();
    driver_monitor_scoreboard();

    @(posedge clk_i);
    repeat(100) begin
      dvr_instr_mbx.put($urandom);
    end

    repeat(100) @(posedge clk_i);
    $display("%0d/%0d PASSED", pass, pass + fail);

    @(posedge clk_i);
    result_print(1, "This is a PASS");
    @(posedge clk_i);
    result_print(0, "And this is a FAIL");

    $finish;

  end

endmodule
