`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 19:51:35
// Design Name: 
// Module Name: contador_bcd
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


module contador_bcd(
    input ena,
    input rst,
    input clk,
    output [4-1:0] q,
    output co
    );
    
    wire [4-1:0] d_reg, q_inc;
    wire igual_9;
    
    adder_4_bits adder_instance(
        .ci(1'b0),
        .a(q),
        .b(4'h1),
        .s(q_inc),
        .co(co)
    );
    
    comparador_igual #(.N(4)) comparador_instance(
        .a(q),
        .b(4'h9),
        .igual(igual_9)
    );
    
    
    // Cuando el valor actual es 9, el siguiente valor debe ser 0.
    genvar i;
    generate
        for(i=0;i<4;i=i+1)begin:genMux
            mux_2_a_1 mux_instance(
                .a(q_inc[i]),
                .b(1'b0),
                .sel(igual_9),
                .mux(d_reg[i])
            );         
        end
    endgenerate
    
    registro_N_bits #(.N(4))registro_instance(
        .d(d_reg),
        .ena(ena),
        .rst(rst),
        .clk(clk),
        .q(q)
    );
    

endmodule
