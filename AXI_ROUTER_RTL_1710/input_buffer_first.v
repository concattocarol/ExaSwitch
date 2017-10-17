`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2016 10:36:46
// Design Name: 
// Module Name: input_buffer_first
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


module input_buffer_first #(FIFO_DEPTH =16,
                            FIFO_WIDTH= 4, //NUMBER OF BIT USED IN THE POINTER
                            DATA_WIDTH =70)
   (
        input clk,
        input rst,
        input  [DATA_WIDTH-1:0]din,
        output [DATA_WIDTH-1:0]dout,
        input wr_en,
        input rd_en,
        output rok,
        output ack
    );
    
                   
// port to output the data using pop.    
//output                buf_empty, buf_full;          
// buffer empty and full indication     
//output[`BUF_WIDTH :0] fifo_counter;                 
// number of data pushed in to buffer       

(* mark_debug = "false" *) reg [DATA_WIDTH-1:0]    buf_out;
(* mark_debug = "false" *)reg                     buf_empty, buf_full;
reg [FIFO_WIDTH :0]     fifo_counter;
(* mark_debug = "false" *)reg [FIFO_WIDTH -1:0]   rd_ptr, wr_ptr;           // pointer to read and write addresses  
reg [DATA_WIDTH-1:0]    buf_mem[FIFO_DEPTH -1 : 0]; //  

always @(fifo_counter)
begin
   buf_empty = (fifo_counter==0);
   buf_full = (fifo_counter== FIFO_DEPTH);

end
assign rok=(buf_empty)?1'b0:1'b1;
assign ack= (wr_en && !buf_full)?1'b1:1'b0;

always @(posedge clk)
begin
   if( rst )
       fifo_counter <= 0;

   else if( (!buf_full && wr_en) && ( !buf_empty && rd_en ) )
       fifo_counter <= fifo_counter;

   else if( !buf_full && wr_en )
       fifo_counter <= fifo_counter + 1;

   else if( !buf_empty && rd_en )
       fifo_counter <= fifo_counter - 1;
   else
      fifo_counter <= fifo_counter;
end

always @( posedge clk)
begin
   if( rst )
      buf_out <= 0;
   else
   begin
      if( rd_en && !buf_empty )
         buf_out <= buf_mem[rd_ptr];

      else
         buf_out <= buf_out;

   end
end
 assign dout=buf_out;

always @(posedge clk)
begin

   if( wr_en && !buf_full )
      buf_mem[ wr_ptr ] <= din;

   else
      buf_mem[ wr_ptr ] <= buf_mem[ wr_ptr ];
end

always@(posedge clk)
begin
   if( rst )
   begin
      wr_ptr <= 0;
      rd_ptr <= 0;
   end
   else
   begin
      if( !buf_full && wr_en )    wr_ptr <= wr_ptr + 1;
          else  wr_ptr <= wr_ptr;

      if( !buf_empty && rd_en )   rd_ptr <= rd_ptr + 1;
      else rd_ptr <= rd_ptr;
   end

end
endmodule