`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2016 11:16:51
// Design Name: 
// Module Name: input_channel
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


module input_channel#(DATA_WIDTH=70,
                        NUMBER_CHANNELS=5)(
    input clk,
    input rst,
    //input_channel interface
    input [DATA_WIDTH-1:0] in_data,
    input  in_val,
    output in_ack,
    //crossbar interface (X)
    input  [NUMBER_CHANNELS-1:0] x_gnt,
    input  [NUMBER_CHANNELS-1:0] x_ack,
    output [(DATA_WIDTH*NUMBER_CHANNELS) -1:0]x_dout,
    output [NUMBER_CHANNELS-1:0] x_req,
    output [NUMBER_CHANNELS-1:0] x_rok,
    //to configure the swicth
     input [63:0]            distance,
     input                   configure,
     input [21:0]           local_port
    );
    
    wire [NUMBER_CHANNELS-1:0] req;
    wire [NUMBER_CHANNELS-1:0] rd_en,wr_en;
    reg  [NUMBER_CHANNELS-1:0] rd_en1,rd_en2;
    wire [NUMBER_CHANNELS-1:0] ack;
    //wire [NUMBER_CHANNELS-1:0] rok;
    wire rok_int;
    wire [DATA_WIDTH-1:0] dout[NUMBER_CHANNELS-1:0];
    reg [DATA_WIDTH-1:0] data_reg,data_reg2,data_reg3;
    reg val_reg,val_reg2;
  
 
      always@(posedge clk)
      begin
          if (rst==1'b1) begin  data_reg2=0;data_reg=0; end
          else begin
                data_reg3=data_reg2;
                data_reg2=data_reg;
                data_reg=in_data;
          end
      end
  
           
       always@(posedge clk)
        begin
             if (rst==1'b1) begin val_reg=1'b0; end
             else begin
                   val_reg2=val_reg;
                   val_reg=in_val;
             end
         end
         
       
      
      assign  in_ack=(in_val==1'b0)?1'b0:     //no receiveing packet
                      (ack!=0)? 1'b1:         //fifo is known and has space
                      (req==0)?1'b1:1'b0;     // fifo is unknown : does not have space
                      
     
      
    
      input_controller #(.DATA_WIDTH(70),
                         .NUMBER_CHANNELS(NUMBER_CHANNELS))
          U1(
           .rst(rst),
           .clk(clk),
           .din(in_data),
           .header(in_data),
           .in_val(in_val),//||val_reg
           .rok(rok_int),
           .req_x(req), 
           .distance(distance),
           .configure(configure),
           .local_port(local_port)  
         );
       input_read_switch#(.NUMBER_CHANNELS(NUMBER_CHANNELS))
          U2(
             .clk(clk),
             .rst(rst),
             .gnt(x_gnt),
             .ack(x_ack),
             .req(req),
             .rd (rd_en),
             .wr (wr_en)
             );  
       
       genvar i;
       for (i=0;i<NUMBER_CHANNELS;i=i+1) begin
            input_buffer_first #(.FIFO_DEPTH (16),
                                 .FIFO_WIDTH (4),
                                 .DATA_WIDTH (70))
             Fi(
                .clk (clk),
                .rst (rst),
                .din (data_reg3),
                .dout(dout[i]),
                .wr_en(wr_en[i]),
                .rd_en(rd_en[i]),//comes form the output FiFo
                .rok(x_rok[i]),
                .ack(ack[i])
              );
       end 
       
       
    assign x_req=req;
    assign rok_int=(x_rok==0)?1'b0:1'b1;
     //Needs to be updated
    //REDO ATM CAROL
    assign x_dout={dout[4],dout[3],dout[2],dout[1],dout[0]};//(rd_en==0)?{0,0,0,0,0}:
                
    
endmodule