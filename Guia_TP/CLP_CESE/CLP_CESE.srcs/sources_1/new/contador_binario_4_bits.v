`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 19:09:02
// Design Name: 
// Module Name: contador_binario_4_bits
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


module contador_binario_4_bits(
    input ena,
    input rst,
    input clk,
    output [4-1:0] q
    );
    
    wire[4-1:0] ena_aux;
    
    genvar i;
    generate
        for(i=0;i<4;i=i+1)begin:genRegs
            celda_unitaria_contador_binario myCntrs(
                .ena_in(ena_aux[i]),
                .rst(rst),
                .clk(clk),
                .q(q[i]),
                .ena_out(ena_aux[i+1])
            );
        end
    endgenerate
    
    
endmodule
