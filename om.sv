class om;

    transaction t;
    mailbox #(transaction) m;
    virtual axi_inter ip;
    event done;
    
    function new(mailbox #(transaction) m,virtual axi_inter ip,event done);

        this.m=m;
        this.ip=ip;
        this.done=done;

    endfunction

    task t4;

        forever
        begin

            t=new();
            @(ip.dataout,ip.raddr)
            t.dataout=ip.dataout;
            t.print("From output monitor");
            ->done;
        end

    endtask

endclass
