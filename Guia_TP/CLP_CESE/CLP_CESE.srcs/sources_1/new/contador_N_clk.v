`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 20:04:07
// Design Name: 
// Module Name: contador_N_clk
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


module contador_N_clk#(
    parameter N = 5,
    parameter M = $clog2(N)
)(
    input rst,
    input clk,
    output s
    );

    reg [M-1:0] q;

    always @(posedge clk) begin
        if(rst)begin
            q<={M{1'b0}};
        end else begin
            if(q==(N-1))begin
                q<={M{1'b0}};
            end else begin
                q<=q+1;
            end
        end    
    end   
    
    assign s = (q==(N-1)) ? 1:0; 

endmodule
