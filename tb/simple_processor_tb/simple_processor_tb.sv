/*
Description
Author : Foez Ahmed (foez.official@gmail.com)
*/

`include "vip/model_pkg.sv"

module simple_processor_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  // Write a byte in model's internal memory
  // void model_write(int addr, byte data);
  import model_pkg::model_write;

  // Read a byte from model's internal memory
  // byte model_read(int addr);
  import model_pkg::model_read;

  // Load a hex file in model's internal memory
  // void model_load(input string file);
  import model_pkg::model_load;

  // Set model's program counter
  // void model_set_PC(int addr);
  import model_pkg::model_set_PC;

  // Get model's program counter
  // int model_get_PC();
  import model_pkg::model_get_PC;

  // Set model's internal register's content
  // void model_set_GPR(byte addr, int data);
  import model_pkg::model_set_GPR;

  // Get model's internal register content
  // int model_get_GPR(byte addr);
  import model_pkg::model_get_GPR;

  // Disassemble instruction
  // void model_dis_asm(int instr);
  import model_pkg::model_dis_asm;

  // check if the last operation was a DMEM operation
  // bit model_is_dmem_op();
  import model_pkg::model_is_dmem_op;

  // check if the last DMEM operation had write enabled
  // bit model_is_dmem_we();
  import model_pkg::model_is_dmem_we;

  // get last DMEM operation's address
  // int model_dmem_addr();
  import model_pkg::model_dmem_addr;

  // get last DMEM operation's data
  // int model_dmem_data();
  import model_pkg::model_dmem_data;

  // execute one instruction and increase program counter by 2
  // void model_step();
  import model_pkg::model_step;

  import sp_pkg::ADDR_WIDTH;
  import sp_pkg::DATA_WIDTH;
  import sp_pkg::NUM_REG;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i, 4ns, 6ns)

  logic                  arst_ni = 1;
  logic [ADDR_WIDTH-1:0] boot_addr_i = '0;

  logic                  imem_req_o;
  logic [ADDR_WIDTH-1:0] imem_addr_o;
  logic [DATA_WIDTH-1:0] imem_rdata_i;
  logic                  imem_ack_i;

  logic                  dmem_req_o;
  logic                  dmem_wr_o;
  logic [ADDR_WIDTH-1:0] dmem_addr_o;
  logic [DATA_WIDTH-1:0] dmem_wdata_o;
  logic [DATA_WIDTH-1:0] dmem_rdata_i;
  logic                  dmem_ack_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  int                    pass;
  int                    fail;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INTERFACES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-CLASSES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // TODO: Add delay
  assign imem_ack_i = imem_req_o;
  assign dmem_ack_i = dmem_req_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // DUT
  simple_processor core (
      .clk_i,
      .arst_ni,
      .boot_addr_i,
      .imem_req_o,
      .imem_addr_o,
      .imem_rdata_i,
      .imem_ack_i,
      .dmem_req_o,
      .dmem_wr_o,
      .dmem_addr_o,
      .dmem_wdata_o,
      .dmem_rdata_i,
      .dmem_ack_i
  );

  // Model to act as main memory
  r2_w1_32b_memory_model mMEM (
      .clk_i,
      .we_i(dmem_wr_o),
      .w_addr_i(dmem_addr_o),
      .w_data_i(dmem_wdata_o),
      .r0_addr_i(dmem_addr_o),
      .r0_data_o(dmem_rdata_i),
      .r1_addr_i(imem_addr_o),
      .r1_data_o(imem_rdata_i)
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

  task static start_checking();
    fork
      forever begin
        bit OK;
        OK = 1;
        @(posedge clk_i or negedge arst_ni);
        if (arst_ni === 0) begin
          model_set_PC(boot_addr_i);
          for (int i = 0; i < NUM_REG; i++) begin
            model_set_GPR(i, 0);
          end
        end else if (arst_ni === 1) begin
          model_step();
          // TODO TO CHECK
          // - REGFILE
          // - DMEM
          // - PC
          if (OK) pass++;
          else begin
            $fatal(1, "RTL - Model Deviated");
            fail++;
          end
        end
      end
    join_none
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin  // main initial

    mMEM.clear();

    boot_addr_i <= 'h1000;

    model_load("all_test.hex");
    mMEM.load("all_test.hex");

    start_checking();

    apply_reset();

    start_clk_i();

    repeat (20) @(posedge clk_i);

    // C model is an separetely running program causing
    // race condition with printf & $display
    #100ns;

    result_print(!fail, "MODEL ONLY");

    $finish;

  end

endmodule
