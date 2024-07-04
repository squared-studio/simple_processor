# instruction_fetch (module)

### Author : Md Abdullah Al Samad (mdsam.raian@gmail.com)

## TOP IO
<img src="./instruction_fetch_top.svg">

## Description

Write a markdown documentation for this systemverilog module:

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|imem_ack_i|input|logic|||
|pc_out_i|input|logic [ADDR_WIDTH-1:0]|||
|imem_rdata_i|input|logic [DATA_WIDTH-1:0]|||
|imem_req_o|output|logic|||
|pc_out_o|output|logic [ADDR_WIDTH-1:0]|||
|instruction_o|output|logic [DATA_WIDTH-1:0]|||
