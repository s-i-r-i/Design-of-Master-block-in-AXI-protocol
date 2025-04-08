module slave#(parameter arlen=0,arsize=0)(aclk,
             areset,
             awvalid,
             wvalid,
             bready,
             arvalid,
             rready,
             awaddr,
             wdata,
             araddr,
             awready,
             wready,
             bvalid,
             arready,
             rvalid,
             rdata,
             bresp,
             rresp,
             wlast,
             rlast);

input aclk,areset,awvalid,wvalid,bready,arvalid,rready,wlast;

input [31:0] awaddr,araddr,wdata;

output reg awready,wready,bvalid,arready,rvalid,rlast;

output reg [1:0] bresp,rresp;

output reg [31:0] rdata;

reg [127:0] mem [127:0];

integer o;

always@(posedge aclk or areset)
    begin   
        if(areset)
            begin
            awready=1'b0;
            wready=1'b0;
            bvalid=1'b0;
            arready=1'b0;
            rvalid=1'b0;
            rdata=32'h0000;
            bresp=2'b00;
            rresp=2'b00;
            rlast=0;
            o=1;
            end
    end

always@(posedge aclk)
    begin
        if(awvalid)//After master verifies the addresses being sent it asserts the awvalid signal as one indicating addreses being sent are valid
            awready=1'b1;//Setting awready as one indicating slave is ready to recieve addresses from master
    end
    
always@(posedge aclk)
begin
if(rlast)//Rlast indicates that read data transaction has completed so
    begin
    bvalid=1'b1;//Setting bvalid as high indicating the response signal generated is valid
    rvalid=0;//Setting rvalid as zero in order to prevent any unecessary read_data transaction
    end
end

always@(posedge aclk)
    begin
        if(wvalid)//If slave receives a signal from master indicating write data to be stored is valid as high it asserts write_ready as high indicating it is ready to receive write data
            wready=1'b1;
    end
always@(posedge aclk)
begin
if(wvalid && wready)//Write Data will be stored if and only if both wvalid and wready are high
    mem[awaddr]=wdata;
    end

always@(posedge aclk)
    begin
        if(bready)//If master asserts and sends the ready_to_receive_response signal then slave sends the appropriate address
            bresp=2'b00;
    end

always@(posedge aclk)
    begin
        if(arvalid)
            arready=1'b1;
    end


always@(posedge aclk)
begin
if(arvalid && arready)
    rvalid=1'b1;
end

always@(posedge aclk)
    fork
    begin
        if(rready && o<arlen)
            begin:read_address
            if(mem[araddr])
                begin
                rdata=mem[araddr];
                end
           
            else
                begin
                rdata=0;
                end
                o=o+1;
    end:read_address
    end
    begin

        if(rlast)
            disable read_address;

    end
    join
always@(posedge aclk)
begin
        if(o>arlen)
        begin
        rlast=1;
        end
        end
endmodule
