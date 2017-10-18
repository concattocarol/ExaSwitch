`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2017 06:55:34
// Design Name: 
// Module Name: local2router_v2
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


module local2router#( DATA_WIDTH=70)(
   input clk,
   input rst,
   //ROUTER INTERFACE (output)   
   (*mark_debug="true"*)output  [DATA_WIDTH-1:0] data_router, 
   output  val,
   input  ack,
   //LOCAL PORT INTERFACE 
   input [63:0]tdata,
   input [7:0] tkeep,
   input tvalid,
   output tready,
   input tlast
   );

//FIFO SIGNALS INTERFACE 
    wire  rd_int;
    wire rok_int;
    wire ack_int;
    wire [DATA_WIDTH-1:0] data_fifo;
   (*mark_debug="true"*) reg [14:0] packet_size,packet_counter;
   (*mark_debug="true"*)reg packet_finish_1,packet_finish;
    
    //LOGIC WITH THE LOCAL PORT
    //RECEIVE FLITS AND STORE IN THE FIFO.
     input_buffer_first #(.FIFO_DEPTH (16),
                          .FIFO_WIDTH (4),
                           .DATA_WIDTH (70))
                FIFO(
                   .clk (clk),
                   .rst (rst),
                   .din ({tvalid,tlast,tdata,tkeep[3:0]}),
                   .dout(data_fifo),
                   .wr_en(tvalid),
                   .rd_en(rd_int),//comes form the output FiFo
                   .rok(rok_int),
                   .ack(ack_int)
                 );
                 
     //LOGIC WITH THE ROUTER PORT            
         parameter s0=3'b000, s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100, s5=3'b101,s1A=3'b110;
         reg [2:0] state;
         reg [2:0]next_state;
         reg [DATA_WIDTH-1:0] data_router_int;
         reg  val_int;
         reg wr_flag;
         wire tvalid_int,tlast_int;
         reg tvalid_1,tvalid_2;
         assign tvalid_int=data_fifo[69];
         assign tlast_int=data_fifo[68];
         
         always@(posedge clk) begin
            if (rst==1'b1) wr_flag=1'b0;
            else begin
                 if  (tvalid==1'b1 && tvalid_1==1'b0) begin 
                       if(tdata[47:43]==5'b00000 || tdata[47:43]==5'b00011) begin wr_flag=1'b1; end else begin wr_flag=1'b0;end            
                end else begin
                    wr_flag=wr_flag;
                end
            end
        end  
           
         always@(posedge clk)begin
            if(rst==1'b1) begin tvalid_2=1'b0; tvalid_1=1'b0; end
            else begin tvalid_2=tvalid_1; tvalid_1=tvalid; end
         end
          //register that cotains the number of flits
         always@(posedge clk)
         begin
          if(rst==1'b1) begin
           packet_size=14'b11111111111111;
          end else begin
            if(tvalid_2==1'b0 && tvalid==1'b1) begin 
                if(tdata[47:43]==5'b00000 || tdata[47:43]==5'b00011) begin
                 packet_size=14'd4;
                end else begin
                 packet_size=tdata[61:48]+14'd5;
                end
            end else begin
               packet_size=packet_size;
            end
          end
         end
         
         //counting size of packets
         always@(posedge clk) begin
           if(rst==1'b1) begin
            packet_counter=14'b0;
           end else begin
             if(state==s1A) begin
               packet_counter=packet_size;
             end else if (state==s1|| state==s2 || state==s3) begin
               packet_counter=packet_counter-1'b1;
             end
             else packet_counter=14'b0;
           end
         end
         //register the end pf the packet
         always@(posedge clk)
         begin
          if(rst==1'b1) begin  packet_finish=packet_finish_1; packet_finish_1=1'b0; end
          else begin
          if(state==s3)begin packet_finish=packet_finish_1; packet_finish_1=1'b0; end 
           else begin 
               if (packet_counter==14'b00000000000011) begin
                   packet_finish=packet_finish_1; packet_finish_1=1'b1;
               end else begin packet_finish=packet_finish_1; packet_finish_1=1'b0; end
         end
        end
       end
         
         always@(state, tvalid,ack,rst,packet_finish_1)
         begin : fsm_combo
         case (state)
           s0: if(tvalid==1'b1 && rst==1'b0) begin
                 next_state=s1A;
               end
               else begin next_state=s0; end
           s1A: next_state=s1;
           s1: next_state=s2; 
           s2: if(packet_finish_1==1'b1) begin 
                       next_state=s3;
                end else begin 
                    if (wr_flag==1'b1) next_state=s3; else if (ack==1'b1)   next_state=s2; //else if not fifo space
                 end
            s3:  next_state=s4;
            s4:  next_state=s0;
            default: next_state=s0;
          endcase
         end
         
         always @(posedge clk)
         begin: fsm_seg
             if(rst==1'b1) begin
                state<=#1 s0;
             end else begin
                state<=#1 next_state;
             end
         end
         
//         always@(posedge clk)
//         begin: output_logic
//         if (rst==1'b1) begin
//             data_router= {DATA_WIDTH{1'b0}};
//             data_router_int= {DATA_WIDTH{1'b0}}; 
//             val=1'b0; 
//            // val_int=1'b0;
           
//         end
//         else begin
//           case (state)
//             s0: begin 
//                       //data_router=data_router_int;
//                       data_router= {DATA_WIDTH{1'b0}}; 
//                       val=1'b0; 
//                       //val_int=1'b0;
//                       end
//              s1A:begin   
//                     //  data_router=data_router_int;
//                     data_router=  {DATA_WIDTH{1'b0}}; 
//               end
//             s1:begin   
//                     //  data_router=data_router_int;
//                       data_router=  {2'b10,data_fifo[67:0]};
//                       val=1'b1;  
//                    end
//             s2: begin// data_router=data_router_int;
//                       data_router= {2'b00,data_fifo[67:0]}; 
//                        val=1'b1; 
//                     //  val_int=1'b1;
//                   end
//             s3: begin //data_router=data_router_int;
//                       data_router= {2'b01,data_fifo[67:0]}; 
//                        val=1'b1; 
//                      // val_int=1'b1;
//                  end
//             default : begin  //data_router=data_router_int;
//                              data_router= {DATA_WIDTH{1'b0}}; 
//                              val=1'b0; 
//                              //val_int=1'b0;
//                       end
//             endcase
//           end
//          end
          
   
     assign data_router= (state==s1)?{1'b1,data_fifo[68:0]}:
                         (state==s2)?{1'b0,data_fifo[68:0]}:
                         (state==s3)?{1'b0,data_fifo[68:0]}:
                         (state==s4)?{1'b0,data_fifo[68:0]}:
                         {DATA_WIDTH{1'b0}};
                           
     assign rd_int = (state==s1A)?1'b1:
                     (state==s1)?1'b1:
                     (state==s2)?1'b1:
                     (state==s3)?1'b1:1'b0; 
                     
   assign val =    (state==s1)?1'b1:
                   (state==s2)?1'b1:
                   (state==s3)?1'b1:
                   (state==s4)?1'b1:
                    1'b0; 
                     
       
    //combinational output
     assign tready=1'b1;


endmodule
