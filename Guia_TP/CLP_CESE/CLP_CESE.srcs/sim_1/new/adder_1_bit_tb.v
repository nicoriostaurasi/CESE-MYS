`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: adder_1_bit_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Testbench autocontenido para el sumador completo de un bit.
//
// Dependencies: adder_1_bit.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module adder_1_bit_tb;

    reg a;
    reg b;
    reg ci;
    wire s;
    wire co;
    adder_1_bit uut (
        .a(a),
        .b(b),
        .ci(ci),
        .s(s),
        .co(co)
    );

    initial begin
        a=1'b0;
        b=1'b0;
        ci=1'b0;
        #10;
        if (co !== 1'b0 || s !== 1'b0)
            $error("Error: a=0, b=0, ci=0");

        a=1'b0;
        b=1'b0;
        ci=1'b1;
        #10;
        if (co !== 1'b0 || s !== 1'b1)
            $error("Error: a=0, b=0, ci=1");

        a=1'b0;
        b=1'b1;
        ci=1'b0;
        #10;
        if (co !== 1'b0 || s !== 1'b1)
            $error("Error: a=0, b=1, ci=0");

        a=1'b0;
        b=1'b1;
        ci=1'b1;
        #10;
        if (co !== 1'b1 || s !== 1'b0)
            $error("Error: a=0, b=1, ci=1");

        a=1'b1;
        b=1'b0;
        ci=1'b0;
        #10;
        if (co !== 1'b0 || s !== 1'b1)
            $error("Error: a=1, b=0, ci=0");

        a=1'b1;
        b=1'b0;
        ci=1'b1;
        #10;
        if (co !== 1'b1 || s !== 1'b0)
            $error("Error: a=1, b=0, ci=1");

        a=1'b1;
        b=1'b1;
        ci=1'b0;
        #10;
        if (co !== 1'b1 || s !== 1'b0)
            $error("Error: a=1, b=1, ci=0");

        a=1'b1;
        b=1'b1;
        ci=1'b1;
        #10;
        if (co !== 1'b1 || s !== 1'b1)
            $error("Error: a=1, b=1, ci=1");

        $display("Todas las combinaciones pasaron correctamente");
        $finish;
    end

endmodule
