module  master #(parameter awlen=0,awsize=0,arsize=0)(aclk,
              start,
              areset,
              data_in,
              rdata,
              data_out,
              awvalid,
              awready,
              wvalid,
              wready,
              bvalid,
              bready,
              bresp,
              arvalid,
              arready,
              rvalid,
              rready,
              awaddr,
              araddr,
              rresp,
              waddr,
              raddr,
              wdata,
              wlast,
              rlast);

input aclk,areset,start,rlast;

input [31:0] waddr,raddr,rdata;

input [127:0] data_in;

output reg [31:0] data_out;

input awready,wready,bvalid,arready,rvalid;

input [1:0] bresp,rresp;

output reg awvalid,wvalid,bready,arvalid,rready,wlast;

reg [31:0] aligned_address;
    
integer no_of_bytes;

integer n=1,m=1,o;

output reg [31:0] wdata,awaddr,araddr;

always@(posedge aclk or negedge areset)
    begin
    if(areset)
        begin
        awaddr=0;
        araddr=0;
        wdata=32'h0000;
        awvalid=1'b0;
        wvalid=1'b0;
        bready=1'b0;
        arvalid=1'b0;
        rready=1'b0;
        data_out=32'h0000;
        wlast=1'b0;
        aligned_address=0;
        o=0;
        end

    end

always@(posedge aclk)
begin
    if(start==1)//A testbench input indicating start of data transfer
        begin
        awvalid=1'b1;//Setting awvalid as 1
        end

end

always@(posedge aclk)
    begin   
        if(awready && awvalid)//Condition to ensure slave is ready to recieve the addresses being sent. Takes a full cycle because there is a one clock cycle difference of operation between master and slave
            begin:addresser// NOTE: Address or data will be sent if and only if both valid and ready signals are high
            if(n<=awlen)
                begin
                if(wlast)//Since wlast indicates end of write_data and write_address transfer we are disabling write address generation
                    disable addresser;
                else
                    begin
                    no_of_bytes=awsize;
                    aligned_address=(integer'(waddr/no_of_bytes))*no_of_bytes;
                    awaddr=aligned_address+(n-1)*no_of_bytes;
                    n=n+1;
                    end
            end
       end:addresser
     end
always@(posedge aclk)
begin

    if(awvalid)
        wvalid=1'b1;//For this very specific case both data and address are being sent simultaneously

end
always@(posedge aclk)
    begin
    if(wready && wvalid)//As mentioned before data transmission takes place if and only if both ready and valid signals are high
        begin
    
    if(data_in[awsize*o+:awsize])//This condition will allow data transfer if and only if data from top module being sent is valid i.e without any don't care or high impedance levels
        begin
                    wdata=data_in[awsize*o+:awsize];//Data slicing to send data in an ordered manner. In this case sending a 16 bits at each time.
                    o=o+1;
        end
        else 
            begin
        disable addresser;
        wlast=1;//The wlast signal is the indication that data has been completely sent
            end
    end
    end

always@(posedge aclk)
    begin
        if(bvalid)//After receiving that response generated in slave is valid we set bready to 1 indicating that master is ready to accept the response being sent by slave after a transaction
            bready=1'b1;
    end

always@(posedge aclk)
begin

    if(wlast)//Checking if write data and address have been sent completely
        begin
        arvalid=1;//As soon as write part is done we initiate read part by setting arvalid as 1
        awvalid=0;//In order to prevent any unecessary transactions setting awvalid and wvalid as 0
        wvalid=0;
        end

end

always@(posedge aclk)
begin

    if(rlast)//Rlast indicates that read address and read data have been fully sent from slave and with signal coming as 1 from slave indicates read transaction is complete
        begin
        arvalid=0;//Setting arvalid to zero in order to stop any further read address generation and transmission
        end

end

always@(posedge aclk)
    begin        
        if(arready && arvalid)//Read address transmission will take place from master to slave if and only if both valid and ready signals are high
            begin:read_addresser
                if(m<=awlen)
                begin
                
                if(m==n)//For disabling read address generation whenever data reading is completed. Since number of read and write addresses
                    disable read_addresser;//are the same we chose number of iterations for both addresses validating signals as the if condition to disable.
                else
                    begin
                no_of_bytes=arsize;
                aligned_address=(integer'(raddr/no_of_bytes))*no_of_bytes;//Used for aligning unaligned addresses to 4 (in this specific case because the aligned address depends on no_of_bytes)
                araddr=aligned_address+(m-1)*no_of_bytes;
                    m=m+1;
                    end
            end
                    end:read_addresser
    end

always@(posedge aclk)
    begin
        if(rvalid)//If the slave verifies the data being sent is valid and it is sent to master we assert the ready signal rready as 1 indicating master is ready to receive data
            begin
            rready=1'b1;
            end            
    end
always@(posedge aclk)
    begin
            if(rvalid && rready)//Read data transmission from master to top module takes place from master to top if and only if both valid and ready signals are high
            data_out<=rdata;
    end
endmodule
