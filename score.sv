class score;

    transaction t1,t2;
    mailbox #(transaction) m,m1;
    event done;
    int count=0;

    function new(mailbox #(transaction) m,m1,event done);

        this.m=m;
        this.m1=m1;
        this.done=done;

    endfunction

    task t5;

        t1=new();
        t2=new();
        forever
        begin
            
            m.get(t1);
            m1.get(t2);

            if(t1.dataout==t2.dataout)
                begin
                    
                    count+=1;
                    $display("++++++++++++++++++++++++++++WORKING+++++++++++++++++++++++++++++%0d",count);
                    t1.print("Reference data");
                    t2.print("Actual data");

                end
            
            else
                begin

                    $display(":::::::::::::::::::::::::::NOT WORKING:::::::::::::::::::::::::::");
                    t1.print("Reference data");
                    t2.print("Actual data");

                end
            ->done;
        end

    endtask

endclass
