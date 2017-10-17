`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2016 12:18:44
// Design Name: 
// Module Name: output_channel
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


module output_channel#( parameter DATA_WIDTH=70,
                        parameter NUMBER_CHANNELS=5)(
    input clk,
    input rst,
    //output channel interface
    output [DATA_WIDTH-1:0] out_data,
    output out_val,
    input  out_ack,
    //xbar interface (x)
    input  [NUMBER_CHANNELS-1:0]  x_req,
    input  [NUMBER_CHANNELS-1:0]  x_rok,
    input  [(NUMBER_CHANNELS*DATA_WIDTH)-1:0]x_din,
    output [NUMBER_CHANNELS-1:0]  x_gnt,
   // output in_ack,
    //juts for test
    output idle_test
    );
    
wire idle;
wire [NUMBER_CHANNELS-1:0] sel_channel;
wire [NUMBER_CHANNELS-1:0] gnt;
wire [DATA_WIDTH-1:0] dout;     
wire rok_out; 
reg reg_out_val;   
 output_controller#(.NUMBER_CHANNELS(NUMBER_CHANNELS))
    U0(
      .rst         (rst),
      .clk         (clk),
      .ack         (out_ack),
      .eop         (dout[DATA_WIDTH-2]),
      .req_channel (x_req),
      .gnt_channel (gnt),
      .sel_channel (sel_channel),
      .idle        (idle)
      ); 
 
 output_data_switch#(
        .DATA_WIDTH(70),
        .NUMBER_CHANNELS(NUMBER_CHANNELS))
       U1(
          .idle(idle) ,
          .sel (sel_channel) ,
          .din (x_din) ,
          .dout(dout)
          );
          
  output_valid_switch#(.NUMBER_CHANNELS(NUMBER_CHANNELS))
        U2(
            .gnt (gnt) ,
            .rok (x_rok),
            .sel (sel_channel),
            .val (out_val)
           );
           
   /* output_buffer#( 
             .DATA_WIDTH(70),
            .FIFO_DEPTH (16),
            .FIFO_WIDTH(4))
        U3   (
               . clk(clk), 
               . rst(rst), 
               . din(dout), 
               . dout(out_data),
               //. ack(in_ack),
               . rok(rok_out), 
               . wr_en(reg_out_val),
               . rd_en(out_ack) 
               );*/
 //outputs  
  
              
      assign out_data=dout;  
      assign x_gnt=gnt; 
      assign idle_test=idle; 
endmodule
