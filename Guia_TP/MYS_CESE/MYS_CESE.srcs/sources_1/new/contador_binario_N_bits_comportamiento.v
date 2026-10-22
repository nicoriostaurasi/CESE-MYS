`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 19:33:09
// Design Name: 
// Module Name: contador_binario_N_bits_comportamiento
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


module contador_binario_N_bits_comportamiento#(
    parameter N = 4
)(
    input ena,
    input rst,
    input clk,
    output reg [N-1:0] q
    );
    
    wire[N-1:0]q_next;
    
    always@(posedge clk) begin
        if (rst) begin
            q<={N{1'b0}};
        end else begin
            if (ena) begin
                q<=q_next;            
            end
        end
    end
        
    assign q_next = q + 1;

    
endmodule
