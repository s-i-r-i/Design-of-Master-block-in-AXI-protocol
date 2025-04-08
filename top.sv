`include "inteface.sv"
`include "top.v"
`include "tb.sv"
`define awlen 16
`define arlen 16
`define awsize 8
`define arsize 8
module topsv;

    bit reset,clk;
    axi_inter ai(clk,reset);
    top #(`awlen,`arlen,`awsize,`arsize) t(.aclk(clk),
          .areset(reset),
          .start(ai.start),
          .waddr(ai.waddr),
          .raddr(ai.raddr),
          .data_in(ai.datain),
          .data_out(ai.dataout));
    tests ts(`awlen,ai);

    always #5 clk=~clk;

    initial begin

        clk=1;
        reset=1;
        #10;
        reset=0;

    end


endmodule
