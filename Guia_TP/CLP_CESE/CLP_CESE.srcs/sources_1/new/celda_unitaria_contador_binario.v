`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 18:59:07
// Design Name: 
// Module Name: celda_unitaria_contador_binario
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


module celda_unitaria_contador_binario(
    input ena_in,
    input rst,
    input clk,
    output q,
    output ena_out
    );
    
    wire d_aux;
    
    assign d_aux = q ^ ena_in;
    assign ena_out = q & ena_in;
    
    ffd my_reg_desp(
        .d(d_aux),
        .ena(1'b1),
        .rst(rst),
        .clk(clk),
        .q(q)
    );
    
endmodule
