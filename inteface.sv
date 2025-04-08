interface axi_inter(input clk,reset);

    logic [31:0] dataout,waddr,raddr;
    logic [127:0] datain;
    logic start;

endinterface
