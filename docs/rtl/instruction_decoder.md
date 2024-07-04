# instruction_decoder (module)

### Author : Shahid Uddin Ahmed (shahidshakib0@gmail.com)

## TOP IO
<img src="./instruction_decoder_top.svg">

## Description

This module separates out the different register address and function to execute with them

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|code_i|input|logic [ILEN-1:0]|| INPUT INSTRUCTUIN CODE, ILEN = 16 BIT|
|func_valid_o|output|logic|| VALID, 0 OR 1|
|func_o|output|func_t|| OPPCODE, ENUM TYPEDEF|
|rd_o|output|logic [REG_ADDR_WIDTH-1:0]|| DESTINATION REGISTER, REG_ADD_WIDTH = 3 BIT|
|rs1_o|output|logic [REG_ADDR_WIDTH-1:0]|| SOURCE REGISTER 1|
|rs2_o|output|logic [REG_ADDR_WIDTH-1:0]|| SOURCE REGISTER 2|
|imm_o|output|logic [ XLEN-1:0]|| IMMEDIATE VALUE, XLEN = 32 BIT|
