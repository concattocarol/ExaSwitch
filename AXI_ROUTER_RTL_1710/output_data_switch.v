`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2016 12:18:03
// Design Name: 
// Module Name: output_data_switch
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


module output_data_switch#(
      parameter DATA_WIDTH=70,
      parameter NUMBER_CHANNELS=5            //Number of channels in the switch
  )(
    idle,
    sel,
    din ,
    dout
    );
    
     input  idle;
     input  [NUMBER_CHANNELS-1:0] sel;
     input  [(NUMBER_CHANNELS*DATA_WIDTH)-1:0]din;
     output [DATA_WIDTH-1:0] dout;
      
   
   reg [NUMBER_CHANNELS-1:0]channel_req;
   reg [NUMBER_CHANNELS-1:0] i;
   
    always@(sel) 
    for (i=0;i<NUMBER_CHANNELS;i=i+1) begin
       channel_req= (sel[i]==1)? i+1:channel_req;
     end
       
    assign dout=(idle==1)? 0 :
                (sel[0]==1)? din[(DATA_WIDTH-1)-:DATA_WIDTH] :din[(DATA_WIDTH*channel_req)-1-:DATA_WIDTH];

endmodule
