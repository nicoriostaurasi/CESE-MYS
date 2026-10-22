`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 19:41:46
// Design Name: 
// Module Name: comparador_igual
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


module comparador_igual#(
    parameter N = 4
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output igual
    );
    
    assign igual = (a==b);
    
endmodule
