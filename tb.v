`define awlen 16
`define arlen 16
`define awsize 4
`define arsize 4
module tb;
    reg start,block_aclk,block_areset;
    reg [31:0] block_awaddr,block_araddr;
    reg [127:0] block_wdata;
    wire [31:0] rdata;
    //integer i;

    top #(`awlen,`arlen,`awsize,`arsize)dut6 (.aclk(block_aclk),
             .data_in(block_wdata),
             .areset(block_areset),
             .waddr(block_awaddr),
             .raddr(block_araddr),
             .data_out(rdata),
             .start(start));
    
    always #5 block_aclk=~block_aclk;
        
    task reset();
    begin
        block_areset=1;
        start=0;
        #10;
        block_areset=0;
        start=1;
    end
    endtask
    
    initial begin
    block_aclk=1;
    reset();
    start=1;
    block_awaddr=32'hd;
    block_araddr=32'hd;
    block_wdata=$random;
#250;
    end
initial $stop(10000);
endmodule
