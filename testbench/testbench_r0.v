`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
/// Company: 
/// Engineer: 
/// 
/// Create Date: 17.07.2017 22:14:20
/// Design Name: 
/// Module Name: testbench_r0
/// Project Name: 
/// Target Devices: 
/// Tool Versions: 
/// Description: 
/// 
/// Dependencies: 
/// 
/// Revision:
/// Revision 0.01 - File Created
/// Additional Comments:
/// 
/////////////////////////////////////////////////////////////////////////////////


module testbench_r0(
   input clk,
   input rst,
   input [7:0]core_status,
      //LOCAL FROM LOCAL PORT
    output reg [63:0] s1_tdata,
    output reg [7:0]  s1_tkeep, 
    output reg        s1_tvalid,     
    input  s1_tready,          
    output reg        s1_tlast,       
    ///TO LOCAL PORT           
    input  [63:0] m1_tdata,    
    input  [7:0]  m1_tkeep,    
    input  m1_tvalid,          
    output  m1_tready,         
    input  m1_tlast, 
    ////
    (* keep = "true" *)output [63:0] rx_axis_tdata_0,
    (* keep = "true" *) output [7:0]  rx_axis_tkeep_0,
    (* keep = "true" *)output       rx_axis_tvalid_0,
    (* keep = "true" *)input      rx_axis_tready_0,
     (* keep = "true" *)output       rx_axis_tlast_0,
     (* keep = "true" *)input [63:0]tx_axis_tdata_0,
     (* keep = "true" *)input [4:0] tx_axis_tkeep_0,
     (* keep = "true" *)input       tx_axis_tvalid_0,
     (* keep = "true" *)output        tx_axis_tready_0,
     (* keep = "true" *)input       tx_axis_tlast_0,
     (* keep = "true" *)output reg [63:0]rx_axis_tdata_1,
     (* keep = "true" *)output reg [7:0] rx_axis_tkeep_1,
     (* keep = "true" *)output reg      rx_axis_tvalid_1,
     (* keep = "true" *)input          rx_axis_tready_1,
     (* keep = "true" *)output reg      rx_axis_tlast_1,
     (* keep = "true" *)input  [63:0]tx_axis_tdata_1,
     (* keep = "true" *)input  [4:0] tx_axis_tkeep_1,
     (* keep = "true" *)input        tx_axis_tvalid_1,
     (* keep = "true" *)output       tx_axis_tready_1,
     (* keep = "true" *)input        tx_axis_tlast_1,
     (* keep = "true" *)output [63:0] rx_axis_tdata_2,
     (* keep = "true" *)output [7:0]  rx_axis_tkeep_2,
     (* keep = "true" *)output        rx_axis_tvalid_2,
     (* keep = "true" *)input         rx_axis_tready_2,
     (* keep = "true" *)output        rx_axis_tlast_2,
     (* keep = "true" *)input   [63:0]tx_axis_tdata_2,
     (* keep = "true" *)input   [4:0] tx_axis_tkeep_2,
     (* keep = "true" *)input         tx_axis_tvalid_2,
     (* keep = "true" *)output        tx_axis_tready_2,
     (* keep = "true" *)input         tx_axis_tlast_2,
     (* keep = "true" *)output [63:0] rx_axis_tdata_3,
     (* keep = "true" *)output [7:0]  rx_axis_tkeep_3,
     (* keep = "true" *)output        rx_axis_tvalid_3,
     (* keep = "true" *)input         rx_axis_tready_3,
     (* keep = "true" *)output        rx_axis_tlast_3,
     (* keep = "true" *)input   [63:0] tx_axis_tdata_3,
     (* keep = "true" *)input   [4:0]  tx_axis_tkeep_3,
     (* keep = "true" *)input          tx_axis_tvalid_3,
     (* keep = "true" *)output         tx_axis_tready_3,
     (* keep = "true" *)input          tx_axis_tlast_3, 
    
    /////
    
    output reg configure,
    output reg [21:0] local_port,
    output reg [63:0] distance,
    output reg [7:0]latency         
   );
    assign m1_tready=1'b1;
    assign tx_axis_tready_0=1'b1;
    assign tx_axis_tready_1=1'b1;
    assign tx_axis_tready_2=1'b1;
    assign tx_axis_tready_3=1'b1;
   //LOGIC WITH THE ROUTER PORT            
            parameter s0=3'b000, sh1=3'b001,sh2=3'b010,sb=3'b011,st1=3'b100, st2=3'b101,s6=3'b110, sr=3'b111;
            reg [2:0] state;
            reg [2:0]next_state;
            reg [7:0]flits_counter,flits_max;
            reg [7:0]ifg_counter,ifg_max;
           
           
            always@(posedge clk) begin
               if(rst==1'b1)begin flits_max=7'h0; end
               else begin if (configure ==1'b1) begin flits_max=8'h0; end 
                           else begin flits_max=flits_max; end 
                        end
            end
            
            always@(posedge clk)
            begin
                if(rst==1'b1) begin flits_counter=8'h0; end
                else begin if (state==s0)begin flits_counter=8'h0; end
                           else begin if(state==sb)begin flits_counter=flits_counter+1; end 
                                      else begin flits_counter=flits_counter; end
                           end
                end
            end 
            
             always@(posedge clk) begin
                if(rst==1'b1)begin ifg_max=8'h0; end
                else begin if (configure ==1'b1) begin ifg_max=8'h0; end 
                            else begin ifg_max=ifg_max; end 
                         end
             end
             
             always@(posedge clk)
             begin
                 if(rst==1'b1) begin ifg_counter=8'h0; end
                 else begin if (state==sr)begin ifg_counter=8'h0; end
                            else begin if(state==s0)begin ifg_counter=ifg_counter+1; end 
                                       else begin ifg_counter=ifg_counter; end
                            end
                 end
             end 

                       
              always@(state,rst,flits_counter,ifg_counter,core_status)
                   begin : fsm_combo
                   case (state)
                     sr: if (rst==1'b0 && core_status[0]==1'b1) begin next_state=s0; end else begin next_state=sr; end
                     s0: if( ifg_counter==ifg_max) begin
                           next_state=s6;
                         end
                         else begin next_state=s0; end
                     sh1:next_state=sh2;
                     sh2:next_state=st1;
                     sb:if (flits_counter==flits_max)next_state=st1; else next_state=sb; 
                     st1:next_state=st2;
                     st2:next_state=sr;
                     s6:next_state=sh1;
                     default: next_state=sr;
                    endcase
                   end
                   
                   always @(posedge clk)
                   begin: fsm_seg
                       if(rst==1'b1) begin
                          state<=#1 sr;
                       end else begin
                          state<=#1 next_state;
                       end
                   end
                   
                   always@(posedge clk)
                   begin: output_logic
                   if (rst==1'b1) begin
                       s1_tdata=63'h0; 
                       s1_tkeep=8'b0; 
                       s1_tvalid=1'b0;
                       s1_tlast=1'b0;
                       configure=1'b0;
                       local_port= 22'h14404;
                       distance= 64'h1010;
                       rx_axis_tdata_1 =0;
                       rx_axis_tkeep_1 =0;
                       rx_axis_tvalid_1=0;
                       rx_axis_tlast_1 =0;
                 end
                   else begin
                     case (state)
                       sr: begin 
                              s1_tdata=64'h0; 
                              s1_tkeep=8'h0; 
                              s1_tvalid=1'b0;
                              s1_tlast=1'b0;
                              configure=1'b0;
                              local_port= 22'h14404;
                              distance= 64'h1010;
                              rx_axis_tdata_1 =0; 
                              rx_axis_tkeep_1 =0; 
                              rx_axis_tvalid_1=0; 
                              rx_axis_tlast_1 =0; 
                       end
                       s0: begin 
                            s1_tdata=64'h0; 
                            s1_tkeep=8'h0; 
                            s1_tvalid=1'b0;
                            s1_tlast=1'b0;
                            configure=1'b0;
                            rx_axis_tdata_1 =0; 
                            rx_axis_tkeep_1 =0; 
                            rx_axis_tvalid_1=0; 
                            rx_axis_tlast_1 =0; 
                       end
                       sh1:begin   
                            s1_tdata=64'h0064002900a00000; 
                            s1_tkeep=8'h08; 
                            s1_tvalid=1'b1;
                            s1_tlast=1'b0; 
                            configure=1'b0; 
                            rx_axis_tdata_1 =64'h0064002880600000; 
                            rx_axis_tkeep_1 =8'b1000; 
                            rx_axis_tvalid_1=1'b1; 
                            rx_axis_tlast_1 =1'b0; 
                           end
                       sh2: begin
                              s1_tdata=64'h000000000000000a; 
                              s1_tkeep=8'h08; 
                              s1_tvalid=1'b1;
                              s1_tlast=1'b0;
                              configure=1'b0; 
                              rx_axis_tdata_1 =64'h0000000000000000; 
                              rx_axis_tkeep_1 =8'b1000; 
                              rx_axis_tvalid_1=1'b1; 
                              rx_axis_tlast_1 =1'b0; 
                             end
                       sb: begin s1_tdata={55'h0,flits_counter}; 
                                 s1_tkeep=8'h08; 
                                 s1_tvalid=1'b1;
                                 s1_tlast=1'b0;
                                 configure=1'b0; 
                                 rx_axis_tdata_1 ={55'h0,flits_counter};  
                                 rx_axis_tkeep_1 =8'b1000;               
                                 rx_axis_tvalid_1=1'b1;                  
                                 rx_axis_tlast_1 =1'b0;                  
                            end
                       st1:begin s1_tdata=64'haaaaaaaaaaaaaaaa; 
                                s1_tkeep=8'h08; 
                                s1_tvalid=1'b1;
                                s1_tlast=1'b0;
                                configure=1'b0; 
                                rx_axis_tdata_1 =64'hbbbbaaaaaaaaaaaa;  
                                rx_axis_tkeep_1 =8'b1000;               
                                rx_axis_tvalid_1=1'b1;                  
                                rx_axis_tlast_1 =1'b0;  
                                
                                
                           end
                        st2:begin s1_tdata=64'hffffffffffffffff; 
                             s1_tkeep=8'h08; 
                             s1_tvalid=1'b1;
                             s1_tlast=1'b1;
                             configure=1'b0; 
                            rx_axis_tdata_1 =64'hffffaaaaaaaaaaaa;    
                            rx_axis_tkeep_1 =8'b1000;                 
                            rx_axis_tvalid_1=1'b1;                    
                            rx_axis_tlast_1 =1'b1;                    
                        end
                        s6:begin s1_tdata=64'h00000000000000000; 
                                    s1_tkeep=8'h00; 
                                    s1_tvalid=1'b0;
                                    s1_tlast=1'b0;
                                    configure=1'b1;
                                    rx_axis_tdata_1 =64'h00000000000000000;   
                                    rx_axis_tkeep_1 =8'b0000;                
                                    rx_axis_tvalid_1=1'b0;                   
                                    rx_axis_tlast_1 =1'b0;                   
                                    end
                       default : begin  s1_tdata=64'h00000000000000000; 
                                        s1_tkeep=8'h00; 
                                        s1_tvalid=1'b0;
                                        s1_tlast=1'b0;
                                        configure=1'b0; 
                                        rx_axis_tdata_1 =0; 
                                        rx_axis_tkeep_1 =0; 
                                        rx_axis_tvalid_1=0; 
                                        rx_axis_tlast_1 =0; 
                                 end
                       endcase
                     end
                    end
                    
                  always@(posedge clk)begin
                    if (rst==1'b1) begin
                        latency=7'h0;
                    end else begin 
                        if(m1_tvalid==1'b1 && m1_tdata==64'b0) begin latency=latency; end else begin latency=latency+1'b1;end
                    end
                  end  
                    
            
            
endmodule