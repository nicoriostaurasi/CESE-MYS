`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 19:17:32
// Design Name: 
// Module Name: contador_binario_4_bits_comportamiento
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


module contador_binario_4_bits_comportamiento(
    input ena,
    input rst,
    input clk,
    output reg[4-1:0] q
    );
    
    wire [4-1:0]q_next;
    
    always@(posedge clk) begin
        if(rst)begin
            q<=4'h0;
        end else begin 
            if (ena) begin
                q<=q_next;
            end
        end
    end
    
    assign q_next = q + 4'h1;
    
    
endmodule
