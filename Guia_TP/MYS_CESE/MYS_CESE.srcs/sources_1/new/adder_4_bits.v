`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 17:39:47
// Design Name: 
// Module Name: adder_4_bits
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


module adder_4_bits(
    input ci,
    input  [4-1:0] a,
    input  [4-1:0] b,
    output [4-1:0] s,
    output co
    );
    
    wire c_vector[5-1:0];
    assign c_vector[0] = ci;
    assign co = c_vector[5-1];
    
    genvar i;
    generate
        for(i=0;i<4;i=i+1)begin: genAdder
            adder_1_bit instancia_00 (
                .ci(c_vector[i]),
                .a(a[i]),
                .b(b[i]),
                .s(s[i]),
                .co(c_vector[i+1])
            );
        end    
    endgenerate

endmodule
