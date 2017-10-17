`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2016 14:05:46
// Design Name: 
// Module Name: router
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


module router#(DATA_WIDTH=70,
                NUMBER_CHANNELS=5)(
    input clk,
    input rst,
    //router interface
    //LOCAL Port
    input  [DATA_WIDTH-1:0] Lin_data,
    input  Lin_val,
    output Lin_ack,
    output [DATA_WIDTH-1:0]Lout_data,
    output Lout_val,
    input  Lout_ack,
    //PORT 0
    input  [DATA_WIDTH-1:0] P0in_data,
    input  P0in_val,
    output P0in_ack,
    output [DATA_WIDTH-1:0]P0out_data,
    output P0out_val,
    input  P0out_ack,
    //PORT 1
    input  [DATA_WIDTH-1:0] P1in_data,
    input  P1in_val,
    output P1in_ack,
    output [DATA_WIDTH-1:0]P1out_data,
    output P1out_val,
    input  P1out_ack,
    //PORT 2
    input  [DATA_WIDTH-1:0] P2in_data,
    input  P2in_val,
    output P2in_ack,
    output [DATA_WIDTH-1:0]P2out_data,
    output P2out_val,
    input  P2out_ack,
    // PORT 3
    input  [DATA_WIDTH-1:0] P3in_data,
    input  P3in_val,
    output P3in_ack,
    output [DATA_WIDTH-1:0]P3out_data,
    output P3out_val,
    input  P3out_ack,
 
   //TO CONFIGURE THE ROUTER
   input configure,
   input [63:0]distance,
   input [21:0]local_port 
  );
  
  //LOCAL PORT  SIGNALS TO INTERFACE WITH THE XBAR
   //INPUT PORT
    (*mark_debug="true"*) wire [NUMBER_CHANNELS-1:0] l_gnt;
    wire [NUMBER_CHANNELS-1:0] l_ack;
   (*mark_debug="true"*) wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] l_dout;
   (*mark_debug="true"*) wire [NUMBER_CHANNELS-1:0] l_req;
    wire [NUMBER_CHANNELS-1:0] l_rok;
    //OUTPUT PORT
    wire [NUMBER_CHANNELS-1:0] lX_req;
    wire [NUMBER_CHANNELS-1:0] lX_rok;
    wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] lX_din;
    wire [NUMBER_CHANNELS-1:0] lX_gnt;
    wire lidle_test; 
 //PORT 0 SIGNALS TO INTERFACE WITH THE XBAR
 //INPUT PORT
  wire [NUMBER_CHANNELS-1:0] p0_gnt;
  wire [NUMBER_CHANNELS-1:0] p0_ack;
  wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] p0_dout;
  wire [NUMBER_CHANNELS-1:0] p0_req;
  wire [NUMBER_CHANNELS-1:0] p0_rok;
  //OUTPUT PORT
  wire [NUMBER_CHANNELS-1:0] p0X_req;
  wire [NUMBER_CHANNELS-1:0] p0X_rok;
  wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] p0X_din;
  wire [NUMBER_CHANNELS-1:0] p0X_gnt;
  wire p0idle_test; 
   
  //PORT 1 SIGNALS TO INTERFACE WITH THE XBAR
  //INPUT PORT
  wire [NUMBER_CHANNELS-1:0] p1_gnt;
  wire [NUMBER_CHANNELS-1:0] p1_ack;
  wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] p1_dout;
  wire [NUMBER_CHANNELS-1:0] p1_req;
  wire [NUMBER_CHANNELS-1:0] p1_rok;
  //OUTPUT PORT
  wire [NUMBER_CHANNELS-1:0] p1X_req;
  wire [NUMBER_CHANNELS-1:0] p1X_rok;
  wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] p1X_din;
  wire [NUMBER_CHANNELS-1:0] p1X_gnt;
  wire p1idle_test; 
  
  
  //PORT 2 SIGNALS TO INTERFACE WITH THE XBAR
  //INPUT PORT
  wire [NUMBER_CHANNELS-1:0] p2_gnt;
  wire [NUMBER_CHANNELS-1:0] p2_ack;
  wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] p2_dout;
  wire [NUMBER_CHANNELS-1:0] p2_req;
  wire [NUMBER_CHANNELS-1:0] p2_rok;
   //OUTPUT PORT
  wire [NUMBER_CHANNELS-1:0] p2X_req;
  wire [NUMBER_CHANNELS-1:0] p2X_rok;
  wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] p2X_din;
  wire [NUMBER_CHANNELS-1:0] p2X_gnt;
  wire p2idle_test;
  
   //PORT 3 SIGNALS TO INTERFACE WITH THE XBAR
   //INPUT PORT
  wire [NUMBER_CHANNELS-1:0] p3_gnt;
  wire [NUMBER_CHANNELS-1:0] p3_ack;
  wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] p3_dout;
  wire [NUMBER_CHANNELS-1:0] p3_req;
  wire [NUMBER_CHANNELS-1:0] p3_rok;
  //OUTPUT PORT
  wire [NUMBER_CHANNELS-1:0] p3X_req;
  wire [NUMBER_CHANNELS-1:0] p3X_rok;
  wire [(DATA_WIDTH*NUMBER_CHANNELS)-1:0] p3X_din;
  wire [NUMBER_CHANNELS-1:0] p3X_gnt;
  wire p3idle_test;
 // wire P3_ack,P2_ack,P1_ack,P0_ack;
  //LOCAL PORT
   input_channel#(.DATA_WIDTH(70),
                  .NUMBER_CHANNELS(NUMBER_CHANNELS))
       LOCAL_INPUT(
       .clk(clk),
       .rst(rst),
       .in_data(Lin_data),
       .in_val(Lin_val), 
       .in_ack(Lin_ack), //OUTPUT
       .x_gnt(l_gnt),
       .x_ack(l_ack),
       .x_dout(l_dout),
       .x_req(l_req), 
       .x_rok(l_rok),
       .distance(distance),
       .configure(configure),
       .local_port(local_port)  
       );
       
 
 
   //PORT 0
   input_channel#(.DATA_WIDTH(70),
                  .NUMBER_CHANNELS(NUMBER_CHANNELS))
       P0_INPUT(
       .clk(clk),
       .rst(rst),
       .in_data(P0in_data),
       .in_val(P0in_val), 
       .in_ack(P0in_ack), //OUTPUT
       .x_gnt(p0_gnt),
       .x_ack(p0_ack),
       .x_dout(p0_dout),
       .x_req(p0_req),
       .x_rok(p0_rok),
       .distance(distance),
       .configure(configure),
       .local_port(local_port)   
       );
       
       //PORT 1
         input_channel#(.DATA_WIDTH(70),
                        .NUMBER_CHANNELS(NUMBER_CHANNELS))
        P1_INPUT(
        .clk(clk),
        .rst(rst),
        .in_data(P1in_data),
        .in_val(P1in_val),
        .in_ack(P1in_ack),
        .x_gnt(p1_gnt),
        .x_ack(p1_ack),
        .x_dout(p1_dout),
        .x_req(p1_req),
        .x_rok(p1_rok),
        .distance(distance),
        .configure(configure),
        .local_port(local_port)   
        );
        
        //PORT 2
         input_channel#(.DATA_WIDTH(70),
                         .NUMBER_CHANNELS(NUMBER_CHANNELS))
         P2_INPUT(
         .clk(clk),
         .rst(rst),
         .in_data(P2in_data),
         .in_val(P2in_val),
         .in_ack(P2in_ack),
         .x_gnt(p2_gnt),
         .x_ack(p2_ack),
         .x_dout(p2_dout),
         .x_req(p2_req),
         .x_rok(p2_rok),
         .distance(distance),
         .configure(configure),
         .local_port(local_port)   
         );
        
        //PORT 3                                                                  
        input_channel#(.DATA_WIDTH(70),                                           
                       .NUMBER_CHANNELS(NUMBER_CHANNELS))                         
        P3_INPUT(                                                                 
        .clk(clk),                                                                
        .rst(rst),                                                                
        .in_data(P3in_data),                                                      
        .in_val(P3in_val),                                                        
        .in_ack(P3in_ack),                                                        
        .x_gnt(p3_gnt),                                                           
        .x_ack(p3_ack),                                                           
        .x_dout(p3_dout),                                                         
        .x_req(p3_req),                                                           
        .x_rok(p3_rok),                                                           
        .distance(distance),                                                      
        .configure(configure),
        .local_port(local_port)                                                      
        );                                                                        
                         
   
   ////////
   //OUTPUT PORTS
     output_channel#(
                 .DATA_WIDTH(70),
                 .NUMBER_CHANNELS(NUMBER_CHANNELS))
    LOCAL_OUTPUT(
        .clk(clk),
        .rst(rst),
        .out_data(Lout_data),
        .out_val(Lout_val),
        .out_ack(Lout_ack),
        .x_req(lX_req),
        .x_rok(lX_rok),
        .x_din(lX_din),
        .x_gnt(lX_gnt),
       // .in_ack(P0in_ack),
        .idle_test(lidle_test)
        );
        
   
   output_channel#(
                .DATA_WIDTH(70),
                .NUMBER_CHANNELS(NUMBER_CHANNELS))
   P0_OUTPUT(
       .clk(clk),
       .rst(rst),
       .out_data(P0out_data),
       .out_val(P0out_val),
       .out_ack(P0out_ack),
       .x_req(p0X_req),
       .x_rok(p0X_rok),
       .x_din(p0X_din),
       .x_gnt(p0X_gnt),
      // .in_ack(P0in_ack),
       .idle_test(p0idle_test)
       );
       
       
    output_channel#(
                .DATA_WIDTH(70),
                .NUMBER_CHANNELS(NUMBER_CHANNELS))
    P1_OUTPUT(
    .clk(clk),
    .rst(rst),
    .out_data(P1out_data),
    .out_val(P1out_val),
    .out_ack(P1out_ack),
    .x_req(p1X_req),
    .x_rok(p1X_rok),
    .x_din(p1X_din),
    .x_gnt(p1X_gnt),
    //.in_ack(P1in_ack),
    .idle_test(p1idle_test)
    );
    
    output_channel#(
                .DATA_WIDTH(70),
                .NUMBER_CHANNELS(NUMBER_CHANNELS))
       P2_OUTPUT(
           .clk(clk),
           .rst(rst),
           .out_data(P2out_data),
           .out_val(P2out_val),
           .out_ack(P2out_ack),
           .x_req(p2X_req),
           .x_rok(p2X_rok),
           .x_din(p2X_din),
           .x_gnt(p2X_gnt),
          // .in_ack(P2in_ack),
           .idle_test(p2idle_test)
           );
          
        output_channel#(
                .DATA_WIDTH(70),
                .NUMBER_CHANNELS(NUMBER_CHANNELS))
        P3_OUTPUT(
        .clk(clk),
        .rst(rst),
        .out_data(P3out_data),
        .out_val(P3out_val),
        .out_ack(P3out_ack),
        .x_req(p3X_req),
        .x_rok(p3X_rok),
        .x_din(p3X_din),
        .x_gnt(p3X_gnt),
        //.in_ack(P3in_ack),
        .idle_test(p3idle_test)
        );
        
                         
   
   //ASSYNCRONOUS
   //NEEDS TO BE UPDATED EVERY TIME A NEW POR IS ADDED
   //REDO: AOTOMATICALLY
   //LOCAL
   assign lX_req={1'b0,p3_req[4],p2_req[4],p1_req[4],p0_req[4]};
   assign lX_rok={1'b0,p3_rok[4],p2_rok[4],p1_rok[4],p0_rok[4]};
   assign lX_din={70'b0,p3_dout[(DATA_WIDTH*5)-1-:DATA_WIDTH],p2_dout[(DATA_WIDTH*5)-1-:DATA_WIDTH],p1_dout[(DATA_WIDTH*5)-1-:DATA_WIDTH],p0_dout[(DATA_WIDTH*5)-1-:DATA_WIDTH]};
   assign l_gnt= {1'b0,p3X_gnt[4],p2X_gnt[4],p1X_gnt[4],p0X_gnt[4]};
   assign l_ack= {1'b0,P3out_ack,P2out_ack,P1out_ack,P0out_ack};
      
   //port 0
   assign p0X_req={l_req[0],p3_req[0],p2_req[0],p1_req[0],1'b0};
   assign p0X_rok={l_rok[0],p3_rok[0],p2_rok[0],p1_rok[0],1'b0};
   assign p0X_din={l_dout[DATA_WIDTH-1-:DATA_WIDTH],p3_dout[DATA_WIDTH-1-:DATA_WIDTH],p2_dout[DATA_WIDTH-1-:DATA_WIDTH],p1_dout[DATA_WIDTH-1-:DATA_WIDTH],70'b0};
   assign p0_gnt= {lX_gnt[0],p3X_gnt[0],p2X_gnt[0],p1X_gnt[0],1'b0};
   assign p0_ack= {Lout_ack,P3out_ack,P2out_ack,P1out_ack,1'b0};
   
   //port 1
  assign p1X_req={l_req[1],p3_req[1],p2_req[1],1'b0,p0_req[1]};
  assign p1X_rok={l_rok[1],p3_rok[1],p2_rok[1],1'b0,p0_rok[1]};
  assign p1X_din={l_dout[(DATA_WIDTH*2)-1-:DATA_WIDTH],p3_dout[(DATA_WIDTH*2)-1-:DATA_WIDTH],p2_dout[(DATA_WIDTH*2)-1-:DATA_WIDTH],70'b0,p0_dout[(DATA_WIDTH*2)-1-:DATA_WIDTH]};
  assign p1_gnt= {lX_gnt[1],p3X_gnt[1],p2X_gnt[1],1'b0,p0X_gnt[1]};
  assign p1_ack= {Lout_ack,P3out_ack,P2out_ack,1'b0,P0out_ack};
      
    //port 2
  assign p2X_req={l_req[2],p3_req[2],1'b0,p1_req[2],p0_req[2]};
  assign p2X_rok={l_rok[2],p3_rok[2],1'b0,p1_rok[2],p0_rok[2]};
  assign p2X_din={l_dout[(DATA_WIDTH*3)-1-:DATA_WIDTH],p3_dout[(DATA_WIDTH*3)-1-:DATA_WIDTH],70'b0,p1_dout[(DATA_WIDTH*3)-1-:DATA_WIDTH],p0_dout[(DATA_WIDTH*3)-1-:DATA_WIDTH]};
  assign p2_gnt= {lX_gnt[2],p3X_gnt[2],1'b0,p1X_gnt[2],p0X_gnt[2]};
  assign p2_ack= {Lout_ack,P3out_ack,1'b0,P1out_ack,P0out_ack};
  
  //port 3
  assign p3X_req={l_req[3],1'b0,p2_req[3],p1_req[3],p0_req[3]};
  assign p3X_rok={l_rok[3],1'b0,p2_rok[3],p1_rok[3],p0_rok[3]};
  assign p3X_din={l_dout[(DATA_WIDTH*4)-1-:DATA_WIDTH],70'b0,p2_dout[(DATA_WIDTH*4)-1-:DATA_WIDTH],p1_dout[(DATA_WIDTH*4)-1-:DATA_WIDTH],p0_dout[(DATA_WIDTH*4)-1-:DATA_WIDTH]};
  assign p3_gnt= {lX_gnt[3],1'b0,p2X_gnt[3],p1X_gnt[3],p0X_gnt[3]};
  assign p3_ack= {Lout_ack,1'b0,P2out_ack,P1out_ack,P0out_ack};
 
endmodule
