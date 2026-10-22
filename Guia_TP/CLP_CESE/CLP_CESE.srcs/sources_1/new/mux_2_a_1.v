`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 18:03:32
// Design Name: 
// Module Name: mux_2_a_1
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


module mux_2_a_1(
    input a,
    input b,
    input sel,
    output mux
    );

    assign mux = (sel==1'b0)? a:b;    

endmodule
