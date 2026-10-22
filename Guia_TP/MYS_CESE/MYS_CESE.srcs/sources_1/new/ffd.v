`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 18:06:06
// Design Name: 
// Module Name: ffd
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


module ffd(
    input d,
    input ena,
    input rst,
    input clk,
    output reg q
    );
    
    always @(posedge clk) begin
        if(rst)begin
            q<=1'b0;
        end else begin
            if(ena)begin
                q<=d;
            end
        end    
    end    

endmodule
