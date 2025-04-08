class driver;

    transaction t;
    mailbox #(transaction) m;
    virtual axi_inter ip;
    event done;

    function new(mailbox #(transaction) m,virtual axi_inter ip,event done);

        this.m=m;
        this.ip=ip;
        this.done=done;

    endfunction

    task t2;

        forever
        begin

            t=new();
            m.get(t);
            ip.datain=t.datain;
            ip.waddr=t.waddr;
            ip.raddr=t.raddr;
            ip.start=t.start;
            t.print("From driver");
            ->done;

        end

    endtask

endclass
