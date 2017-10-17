`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2016 15:37:54
// Design Name: 
// Module Name: cam
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*`define memdepth 127
`define datawidth 31
`define memwidth `datawidth + 31
*/
module input_controller #(
             parameter DATA_WIDTH=70,
             parameter NUMBER_CHANNELS=5
             //parameter LOCAL_PORT=5)
    )
    (input                          rst,  
    input                          clk,       
    input   [DATA_WIDTH-1:0]       din,
    input                          rok,
    input                          in_val,
    input    [DATA_WIDTH-1:0]      header,
    //output [DATA_WIDTH-1:0]        dout,
    output [NUMBER_CHANNELS-1:0]   req_x, 
    input  [63:0]                  distance,
    input                          configure,
    input  [21:0]                 local_port
      
);
reg [63:0] port_range_mem, reg_local_port; 
reg [NUMBER_CHANNELS-1:0] reg_req;
reg [2:0]test;
wire bop,eop;
wire header_present;
wire [DATA_WIDTH-7:0] dest_coordination;
reg reg_header;
reg [DATA_WIDTH-7:0] reg_destination;


assign bop=header[DATA_WIDTH-1];
assign eop=header[DATA_WIDTH-2];
assign header_present = bop; //;& rok
assign dest_coordination =(header_present==1'b1)? header[DATA_WIDTH-3:4]:reg_destination;


//PROCESS TO WRITE THE RANGE OF EACH PORT


 always @(posedge clk) begin
    if (rst==1) begin port_range_mem=22'b0; end
    else begin
    if (configure==1'b1) begin
      port_range_mem=distance[21:0];
   end
  end 
end

always@(posedge clk) begin
    if(rst==1'b1) begin reg_local_port=22'b0; end 
    else begin 
        if (configure==1'b1) begin
            reg_local_port=local_port;
        end
    end
 end 



always@(posedge clk) begin
  if(rst==1'b1) begin reg_destination=0; end 
else begin 
 if(reg_header==1'b1)begin
    reg_destination=din[DATA_WIDTH-3:4];
  end  else begin
     reg_destination= reg_destination;
end end
end






always@(posedge clk) begin
  if(rst==1'b1) begin reg_header=1'b0; end 
else begin 
    reg_header=header_present;
end end

 always @(posedge clk ) begin// header_present,in_val,dest_coordination[42:21],reg_local_port,port_range_mem[0]
    if (header_present==1'b1)begin//{
        if (dest_coordination[42:21]==reg_local_port)begin //CHECK AGAIN CAROL
          reg_req=4'b1111;    
        end//{
        else begin//{
            if (port_range_mem[0]==1'b1)begin //{at the top
                reg_req=dest_coordination[42:35];  //selects a cabinet
                test=3'b111;//}
             end else begin // {Tier 3
                if (dest_coordination[42:35]==port_range_mem[9:1])begin //is in the Cabinet
                    reg_req= dest_coordination[34:31] ;  /*go down */
                    test=3'b110;
                  end //}
                    else begin//{
                        reg_req = 4'b0100;      /*go up*/
                        test=3'b100;
                    end//}
             end //}
        end //}
      end //}
      else begin//{
        if (in_val==1'b0) begin
            reg_req=4'b0000;
            test=3'b011;
        end else begin
            reg_req=reg_req;//reg_destination[33:30];
            test=3'b010;
       end
   end//}
 end

 





////////OUTPUT SETS
//THE LOCAL PORT IS THE MOST SIGNIFICANT BIT
//ATM, NEEDS TO BE UPDATED QWHEN THE NUMBER OF PORTS INCREASES

assign req_x= (reg_req==4'b0001)? 5'b00001:
              (reg_req==4'b0010)? 5'b00010:
              (reg_req==4'b0011)? 5'b00100:
              (reg_req==4'b0100)? 5'b01000:
              (reg_req==4'b1111)? 5'b10000: //LOCAL PORT
              5'b00000;       
       

  
endmodule
