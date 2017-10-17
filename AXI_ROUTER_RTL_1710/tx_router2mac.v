`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2017 15:59:12
// Design Name: 
// Module Name: tx_router2mac
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


module tx_router2mac#(DATA_WIDTH=70)
   (
    input clk,
    input rst,
    input [DATA_WIDTH-1:0]data_router,
    input  val,
    output reg ack,
    output reg [63:0]data_mac,
    output reg [3:0]valid_mac
    );
    
    parameter s0=2'b00, s1=2'b10,s0a=2'b01;
        reg [1:0] state;
        reg [1:0]next_state;
        reg [64:0] data_mac_int;
        reg [3:0]valid_mac_int;
        reg ack_int;
        
        always@(state or val or data_router[69:68])
        begin : fsm_combo
        case (state)
          s0: if(val!=1'b0 && rst==1'b0) begin
                next_state=s0a;
              end
              else begin next_state=s0; end
          s0a: if(data_router[69]==1'b1) next_state=s1; else next_state=s0a;
          s1: if (data_router[68]==1'b0 && val==1'b1) begin next_state=s1; end
              else begin next_state=s0; end
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
            data_mac= 64'h0000000000000000;   
            valid_mac=4'b0000;                
            ack = 1'b0;                       
        end
        else begin
          case (state)
            s0: begin data_mac= 64'h0000000000000000;  
                      valid_mac=4'b0000;
                      ack = 1'b0;
                end
            s0a: begin
                data_mac= data_router[67:4];   //64+4(valid_mac)+2(bop)=69 -2(bop)=67-64=3
                valid_mac=data_router[3:0];              
                ack = 1'b1;  
                end
            s1: begin  data_mac= data_router[67:4];   //64+4(valid_mac)+2(bop)=69 -2(bop)=67-64=3
                       valid_mac=data_router[3:0];              
                       ack = 1'b1;                      
                end
            default : begin  data_mac= 64'h0000000000000000;    
                             valid_mac=4'b0000;                 
                             ack = 1'b0;                        
                      end
            endcase
          end
         end
        
    

    
    
endmodule
