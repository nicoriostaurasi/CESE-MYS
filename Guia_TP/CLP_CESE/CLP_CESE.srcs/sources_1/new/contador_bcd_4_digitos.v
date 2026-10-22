`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 22:23:19
// Design Name: 
// Module Name: contador_bcd_4_digitos
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


module contador_bcd_4_digitos(
    input ena,
    input rst,
    input clk,
    output[4-1:0] bcd0,
    output[4-1:0] bcd1,
    output[4-1:0] bcd2,
    output[4-1:0] bcd3,
    output co
    );
    wire[16-1:0] q_aux;
    wire[5-1:0] ena_aux;
    
    assign bcd0=q_aux[3:0];
    assign bcd1=q_aux[7:4];
    assign bcd2=q_aux[11:8];
    assign bcd3=q_aux[15:12];
    
    assign ena_aux[0]=ena;
    assign co=ena_aux[4];

    genvar i;
    generate
        for(i=0;i<4;i=i+1) begin : digitos
            contador_bcd contador_instance (
                .ena(ena_aux[i]),
                .rst(rst),
                .clk(clk),
                .q(q_aux[4*i+3:4*i]),
                .co(ena_aux[i+1])
            );
        end
    endgenerate
    
    
    
endmodule
