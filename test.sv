`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "im.sv"
`include "om.sv"
`include "score.sv"
`include "env.sv"
class test;

    environment e;
    virtual axi_inter aip;
    int l;

    function new(virtual axi_inter aip,int l);

        this.aip=aip;
        this.l=l;

    endfunction

    task t7;

        begin

            e=new(aip,l);
            e.t6;

        end

    endtask

endclass
