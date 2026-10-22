`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 18:25:56
// Design Name: 
// Module Name: reg_desp_comportamiento
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


module reg_desp_comportamiento(
    input E,
    output S,
    input rst,
    input clk
    );
    reg [4-1:0] q;

    always@(posedge clk)begin
        if (rst) begin
            q<=4'h0; 
        end else begin
            q<={E,q[4-1:1]};        
        end
    end
    
    assign S = q[0];
                
endmodule
