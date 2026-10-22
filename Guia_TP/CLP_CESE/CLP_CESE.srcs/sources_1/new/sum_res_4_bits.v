`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 17:51:15
// Design Name: 
// Module Name: sum_res_4_bits
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


module sum_res_4_bits(
    input sr,
    input  [4-1:0] a,
    input  [4-1:0] b,
    output [4-1:0] s,
    output co
    );
    wire [4-1:0]b_sum_res;
    wire ci_sum_res;

    // Funciona como CA2 cuando SR = 1, es decir, cuando se quiere restar. 
    // Cuando SR = 0, funciona como suma.
    assign ci_sum_res = sr;
    assign b_sum_res = (sr==1'b0) ? b : ~b;
    
    //instancia sumador 4 bits
    adder_4_bits inst_sum (
        .ci(ci_sum_res),
        .a(a),
        .b(b_sum_res),
        .s(s),
        .co(co)
    );


endmodule
