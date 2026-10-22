`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 22:35:35
// Design Name: 
// Module Name: contador_bcd_comportamiento
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


module contador_bcd_comportamiento(
    input ena,
    input rst,
    input clk,
    output reg[4-1:0] q
    );

    wire [4-1:0] d_next, q_inc;
    wire igual_9;

    // Incrementador combinacional.
    assign q_inc = q + 4'h1;

    // Comparador combinacional con el valor BCD 9.
    assign igual_9 = (q == 4'h9) ? 1:0;

    // MUX: despues del 9 carga cero; en otro caso carga Q + 1.
    assign d_next = (igual_9 == 1'b1) ? 4'h0: q_inc;

    // Registro de estado con reset sincrono.
    always@(posedge clk) begin
        if (rst) begin
            q<={4{1'b0}};
        end else begin
            if (ena) begin
                q<=d_next;            
            end
        end
    end


    
endmodule