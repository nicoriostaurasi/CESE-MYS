`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: mux_2_a_1_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Testbench exhaustivo para el multiplexor de dos entradas.
//
// Dependencies: mux_2_a_1.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module mux_2_a_1_tb;

    reg a;
    reg b;
    reg sel;
    wire mux;
    mux_2_a_1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .mux(mux)
    );

    initial begin
        a=1'b0; b=1'b0; sel=1'b0;
        #10;
        if (mux !== 1'b0) $error("Error: a=0, b=0, sel=0");

        a=1'b0; b=1'b1; sel=1'b0;
        #10;
        if (mux !== 1'b0) $error("Error: a=0, b=1, sel=0");

        a=1'b1; b=1'b0; sel=1'b0;
        #10;
        if (mux !== 1'b1) $error("Error: a=1, b=0, sel=0");

        a=1'b1; b=1'b1; sel=1'b0;
        #10;
        if (mux !== 1'b1) $error("Error: a=1, b=1, sel=0");

        a=1'b0; b=1'b0; sel=1'b1;
        #10;
        if (mux !== 1'b0) $error("Error: a=0, b=0, sel=1");

        a=1'b0; b=1'b1; sel=1'b1;
        #10;
        if (mux !== 1'b1) $error("Error: a=0, b=1, sel=1");

        a=1'b1; b=1'b0; sel=1'b1;
        #10;
        if (mux !== 1'b0) $error("Error: a=1, b=0, sel=1");

        a=1'b1; b=1'b1; sel=1'b1;
        #10;
        if (mux !== 1'b1) $error("Error: a=1, b=1, sel=1");

        $display("Todas las pruebas de mux_2_a_1 pasaron correctamente");
        $finish;
    end

endmodule
