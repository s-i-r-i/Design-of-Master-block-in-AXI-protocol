`include "test.sv"
program  tests (input int num,axi_inter ip);

    test t;
    initial begin

        t=new(ip,num);
        t.t7;

    end

    initial $finish(800);

endprogram
