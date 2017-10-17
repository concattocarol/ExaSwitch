`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2016 11:34:44
// Design Name: 
// Module Name: outpput_controller
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
// Still problem when more than 2 channels keep asking for the output channel
//////////////////////////////////////////////////////////////////////////////////


	
module output_controller#(
    parameter NUMBER_CHANNELS=5           //Number of channels in the switch
)(
   input  rst,
   input  clk,
   input  ack,
   input  eop,
   input  [NUMBER_CHANNELS-1:0] req_channel,
   output [NUMBER_CHANNELS-1:0] gnt_channel,
   output [NUMBER_CHANNELS-1:0] sel_channel,
   output idle
    );
    
    //--------------------------
    //--  Parameters Declaration
    //-------------------------- 


    parameter GNT_NONE =0000000000000000;
    parameter ZERO= 0000000000000000;
      
    
    wire req_present;

    reg  [NUMBER_CHANNELS-1:0] gnt_reg;
    reg  [NUMBER_CHANNELS-1:0] sel_reg;
    
   
    //-------------Internal Constants--------------------------
     parameter SIZE = 3;
     parameter S_IDLE= 3'b000, S_ARB = 3'b001, S_WAIT_EOP= 3'b010, S_WAIT_LAST_ACK= 3'b011, S1=3'b100;
     //-------------Internal Variables---------------------------
     reg   [SIZE-1:0]          state_reg;    // Seq part of the FSM
     reg   [SIZE-1:0]          nxt_state;    // combo part of FSM
    
        
    //-------------------
    // Detects if there is any req
    //-------------
    assign req_present = (req_channel==0)? 0:1;
    reg [NUMBER_CHANNELS-1:0] grant_q;
    reg [NUMBER_CHANNELS-1:0] pre_req;
    wire [NUMBER_CHANNELS-1:0] mask_pre;
    wire [NUMBER_CHANNELS-1:0] sel_gnt,nxt_gnt,nxt_sel,grant_channel;
    wire [NUMBER_CHANNELS-1:0] isol_lsb;
    wire [NUMBER_CHANNELS-1:0] win;
    
    assign grant_channel     = grant_q;
    assign mask_pre          = req_channel & ~((pre_req- 1) || pre_req);        // Mask off previous winners
    assign sel_gnt           = mask_pre & (~(mask_pre) + 1);                   //Select new winner
    assign isol_lsb          = req_channel & (~(req_channel) + 1);             // Isolate least significant set bit.
    assign  win              = isol_lsb;
    
    
    
   //----------
   always @ (state_reg,eop,ack,req_present)
   begin: p_nxt_state
    case(state_reg)
               S_IDLE:
                  if(rst==1'b1) begin 
                    nxt_state <= S_IDLE;
                  end
                  else begin
                   if (req_present>0) begin
                       nxt_state <= S_ARB;
                  end else begin
                       nxt_state <= S_IDLE;
                 end
                end
            // S1: nxt_state<=S_ARB;
             S_ARB : nxt_state <= S_WAIT_EOP;
             //S1: nxt_state<= S_WAIT_EOP;
             S_WAIT_EOP :
                   if (eop == 1 && ack == 1) begin
                       nxt_state <= S_IDLE;
                   end else begin
                       if (eop == 1 && ack == 0) begin
                           nxt_state <= S_WAIT_LAST_ACK;
                       end else begin
                           nxt_state <= S_WAIT_EOP;
                       end
                   end
   
             S_WAIT_LAST_ACK :
                   if (ack == 1) begin
                       nxt_state <= S_IDLE;
                   end else begin
                       nxt_state <= S_WAIT_LAST_ACK;
                  end
              endcase
       end
   
//-----------    
//SEQUENCIAL SECTIONS   
//--------

    always @ (posedge clk)
    begin: p_state_reg
        if (rst == 1) begin
                state_reg <= S_IDLE;
          end else begin
                state_reg <= nxt_state;
        end 
    end

     always @ (posedge clk)
     begin:   p_gnt_reg
           if (rst == 1) begin
                gnt_reg <= GNT_NONE;
            end else begin
               if (state_reg == S_ARB && req_present) begin
                   gnt_reg <= win;
               end
               else begin 
                  // if(state_reg == S_IDLE)gnt_reg=0; 
                  // else 
                  gnt_reg<=gnt_reg;
                  end
             end
        end
    

    always @ (posedge clk)
    begin: p_sel_reg
      if(rst ==1) begin
           sel_reg = ZERO;
      end else begin
           if(state_reg == S_ARB && req_present) begin
           sel_reg=win;
          end
          else begin 
               //if((state_reg == S_IDLE)) sel_reg=0; 
              // else 
              sel_reg<=sel_reg;
          end
       end
     end
    
    
   always@ (posedge clk)
         begin
         if (rst ==1'b1) begin
             pre_req = 0;
             grant_q = 0;
        end else begin
             if (grant_q == 0) begin 
                 if (win != 0) begin
                     pre_req = win;
                 end
                 grant_q = win;
             end
         end
      end
      
      assign nxt_gnt= win;
      assign nxt_sel=nxt_gnt;
    
    //--+--+--+--+--+--+-
    //-- OUTPUT SECTION -
    //--+--+--+--+--+--+-
   
       assign idle = (state_reg==S_IDLE) ? 1 :0;
                    // (state_reg==S_ARB) ? 1:0;
        
      assign sel_channel  = (state_reg == S_IDLE)? 0:sel_reg;//||state_reg == S_ARB
      assign gnt_channel  = (state_reg == S_IDLE)? 0:gnt_reg;  // ||state_reg == S_ARB
      
      
    
    
    
    
endmodule