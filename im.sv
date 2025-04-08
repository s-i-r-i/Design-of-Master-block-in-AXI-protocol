class im;

    transaction t;
    mailbox #(transaction) m;
    virtual axi_inter ip;
    event done;
    
    reg [127:0] mem [127:0];

    function new(mailbox #(transaction) m,virtual axi_inter ip,event done);

        this.m=m;
        this.ip=ip;
        this.done=done;

    endfunction

    task t3;

        forever
        begin

            t=new();
            @(ip.waddr,ip.raddr)
            t.datain=ip.datain;
            t.waddr=ip.waddr;
            t.raddr=ip.raddr;
            t.start=ip.start;
            if(ip.reset)
                t.dataout=0;
            else if(t.waddr)
                begin
                mem[t.waddr]=t.datain;
                end
            else if(t.raddr)
                begin
                t.dataout=mem[t.raddr];
                end
            t.print("From input monitor");
            ->done;
        end

    endtask

endclass
