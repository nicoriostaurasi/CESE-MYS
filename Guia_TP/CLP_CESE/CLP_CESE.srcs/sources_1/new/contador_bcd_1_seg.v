`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 22:15:26
// Design Name: 
// Module Name: contador_bcd_1_seg
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


module contador_bcd_1_seg#(
    parameter SYS_CLK = 100000000
)(
    input ena,
    input rst,
    input clk,
    output [3:0] q
    );
    wire pulso_1s, ena_bcd;
    
    contador_N_clk #(.N(SYS_CLK)) generador_1s_instance(
        .rst(rst),
        .clk(clk),
        .s(pulso_1s)  
    );
    
    contador_bcd contador_bcd_instance(
        .ena(ena_bcd),
        .rst(rst),
        .clk(clk),
        .q(q),
        .co(open)
    );
    

endmodule
