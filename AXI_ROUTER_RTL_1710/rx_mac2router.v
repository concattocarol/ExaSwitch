`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2017 13:44:21
// Design Name: 
// Module Name: rx_mac2router
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


module rx_mac2router#( DATA_WIDTH=70)(
    input clk,
    input rst,
    input [63:0] data_mac,
    input [3:0]  valid_mac,
    input crc_mac,
    input transmission_done_mac,
    
    output  reg [DATA_WIDTH-1:0] data_router,
    output  reg val,
    input ack 
    );
     //FIFO SIGNALS INTERFACE 
       wire  rd_int;
       wire rok_int;
       wire ack_int;
       wire [DATA_WIDTH-1:0] data_fifo;
       wire wr_int;
      reg [14:0] packet_size,packet_counter;
      reg packet_finish_1,packet_finish;
      reg [3:0] valid_mac1,valid_mac4,valid_mac3,valid_mac2;
      parameter s0=3'b000, s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100, s5=3'b101,s1A=3'b110;
                  reg [2:0] state;
                  reg [2:0]next_state;
                  wire [DATA_WIDTH-1:0] data_router_int;
                  wire val_int;
                  wire tvalid_int,tlast_int;
       assign wr_int= (valid_mac==4'b0000)?1'b0:1'b1;
       
       //LOGIC WITH THE LOCAL PORT
       //RECEIVE FLITS AND STORE IN THE FIFO.
        input_buffer_first #(.FIFO_DEPTH (16),
                             .FIFO_WIDTH (4),
                              .DATA_WIDTH (70))
                   FIFO(
                      .clk (clk),
                      .rst (rst),
                      .din ({1'b0,1'b0,data_mac,valid_mac}),
                      .dout(data_fifo),
                      .wr_en(wr_int),
                      .rd_en(rd_int),//comes form the output FiFo
                      .rok(rok_int),
                      .ack(ack_int)
                    );
          
          //register that cotains the number of flits
          always@(posedge clk)
          begin
           if(rst==1'b1) begin
            packet_size=14'b11111111111111;
           end else begin
             if(valid_mac1==4'b0 && valid_mac!=4'b0) begin 
                packet_size=data_mac[61:48];
                if(data_mac[47:43]==5'b00000 || data_mac[47:43]==5'b00011) begin
                   packet_size=14'd4;
                  end else begin
                   packet_size=data_mac[61:48]+14'd5; //Check if the header flits and tails flits are included in the size
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
                if (packet_counter==14'b00000000000010) begin
                    packet_finish=packet_finish_1; packet_finish_1=1'b1;
                end else begin packet_finish=packet_finish_1; packet_finish_1=1'b0; end
          end
         end
        end
           
                    
        //LOGIC WITH THE ROUTER PORT            
           
            always@(posedge clk)begin
                if(rst==1'b1) begin 
                 valid_mac4=4'b0;
                 valid_mac3=4'b0;
                 valid_mac2=4'b0;
                 valid_mac1=4'b0;
                end else begin
                  valid_mac4=valid_mac3;
                  valid_mac3=valid_mac2;
                  valid_mac2=valid_mac1;
                  valid_mac1=valid_mac;
                
                end
            end
            
            assign tvalid_int=data_fifo[69];
            assign tlast_int=data_fifo[68];
            
            always@(state, wr_int, rst, ack, packet_finish_1)
            begin : fsm_combo
            case (state)
              s0: if(wr_int==1'b1 && rst==1'b0) begin
                    next_state=s1A;
                  end
                  else begin next_state=s0; end
              s1A:next_state=s1;
              s1:if (ack==1'b1) begin next_state=s2; end
                  else begin next_state=s1; end
                
              s2: if(packet_finish_1==1'b1) begin //
                          next_state=s3;
                   end else begin 
                       next_state=s2;
                    end
               s3:  next_state=s0;
               s4:  next_state=s0;
               s5:  next_state=s0;
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
               // data_router= {DATA_WIDTH{1'b0}};
              //  data_router_int= {DATA_WIDTH{1'b0}}; 
              //  val=val_int; 
                val=1'b0;
              
            end
            else begin
              case (state)
                s0: begin 
                          //data_router=data_router_int;
                         // data_router_int= {DATA_WIDTH{1'b0}}; 
                          //val=val_int; 
                          //val_int=1'b0;
                          end
                s1A:begin   
                           //data_router=data_router_int;
                         // data_router_int=  {2'b00,data_fifo[67:0]}; 
                          val=val_int;
                    end
                s1:begin   
                        //  data_router=data_router_int;
                         // data_router_int=  {2'b00,data_fifo[67:0]}; 
                          val=val_int;
                       end
                s2: begin// data_router=data_router_int;
                         // data_router_int= {2'b00,data_fifo[67:0]}; 
                         val=val_int; 
                        //  val_int=1'b1;
                      end
                s3: begin //data_router=data_router_int;
                        //  data_router_int= {2'b01,data_fifo[67:0]}; 
                          val=val_int; 
                         // val_int=1'b1;
                     end
               // s4:begin //data_router=data_router_int;
                //         data_router= {2'b01,data_fifo[67:0]}; 
                        // val=val_int; 
                        // val_int=1'b1;
                  //  end
                default : begin // data_router=data_router_int;
                              //   data_router_int= {DATA_WIDTH{1'b0}}; 
                                 val=val_int; 
                                 //val_int=1'b0;
                          end
                endcase
              end
             end
             
        assign rd_int = (state==s1A)?1'b1:
                        (state==s1)?1'b1:
                        (state==s2)?1'b1:
                        (state==s3)?1'b0:
                        (state==s5)?1'b0:1'b0; 
                        
       assign val_int =  (state==s1A)?1'b1:
                        (state==s1)?1'b1:
                        (state==s2)?1'b1:
                        (state==s3)?1'b1:
                       // (state==s4)?1'b1:
                        (state==s5)?1'b1:1'b0; 
                        
       assign data_router_int=(state==s1)?{2'b10,data_fifo[67:0]}: 
                           (state==s2)?{2'b00,data_fifo[67:0]}:
                            (state==s3)?{2'b01,data_fifo[67:0]}:{DATA_WIDTH{1'b0}};   
       //register the output
       always@(posedge clk)
        begin
          if(rst==1'b1) begin  data_router={DATA_WIDTH{1'b0}};end
          else begin data_router=data_router_int; end
        end
                            
       
    /*parameter s0=2'b00, s1=2'b01,s2=2'b10,s3=2'b11;
    reg [1:0] state;
    reg [1:0]next_state;
    reg [DATA_WIDTH-1:0] data_router_int;
    reg val_int,en_reg1_data;
    reg [68-1:0]reg_data;
    reg [68-1:0]reg1_data;
    
    always@(state or valid_mac or rst or ack)
    begin : fsm_combo
    case (state)
      s0: if(valid_mac==4'b1000 && rst==1'b0) begin
            next_state=s1;
          end
          else begin next_state=s0; end
      s1: if (ack==1'b1) begin next_state=s2; end
          else begin next_state=s1; end
      s2: if(valid_mac!=4'b1000 &&valid_mac!=4'b0000) begin 
                  next_state=s3;
           end else begin 
               next_state=s2;
            end
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
    end
    else begin
      case (state)
        s0: begin data_router_int= 0;  
                  val_int=1'b0;
                  en_reg1_data=1'b1;
            end
        s1: begin data_router_int= {2'b10,reg1_data}; 
                  val_int=1'b1;
                  en_reg1_data=1'b0;
            end
        s2: begin data_router_int= {2'b00,reg_data}; 
                  val_int=1'b1;
                  en_reg1_data=1'b0;
            end
        s3: begin data_router_int= {2'b01,reg_data}; 
                  val_int=1'b1;
                  en_reg1_data=1'b0;
            end
        default : begin  data_router_int= 0;  
                   val_int=1'b0;
                   en_reg1_data=1'b0;
                  end
        endcase
      end
     end
     
     //DATA REGISTER
     always@(posedge clk)
     begin: data_regsiter
     if (rst==1'b1) begin
         reg_data=68'h0000000000000000;
     end else begin
         reg_data= {data_mac,valid_mac};
      end
    end 
    assign val=val_int;
    assign data_router=data_router_int;
    
       //DATA REGISTER
    always@(posedge clk)
    begin: data_regsiter1
    if (rst==1'b1) begin
        reg1_data=68'h0000000000000000;
    end else begin
        if (en_reg1_data==1'b1) begin
        reg1_data= {data_mac,valid_mac};
        end
     end
   end 
   assign val=val_int;
   assign data_router=data_router_int;
  */
        
endmodule
