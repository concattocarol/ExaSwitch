`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2017 16:20:34
// Design Name: 
// Module Name: top_router
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


module top_router#(DATA_WIDTH=70)(
    input clk,                                                                                                   
    input rst,
    //interface with josh local port 
    //LOCAL FROM LOCAL PORT
    input [63:0] s1_tdata,
    input [7:0] s1_tkeep,
    input  s1_tvalid,
    output s1_tready,
    input  s1_tlast,
    ///TO LOCAL PORT
    output [63:0] m1_tdata,
    output [7:0]  m1_tkeep,
    output m1_tvalid,
    input  m1_tready,
    output m1_tlast,
    //////////end of th einterface of josh local port
    input [63:0] rx_axis_tdata_0,
    input [7:0]  rx_axis_tkeep_0,
    input       rx_axis_tvalid_0,
    output      rx_axis_tready_0,
    input        rx_axis_tlast_0,
    output [63:0]tx_axis_tdata_0,
    output [4:0] tx_axis_tkeep_0,
    output       tx_axis_tvalid_0,
    input        tx_axis_tready_0,
    output       tx_axis_tlast_0,
    input [63:0] rx_axis_tdata_1,
    input [7:0]  rx_axis_tkeep_1,
    input        rx_axis_tvalid_1,
    output       rx_axis_tready_1,
    input        rx_axis_tlast_1,
    output [63:0]tx_axis_tdata_1,
    output [4:0] tx_axis_tkeep_1,
    output       tx_axis_tvalid_1,
    input        tx_axis_tready_1,
    output       tx_axis_tlast_1,
    input [63:0] rx_axis_tdata_2,
    input [7:0]  rx_axis_tkeep_2,
    input        rx_axis_tvalid_2,
    output       rx_axis_tready_2,
    input        rx_axis_tlast_2,
    output [63:0]tx_axis_tdata_2,
    output [4:0] tx_axis_tkeep_2,
    output       tx_axis_tvalid_2,
    input        tx_axis_tready_2,
    output       tx_axis_tlast_2,
    input [63:0] rx_axis_tdata_3,
    input [7:0]  rx_axis_tkeep_3,
    input        rx_axis_tvalid_3,
    output       rx_axis_tready_3,
    input        rx_axis_tlast_3,
    output [63:0] tx_axis_tdata_3,
    output [4:0]  tx_axis_tkeep_3,
    output        tx_axis_tvalid_3,
    input         tx_axis_tready_3,
    output        tx_axis_tlast_3, 
    //TO CONFIGURE THE ROUTER
     input configure,                                                                                   
     input [63:0]distance,
     input [21:0] local_port );                                                                                                           
    
    (* mark_debug = "true" *)wire [DATA_WIDTH-1:0] Lout_data; 
    (* mark_debug = "true" *)wire [DATA_WIDTH-1:0] P0out_data;
    (* mark_debug = "true" *)wire [DATA_WIDTH-1:0] P1out_data;
    (* mark_debug = "true" *)wire [DATA_WIDTH-1:0] P2out_data;
    (* mark_debug = "true" *)wire [DATA_WIDTH-1:0] P3out_data; 
    
    (* mark_debug = "true" *)wire [DATA_WIDTH-1:0] Lin_data;
    (* mark_debug = "true" *) wire [DATA_WIDTH-1:0] P0in_data;
    (* mark_debug = "true" *) wire [DATA_WIDTH-1:0] P1in_data;
    (* mark_debug = "true" *)wire [DATA_WIDTH-1:0] P2in_data;
    (* mark_debug = "true" *)wire [DATA_WIDTH-1:0] P3in_data; 
    
   (* mark_debug = "true" *)  wire Lout_val, Lout_ack,P0out_val, P0out_ack,P1out_val, P1out_ack,P2out_val, P2out_ack,P3out_val, P3out_ack;
   (* mark_debug = "true" *) wire Lin_val, Lin_ack,P0in_val,P0in_ack,P1in_val,P1in_ack,P2in_val,P2in_ack,P3in_val,P3in_ack;   
    
      //DATA COMES FROM THE LOCAL PORT AND GOES TO THE ROUTER
      local2router #( .DATA_WIDTH(70))                                                                            
            tx_loca1(                                                                                                 
            /*input */       .clk(clk),
            /*input */       .rst(rst),
            //ROUTER INTERFACE (output)   
            /*output [DATA_WIDTH-1:0]*/ .data_router(Lin_data), 
            /*output*/  .val(Lin_val),
            /*input */.ack(Lin_ack),
            //LOCAL PORT INTERFACE 
            /*input [63:0] */.tdata(s1_tdata),
            /*input 4:0] */.tkeep(s1_tkeep),
            /*input*/ .tvalid(s1_tvalid),
            /*output */.tready(s1_tready),
            /*input*/.tlast(s1_tlast)
        );
            
            
        //DATA COMES FROM THE ROUTER AND GOES TO THE LOCAL PORT
        router2local#(.DATA_WIDTH(70))
               rx_local(
               /*input */  .clk(clk),
               /*input */  .rst(rst),
               //ROUTER INTERFACE (input)
               /*input  [DATA_WIDTH-1:0]*/.data_router(Lout_data),
               /*input */ .val(Lout_val),
               /*output*/ .ack(Lout_ack),
               //LOCAL PORT INTERFACE(output)
               /*output[63:0] */.tdata(m1_tdata),
               /*output 4:0] */.tkeep(m1_tkeep),
               /*output*/ .tvalid(m1_tvalid),
               /*input */.tready(m1_tready),
               /*output*/.tlast(m1_tlast)
       );    
      
      
      
                                                                                                  
    local2router #( .DATA_WIDTH(70))                                                                            
        rx_mac0(                                                                                                 
         /*input */       .clk(clk),
         /*input */       .rst(rst),
         //ROUTER INTERFACE (output)   
         /*output [DATA_WIDTH-1:0]*/ .data_router(P0in_data), 
         /*output*/  .val(P0in_val),
         /*input */.ack(P0in_ack),
         //LOCAL PORT INTERFACE 
         /*input [63:0] */.tdata(rx_axis_tdata_0),
         /*input 4:0] */.tkeep(rx_axis_tkeep_0),
         /*input*/ .tvalid(rx_axis_tvalid_0),
         /*output */.tready(rx_axis_tready_0),
         /*input*/.tlast(rx_axis_tlast_0)
        
        );
    
    router2local#(.DATA_WIDTH(70))
           tx_mac0(
            /*input */  .clk(clk),
           /*input */  .rst(rst),
           //ROUTER INTERFACE (input)
           /*input  [DATA_WIDTH-1:0]*/.data_router(P0out_data),
           /*input */ .val(P0out_val),
           /*output*/ .ack(P0out_ack),
           //LOCAL PORT INTERFACE(output)
           /*output[63:0] */.tdata(tx_axis_tdata_0),
           /*output 4:0] */ .tkeep(tx_axis_tkeep_0),
           /*output*/     .tvalid(tx_axis_tvalid_0),
           /*input */     .tready(tx_axis_tready_0),
           /*output*/       .tlast(tx_axis_tlast_0)
           );
       
       local2router #( .DATA_WIDTH(70))                                                                            
           rx_mac1(                                                                                                 
                   /*input */       .clk(clk),
                    /*input */       .rst(rst),
                    //ROUTER INTERFACE (output)   
                    /*output [DATA_WIDTH-1:0]*/ .data_router(P1in_data), 
                    /*output*/  .val(P1in_val),
                    /*input */.ack(P1in_ack),
                    //LOCAL PORT INTERFACE 
                    /*input [63:0] */.tdata(rx_axis_tdata_1),
                    /*input 4:0] */  .tkeep(rx_axis_tkeep_1),
                    /*input*/      .tvalid(rx_axis_tvalid_1),
                    /*output */    .tready(rx_axis_tready_1),
                    /*input*/        .tlast(rx_axis_tlast_1)
                   );
               
        router2local#(.DATA_WIDTH(70))
               tx_mac1(
               /*input */  .clk(clk),
                 /*input */  .rst(rst),
                 //ROUTER INTERFACE (input)
                 /*input  [DATA_WIDTH-1:0]*/.data_router(P1out_data),
                 /*input */ .val(P1out_val),
                 /*output*/ .ack(P1out_ack),
                 //LOCAL PORT INTERFACE(output)
                 /*output[63:0] */.tdata(tx_axis_tdata_1),
                 /*output 4:0] */ .tkeep(tx_axis_tkeep_1),
                 /*output*/     .tvalid(tx_axis_tvalid_1),
                 /*input */     .tready(tx_axis_tready_1),
                 /*output*/       .tlast(tx_axis_tlast_1)
               );
       local2router #( .DATA_WIDTH(70))                                                                            
            rx_mac2(                                                                                                 
            /*input */       .clk(clk),
            /*input */       .rst(rst),
            //ROUTER INTERFACE (output)   
            /*output [DATA_WIDTH-1:0]*/ .data_router(P2in_data), 
            /*output*/  .val(P2in_val),
            /*input */.ack(P2in_ack),
            //LOCAL PORT INTERFACE 
            /*input [63:0] */.tdata(rx_axis_tdata_2),
            /*input 4:0] */  .tkeep(rx_axis_tkeep_2),
            /*input*/      .tvalid(rx_axis_tvalid_2),
            /*output */    .tready(rx_axis_tready_2),
            /*input*/        .tlast(rx_axis_tlast_2)
            );
        
        router2local#(.DATA_WIDTH(70))
               tx_mac2(
               /*input */       .clk(clk),
               /*input */       .rst(rst),
               //ROUTER INTERFACE (output)   
               /*input [DATA_WIDTH-1:0]*/ .data_router(P2out_data), 
               /*output*/  .val(P2out_val),
               /*input */.ack(P2out_ack),
               //LOCAL PORT INTERFACE 
               /*output [63:0] */.tdata(tx_axis_tdata_2),
               /*output 4:0] */  .tkeep(tx_axis_tkeep_2),
               /*input*/         .tvalid(tx_axis_tvalid_2),
               /*output */      .tready(tx_axis_tready_2),
               /*input*/        .tlast(tx_axis_tlast_2)
                );
           local2router #( .DATA_WIDTH(70))                                                                            
               rx_mac3(                                                                                                 
                     /*input */       .clk(clk),
                     /*input */       .rst(rst),
                     //ROUTER INTERFACE (output)   
                     /*output [DATA_WIDTH-1:0]*/ .data_router(P3in_data), 
                     /*output*/  .val(P3in_val),
                     /*input */.ack(P3in_ack),
                     //LOCAL PORT INTERFACE 
                     /*input [63:0] */.tdata(rx_axis_tdata_3),
                     /*input 4:0] */  .tkeep(rx_axis_tkeep_3),
                     /*input*/      .tvalid(rx_axis_tvalid_3),
                     /*output */    .tready(rx_axis_tready_3),
                     /*input*/        .tlast(rx_axis_tlast_3)
            );
                   
            router2local#(.DATA_WIDTH(70))
                   tx_mac3(
                   /*input */       .clk(clk),
                       /*input */       .rst(rst),
                       //ROUTER INTERFACE (output)   
                       /*input [DATA_WIDTH-1:0]*/ .data_router(P3out_data), 
                       /*output*/  .val(P3out_val),
                       /*input */.ack(P3out_ack),
                       //LOCAL PORT INTERFACE 
                       /*input [63:0] */.tdata(tx_axis_tdata_3),
                       /*input 4:0] */  .tkeep(tx_axis_tkeep_3),
                       /*input*/       .tvalid(tx_axis_tvalid_3),
                       /*output */     .tready(tx_axis_tready_3),
                       /*input*/        .tlast(tx_axis_tlast_3)
                    );
                                                              
                       
    
    router#(.DATA_WIDTH(70),
                .NUMBER_CHANNELS(5))
             router_4ports(
           .clk(clk),
           .rst(rst),
            //router interface
             //LOCAL_PORT=PORT 5
            .Lin_data (Lin_data ),
            .Lin_val  (Lin_val  ),
            .Lin_ack  (Lin_ack  ),
            .Lout_data(Lout_data),
            .Lout_val (Lout_val ),
            .Lout_ack (Lout_ack ),
            //PORT 0
            .P0in_data (P0in_data ),
            .P0in_val  (P0in_val  ),
            .P0in_ack  (P0in_ack  ),
            .P0out_data(P0out_data),
            .P0out_val (P0out_val ),
            .P0out_ack (P0out_ack ),
            //PORT 1
            .P1in_data (P1in_data ),
            .P1in_val  (P1in_val  ),
            .P1in_ack  (P1in_ack  ),
            .P1out_data(P1out_data),
            .P1out_val (P1out_val ),
            .P1out_ack (P1out_ack ),
            //PORT 2 
            .P2in_data (P2in_data ),
            .P2in_val  (P2in_val  ),
            .P2in_ack  (P2in_ack  ),
            .P2out_data(P2out_data),
            .P2out_val (P2out_val ),
            .P2out_ack (P2out_ack ),
            // PORT 3
            .P3in_data (P3in_data ),
            .P3in_val  (P3in_val  ),
            .P3in_ack  (P3in_ack  ),
            .P3out_data(P3out_data),
            .P3out_val (P3out_val ),
            .P3out_ack (P3out_ack ),
            //TO CONFIGURE THE ROUTER
            .configure(configure),
            .distance (64'ha),
            .local_port(22'h14403)
           );
endmodule
