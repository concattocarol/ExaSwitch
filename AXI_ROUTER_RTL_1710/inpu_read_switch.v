`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2016 13:00:18
// Design Name: 
// Module Name: inpu_read_switch
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


module input_read_switch#(NUMBER_CHANNELS=5)(
    input                       clk,
    input                       rst,
    input [NUMBER_CHANNELS-1:0] gnt,
    input [NUMBER_CHANNELS-1:0] ack,
    input [NUMBER_CHANNELS-1:0] req,
    output[NUMBER_CHANNELS-1:0] rd,
    output [NUMBER_CHANNELS-1:0] wr
    );
    
    reg [NUMBER_CHANNELS-1:0]  req_reg2,req_reg;
    
    genvar i;
    for (i=0; i<NUMBER_CHANNELS;i=i+1) begin
    assign rd[i]= gnt[i]&ack[i]; 
    end
    
    always@(posedge clk)
      begin
         if (rst==1'b1) begin req_reg=0;req_reg=0; end
         else begin
              req_reg2=req_reg;
              req_reg=req;
         end
  end
            
   assign wr= req_reg|req_reg2;  
    
endmodule
