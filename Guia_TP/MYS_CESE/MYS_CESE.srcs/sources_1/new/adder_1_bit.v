`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 17:31:03
// Design Name: 
// Module Name: adder_1_bit
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


module adder_1_bit(
    input ci,
    input a,
    input b,
    output s,
    output co
    );
        
    assign s = a ^ b ^ ci;
    assign co = (a&b) | (b&ci) | (a&ci);   
    
endmodule
