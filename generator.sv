class generator;

    transaction t;
    mailbox #(transaction) m;
    event done;
    int no_of_repeats;

    function new(mailbox #(transaction) m,event done,int no_of_repeats);

        this.m=m;
        this.t=t;
        this.no_of_repeats=no_of_repeats;

    endfunction

    task t1;

        t=new();
        t.start=1;
        void'(t.randomize());
        repeat(no_of_repeats)
        begin

            t.waddr=0;
            m.put(t);
            t.print("Inside generator from write cycle");
            #10;

        end
        #500;
        repeat(no_of_repeats)
        begin

            t.raddr=0;
            m.put(t);
            t.print("Inside generator from read cycle");
            #10;

        end

        ->done;

    endtask

endclass
