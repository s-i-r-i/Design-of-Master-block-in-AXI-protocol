`include "master.v"
`include "slave.v"
module top#(parameter tawlen=0,tarlen=0,tawsize=0,tarsize=0)(input start,aclk,areset,
           input [31:0] waddr,raddr,
           input [127:0] data_in,
           output [31:0] data_out);
           
wire [31:0] awaddr,araddr,wdata,rdata;

wire  bvalid,
     awvalid,
     wvalid,
     arvalid,
     rvalid,
     bready,
     rready,
     awready,
     wready,
     arready,
     wlast,
     rlast;

wire [1:0] bresp,rresp;

master #(tawlen,tawsize,tarsize) mdut(.aclk(aclk),
            .start(start),
            .areset(areset),
            .data_in(data_in),
            .wdata(wdata),
            .rdata(rdata),
            .awvalid(awvalid),
            .awready(awready),
            .wvalid(wvalid),
            .waddr(waddr),
            .raddr(raddr),
            .wready(wready),
            .bvalid(bvalid),
            .bready(bready),
            .bresp(bresp),
            .arvalid(arvalid),
            .arready(arready),
            .rvalid(rvalid),
            .awaddr(awaddr),
            .araddr(araddr),
            .rresp(rresp),
            .rready(rready),
            .data_out(data_out),
            .wlast(wlast),
            .rlast(rlast));

slave  #(tarlen,tarsize) sdut(.aclk(aclk),
           .areset(areset),
           .wdata(wdata),
           .rdata(rdata),
           .awvalid(awvalid),
           .awready(awready),
           .wvalid(wvalid),
           .wready(wready),
           .bvalid(bvalid),
           .bready(bready),
           .bresp(bresp),
           .arvalid(arvalid),
           .arready(arready),
           .rvalid(rvalid),
           .awaddr(awaddr),
           .araddr(araddr),
           .rresp(rresp),
           .rready(rready),
           .wlast(wlast),
           .rlast(rlast));

    
endmodule
