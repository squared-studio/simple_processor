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
|clk_i|input|logic||global clock|
|arst_ni|input|logic||global asynchronous reset|
|valid_i|input|logic||valid|
|boot_addr_i|input|logic [ADDR_WIDTH-1:0]||boot_address if not valid|
|instruction_o|output|logic [ILEN-1:0]||instruction for ID|
|imem_req_o|output|logic||request for instruction data|
|imem_addr_o|output|logic [ADDR_WIDTH-1:0]||instruction memory address|
|imem_rdata_i|input|logic [ILEN-1:0]||data from instruction memory|
|imem_ack_i|input|logic||acknowledge from instruction memory|
