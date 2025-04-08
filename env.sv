class environment;

    generator g;
    driver d;
    im i;
    om o;
    score s;
    int num;
    virtual axi_inter aip;
    mailbox #(transaction) m1,m2,m3;
    event d1,d2,d3,d4,d5;

    function new(virtual axi_inter aip,int num);
        
        m1=new();
        m2=new();
        m3=new();
        this.aip=aip;
        this.num=num;
        g=new(m1,d1,num);
        d=new(m1,aip,d2);
        i=new(m2,aip,d3);
        o=new(m3,aip,d4);
        s=new(m2,m3,d5);

    endfunction

    task t6;

        fork

            g.t1;
            wait(d1.triggered);
            d.t2;
            wait(d2.triggered);
            i.t3;
            wait(d3.triggered);
            o.t4;
            wait(d4.triggered);
            s.t5;
            wait(d5.triggered);
        join

    endtask

endclass
