`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2017 15:23:13
// Design Name: 
// Module Name: router2local
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


module router2local#(DATA_WIDTH = 70)
   (
    input clk,
    input rst,
    (*mark_debug="true"*)input [DATA_WIDTH-1:0] data_router,
    (*mark_debug="true"*)input  val,
    (*mark_debug="true"*)output reg ack,
    (*mark_debug="true"*)output reg [63:0] tdata,
    (*mark_debug="true"*)output reg [7:0] tkeep,
    (*mark_debug="true"*)output  tvalid,
    (*mark_debug="true"*)input  tready,
    (*mark_debug="true"*)output reg tlast
  );
  
  
        parameter s0=3'b000, s1=3'b001,s2=3'b010, s0a=3'b011, s0b=3'b100,s0c=3'b101,s0d=3'b110;
        (*mark_debug="true"*)reg [2:0] state;
        (*mark_debug="true"*)reg [2:0]next_state;
        reg [63:0] tdata_int;
        reg tlast_int;
        reg tkeep_int;
        wire tvalid_int;
        (*mark_debug="true"*)reg val_4,val_3,val_2,val_1;
        
        //register to delay the valid in 4 clock cycles
        always@(posedge clk)
        begin
          if(rst==1'b1) begin
            val_4=1'b0;
            val_3=1'b0;
            val_2=1'b0;
            val_1=1'b0;
          end else begin
            val_4=val_3;
            val_3=val_2;
            val_2=val_1;
            val_1=val;
          end
          
        end
        
        always@(state or val or data_router[69:68])
        begin : fsm_combo
        case (state)
          s0: if(val==1'b1 && rst==1'b0) begin
                next_state=s0a;
              end
              else begin next_state=s0; end
          s0a: if(data_router[69]==1'b1) begin
                   next_state=s1;
                end else begin
                  next_state=s0a;
                end
          s1: if (data_router[68]==1'b1) begin next_state=s2; end  
              else begin next_state=s1; end
          s2: next_state=s0;
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
        
        always@(posedge clk)
        begin: output_logic
        if (rst==1'b1) begin
        // tdata=64'h0000000000000000;
         tdata_int= 64'h0000000000000000; 
         tkeep=8'b00000000; 
         //tkeep_int=8'b00000000;
         //tvalid_int=1'b0;
        // tvalid=1'b0;
        // tlast=1'b0; 
         ack = 1'b0;
        end
        else begin
          case (state)
            s0: begin 
                   //tdata=tdata_int;
                   tdata= 64'h0000000000000000; 
                   //tkeep=tkeep_int; 
                   tkeep=8'b00000000;
                   //tvalid_int=tvalid;
                  //  tvalid=1'b0;
                    tlast=1'b0; 
                   ack = 1'b1;
                end
             s0a: begin  
                         //tdata=tdata_int;
                 tdata= data_router[67:4];   //64+4(valid_mac)+2(bop)=69 -2(bop)=67-64=3
                 //tkeep=tkeep_int;
                 tkeep={4'b0000,data_router[3:0]};
                 //tvalid_int=tvalid;
                // tvalid=1'b1;
                 tlast=data_router[68];              
                 ack= 1'b1;                      
                  end
            s1: begin  
                    //tdata=tdata_int;
                    tdata= data_router[67:4];   //64+4(valid_mac)+2(bop)=69 -2(bop)=67-64=3
                    //tkeep=tkeep_int;
                    tkeep={4'b0000,data_router[3:0]};
                    //tvalid_int=tvalid;
                  //  tvalid=1'b1;
                    tlast=data_router[68];              
                    ack= 1'b1;                      
                end
            s2:begin
                   // tdata=tdata_int;
                    tdata= 64'h0000000000000000; 
                   // tkeep=tkeep_int; 
                    tkeep=8'b00000000;
                    //tvalid_int=tvalid;
                     tlast=1'b0;
                   // tlast=1'b1; 
                    ack = 1'b1;
               end
            default : begin  
                  //  tdata=tdata_int;
                    tdata= 64'h0000000000000000;
                    //tkeep=tkeep_int;    
                    tkeep=8'b00000000;
                    //tvalid_int=tvalid;
                   //  tvalid=1'b0; 
                    tlast=1'b0;                
                    ack = 1'b1;                        
              end
            endcase
          end
         end
        
       //assign tlast= (state==s2)? 1'b1:1'b0; 
       assign tvalid=(state==s1||state==s2)? 1'b1:1'b0;//(val_3==1'b1 && tkeep!=8'b0)? 1'b1:1'b0; //state==s1 ||
     //  assign tdata = (state==s1)? data_router[68:4]: 64'h0000000000000000;
      // assign tkeep= (state==s1)?{4'b000,data_router[3:0]}:8'b0
     
        
      
    
    
endmodule
