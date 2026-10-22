`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 19:26:41
// Design Name: 
// Module Name: contador_binario_N_bits_estructural
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


module contador_binario_N_bits_estructural#(
    parameter N = 4
)(
    input ena,
    input rst,
    input clk,
    output [N-1:0] q
    );
    
    wire [N+1-1:0]ena_aux;

    genvar i;
    generate
        for(i=0;i<N;i=i+1)begin: genCounter
            celda_unitaria_contador_binario myNCntrs(
                .ena_in(ena_aux[i]),
                .rst(rst),
                .clk(clk),
                .q(q[i]),
                .ena_out(ena_aux[i+1])
            );
        end    
    endgenerate
    
endmodule
