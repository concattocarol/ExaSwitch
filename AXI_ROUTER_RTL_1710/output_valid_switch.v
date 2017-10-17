`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2016 12:29:59
// Design Name: 
// Module Name: output_valid_switch
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


module output_valid_switch#(parameter NUMBER_CHANNELS=5)(
    input [NUMBER_CHANNELS-1:0] gnt,
    input [NUMBER_CHANNELS-1:0] rok,
    input [NUMBER_CHANNELS-1:0] sel,
    output val
    );
    
    wire [NUMBER_CHANNELS-1:0] val_int;
   
    assign val_int=(sel==0)?0:rok&gnt;
 
    assign val=(val_int==0)?0:1;
     
endmodule
