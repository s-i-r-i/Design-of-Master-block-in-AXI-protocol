class transaction;

    rand bit [127:0] datain;
    bit [31:0] waddr,raddr;
    bit start;
    bit [31:0] dataout;

    function void print(string msg="");

        $display("%s    Datain=%0d    Write_address=%0d   Read_address=%0d    data_out=%0d  Time= ",msg,datain,waddr,raddr,dataout,$time,"\n");

    endfunction

endclass
