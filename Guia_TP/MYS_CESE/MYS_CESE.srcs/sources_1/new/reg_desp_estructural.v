`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 18:14:07
// Design Name: 
// Module Name: reg_desp_estructural
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


module reg_desp_estructural(
    input E,
    output S,
    input rst,
    input clk
    );
    wire [5-1:0] reg_aux;

    assign reg_aux[0] = E;
    assign S = reg_aux[5-1];
    
    genvar i;
    generate
        for(i=0;i<4;i=i+1)begin:genRegs
            ffd misRegistros(
                .d(reg_aux[i]),
                .ena(1'b1),
                .rst(rst),
                .clk(clk),
                .q(reg_aux[i+1])
            );
        end    
    endgenerate
    

endmodule
