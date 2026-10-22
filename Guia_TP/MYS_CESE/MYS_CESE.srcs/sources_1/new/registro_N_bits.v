`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 19:44:51
// Design Name: 
// Module Name: registro_N_bits
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


module registro_N_bits#(
    parameter N = 8
)(
    input [N-1:0] d,
    input ena,
    input rst,
    input clk,
    output reg[N-1:0] q
    );
    
    always@(posedge clk) begin
        if (rst) begin
            q<={N{1'b0}};
        end else begin
            if (ena) begin
                q<=d;
            end
        end
    end
    
endmodule
