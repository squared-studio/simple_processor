/*
Testbench of register file for the processor  
Author : Shahid Uddin Ahmed (shahidshakib0@gmail.com)
*/

`include "sp_pkg.sv"
module register_file_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  import sp_pkg::*;

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  
  // localparam int ADDR_WIDTH = 32;
  // localparam int DATA_WIDTH = 32;
  // localparam int NUM_REG = 8;
  // localparam int REG_ADDR_WIDTH = $clog2(NUM_REG);
  // localparam int ILEN = 16;
  // localparam int XLEN = 32;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////
  logic                      clk_i;       // global clock
  logic                      arst_ni;     // asynchronous active low reset
  logic [REG_ADDR_WIDTH-1:0] rd_addr_i;   // address for destination register
  logic [          XLEN-1:0] rd_data_i;   // data for destination register
  logic                      rd_en_i;     // destination register enable
  logic [REG_ADDR_WIDTH-1:0] rs1_addr_i;  // data address for rs1
  logic [          XLEN-1:0] rs1_data_o;  // read data for rs1, output pin
  logic [REG_ADDR_WIDTH-1:0] rs2_addr_i;  // data address for rs2
  logic [          XLEN-1:0] rs2_data_o;  // read data for rs2, output pin
  
  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  //`CREATE_CLK(clk_i, 4ns, 6ns)
  //logic arst_ni = 1;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////
  int         pass;  // number of time results did matched
  int         fail;  // number of time results did not matched
  logic [XLEN-1:0] regfile[NUM_REG];  // 8 registers, each 32 bits wide
  
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS 
  //////////////////////////////////////////////////////////////////////////////////////////////////
  register_file u_register_file (
    .clk_i(clk_i),
    .arst_ni(arst_ni),
    .rd_addr_i(rd_addr_i),
    .rd_data_i(rd_data_i),
    .rd_en_i(rd_en_i),
    .rs1_addr_i(rs1_addr_i),
    .rs1_data_o(rs1_data_o),
    .rs2_addr_i(rs2_addr_i),
    .rs2_data_o(rs2_data_o)
  );

  // #(
  //   .XLEN(XLEN),
  //   .REG_ADDR_WIDTH(REG_ADDR_WIDTH),
  //   .NUM_REG(NUM_REG)
  // )

  //Driver Mailbox for Inputs
  mailbox #(logic [ REG_ADDR_WIDTH-1:0]) rd_addr_i_dvr_mbx  = new();
  mailbox #(logic [           XLEN-1:0]) rd_data_i_dvr_mbx  = new();
  mailbox #(logic [REG_ADDR_WIDTH-1:0]) rs1_addr_i_dvr_mbx  = new();
  mailbox #(logic [REG_ADDR_WIDTH-1:0]) rs2_addr_i_dvr_mbx  = new();
  
  //Monitor Mailbox For Inputs and Outputs
  mailbox #(logic [ REG_ADDR_WIDTH-1:0]) rd_addr_i_mon_mbx  = new();
  mailbox #(logic [           XLEN-1:0]) rd_data_i_mon_mbx  = new();
  mailbox #(logic [REG_ADDR_WIDTH-1:0]) rs1_addr_i_mon_mbx  = new();
  mailbox #(logic [REG_ADDR_WIDTH-1:0]) rs2_addr_i_mon_mbx  = new();
  mailbox #(logic [          XLEN-1:0]) rs1_data_o_mon_mbx  = new();
  mailbox #(logic [          XLEN-1:0]) rs2_data_o_mon_mbx  = new();
  
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Apply system reset and initialize all inputs
  task static apply_reset();
    #100ns;
    clk_i      <= '0;
    arst_ni    <= '0;
    rd_addr_i  <= '0;
    rd_data_i  <= '0;
    rd_en_i    <= '0;
    rs1_addr_i <= '0;
    rs2_addr_i <= '0;
    #100ns;
    arst_ni    <= '1;
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
        
          logic [REG_ADDR_WIDTH-1:0] data_rd_addr_i; 
          logic [          XLEN-1:0] data_rd_data_i;   
          logic [REG_ADDR_WIDTH-1:0] data_rs1_addr_i;
          logic [REG_ADDR_WIDTH-1:0] data_rs2_addr_i;
          
          rd_addr_i <= data_rd_addr_i; 
          rd_data_i <= data_rd_data_i; 
          rs1_addr_i <= data_rs1_addr_i;
          rs2_addr_i <= data_rs2_addr_i;

          rd_addr_i_dvr_mbx.get(rd_addr_i);
          rd_data_i_dvr_mbx.get(rd_data_i);
          rs1_addr_i_dvr_mbx.get(rs1_addr_i);
          rs2_addr_i_dvr_mbx.get(rs2_addr_i);
        
          @(posedge clk_i);
      end

      forever begin // in monitor
          @ (posedge clk_i);
          rd_addr_i_mon_mbx.put(rd_addr_i);
          rd_data_i_mon_mbx.put(rd_data_i);
          rs1_addr_i_mon_mbx.put(rs1_addr_i);
          rs2_addr_i_mon_mbx.put(rs2_addr_i);
      end

      forever begin // out monitor
          @ (posedge clk_i);
          rs1_data_o_mon_mbx.put(rs1_data_o);
          rs2_data_o_mon_mbx.put(rs2_data_o);
      end

      forever begin // Scoreboard start
        logic [REG_ADDR_WIDTH-1:0] dut_rd_addr_i; 
        logic [          XLEN-1:0] dut_rd_data_i;    
        logic [REG_ADDR_WIDTH-1:0] dut_rs1_addr_i;
        logic [          XLEN-1:0] dut_rs1_data_o;
        logic [REG_ADDR_WIDTH-1:0] dut_rs2_addr_i;
        logic [          XLEN-1:0] dut_rs2_data_o;

        logic [REG_ADDR_WIDTH-1:0] expected_rd_addr_i; 
        logic [          XLEN-1:0] expected_rd_data_i;    
        logic [REG_ADDR_WIDTH-1:0] expected_rs1_addr_i;
        logic [          XLEN-1:0] expected_rs1_data_o;
        logic [REG_ADDR_WIDTH-1:0] expected_rs2_addr_i;
        logic [          XLEN-1:0] expected_rs2_data_o;

        rd_addr_i_mon_mbx.get(dut_rd_addr_i);
        rd_data_i_mon_mbx.get(dut_rd_data_i);
        rs1_addr_i_mon_mbx.get(dut_rs1_addr_i);
        rs2_addr_i_mon_mbx.get(dut_rs2_addr_i);
        rs1_data_o_mon_mbx.get(dut_rs1_data_o);
        rs2_data_o_mon_mbx.get(dut_rs2_data_o);

        assign expected_rs1_data_o = regfile[expected_rs1_addr_i];
        assign expected_rs2_data_o = regfile[expected_rs2_addr_i];
        for (int i = 0; i < NUM_REG; i++) begin
          if (expected_rs1_data_o[i] === dut_rs1_data_o[i] && expected_rs2_data_o[i] === dut_rs2_data_o[i]) pass++;
          else fail++;
        end
      end
      //   @(posedge clk_i);
      //   for (int i = 0; i < NUM_REG; i++) begin
      //     if (rs1_data_o[i] == regfile[rs1_addr_i[i]] && rs2_data_o[i] == regfile[rs2_addr_i[i]] ) begin
      //       pass++;
      //     end else begin
      //       fail++;
      //     end
      //   end
      //   if (rd_en_i && (rd_addr_i != '0)) begin
      //     regfile[rd_addr_i] = rd_data_i;
      //   end
      // end // Scoreboard end
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
       rd_en_i <= $urandom;
       rd_addr_i_dvr_mbx.put($urandom);
       rd_data_i_dvr_mbx.put($urandom);
       rs1_addr_i_dvr_mbx.put($urandom);
       rs2_addr_i_dvr_mbx.put($urandom);

    end
    //Delay
    repeat (150) @(posedge clk_i);
    // print results
    $display("%0d/%0d PASSED", pass, pass+fail);
    // End simulation
    $finish;
  end

endmodule
