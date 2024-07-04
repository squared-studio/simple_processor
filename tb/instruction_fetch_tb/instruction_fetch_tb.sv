/*
Instruction fetch testbench for processor
Author : Shahid Uddin Ahmed (shahidshakib0@gmail.com)
*/

`include "sp_pkg.sv"
module instruction_fetch_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  import sp_pkg::*;

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic                         clk_i;
  logic                       arst_ni;
  logic                       valid_i;
  logic                    imem_ack_i;
  logic [DATA_WIDTH-1:0] imem_rdata_i;
  logic                    imem_req_o;
  logic [      ADDR_WIDTH-1:0] pc_out;
  logic [DATA_WIDTH-1:0]instruction_o;

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  //`CREATE_CLK(clk_i, 4ns, 6ns)

  //logic arst_ni = 1;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////
  
  int         pass;  // number of time results did matched
  int         fail;  // number of time results did not matched

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Instantiate the DUT
  instruction_fetch u_instruction_fetch (
    .clk_i(clk_i),
    .arst_ni(arst_ni),
    .valid_i(valid_i),
    .imem_ack_i(imem_ack_i),
    .imem_rdata_i(imem_rdata_i),
    .imem_req_o(imem_req_o),
    .pc_out(pc_out),
    .instruction_o(instruction_o)
  );

  //Driver Mailbox for Inputs
  mailbox #(logic) imem_ack_i_dvr_mbx  = new();
  mailbox #(logic [DATA_WIDTH-1:0]) imem_rdata_i_dvr_mbx  = new();
  
  //Monitor Mailbox For Inputs and Outputs
  mailbox #(logic) imem_ack_i_mon_mbx  = new();
  mailbox #(logic [DATA_WIDTH-1:0]) imem_rdata_i_mon_mbx  = new();
  mailbox #(logic) imem_req_o_mon_mbx  = new();
  mailbox #(logic [ADDR_WIDTH-1:0]) pc_out_mon_mbx  = new();
  mailbox #(logic [DATA_WIDTH-1:0]) instruction_o_mon_mbx  = new();

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static apply_reset();
    #100ns;
    clk_i        <= '0;
    arst_ni      <= '0;
    valid_i      <= '0;
    imem_ack_i   <= '0;
    imem_rdata_i <= '0;
    #100ns;
    arst_ni      <= 1;
    #100ns;
  endtask

  // Start toggling system clock forever every 5ns
  task static start_clk_i();
    fork
      forever begin
        clk_i <= '1;
        #5ns;
        clk_i <= '0;
        #5ns;
      end
   join_none
  endtask

  // Driver, monitor and scoreboard representation
  task static driver_monitor_scoreboard();
    fork
      forever begin // in driver
        
          logic data_imem_ack_i; 
          logic [DATA_WIDTH-1:0] data_imem_rdata_i;   
          
          imem_ack_i <= data_imem_ack_i; 
          imem_rdata_i <= data_imem_rdata_i; 
         
          imem_ack_i_dvr_mbx.get(imem_ack_i);
          imem_rdata_i_dvr_mbx.get(imem_rdata_i);
         
          @(posedge clk_i);
      end

      forever begin // in monitor
          @ (posedge clk_i);
          imem_ack_i_mon_mbx.put(imem_ack_i);
          imem_rdata_i_mon_mbx.put(imem_rdata_i);
         
      end

      forever begin // out monitor
          @ (posedge clk_i);
          imem_req_o_mon_mbx.put(imem_req_o);
          pc_out_mon_mbx.put(pc_out);
          instruction_o_mon_mbx.put(instruction_o);
      end

      forever begin // Scoreboard start

        logic                    dut_imem_ack_i;
        logic [DATA_WIDTH-1:0] dut_imem_rdata_i;
        logic                    dut_imem_req_o;
        logic [      ADDR_WIDTH-1:0] dut_pc_out;
        logic [DATA_WIDTH-1:0]dut_instruction_o;

        logic                    expected_imem_ack_i;
        logic [DATA_WIDTH-1:0] expected_imem_rdata_i;
        logic                    expected_imem_req_o;
        logic [      ADDR_WIDTH-1:0] expected_pc_out;
        logic [DATA_WIDTH-1:0]expected_instruction_o;

        imem_ack_i_mon_mbx.get(dut_imem_ack_i);
        imem_rdata_i_mon_mbx.get(dut_imem_rdata_i);
        imem_req_o_mon_mbx.get(dut_imem_req_o);
        pc_out_mon_mbx.get(dut_pc_out);
        instruction_o_mon_mbx.get(dut_instruction_o);
       
        @(posedge clk_i or negedge arst_ni) begin
          if(arst_ni==0) expected_pc_out <= '0;
          else if (valid_i==1) expected_pc_out <= expected_pc_out+2;
        end

        assign expected_imem_req_o = 1;
        assign expected_instruction_o = (expected_imem_ack_i)?expected_imem_rdata_i:'0;
       
        if (expected_instruction_o === dut_instruction_o) pass++;
        else fail++;
      
      end// Scoreboard end
     
    join_none

  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin  // main initial
    // Dump VCD file for manual checking
    $dumpfile("dump.vcd");
    $dumpvars;
    // Start clock
    start_clk_i();
    // Apply reset
    apply_reset();
    // Start all the verification components
    driver_monitor_scoreboard();
    // generate random data inputs
    @(posedge clk_i);
    repeat (100) begin 
       valid_i <= $urandom;
       imem_ack_i_dvr_mbx.put($urandom);
       imem_rdata_i_dvr_mbx.put($urandom);
    end
    //Delay
    repeat (150) @(posedge clk_i);
    // print results
    $display("%0d/%0d PASSED", pass, pass+fail);
    // End simulation
    $finish;
  end

endmodule
