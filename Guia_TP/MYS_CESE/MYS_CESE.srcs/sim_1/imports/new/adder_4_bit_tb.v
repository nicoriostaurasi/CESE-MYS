`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: adder_4_bit_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Testbench exhaustivo para el sumador de cuatro bits.
//
// Dependencies: adder_4_bits.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module adder_4_bit_tb;

    reg [4-1:0] a;
    reg [4-1:0] b;
    reg ci;
    wire [4-1:0] s;
    wire co;
    adder_4_bits uut (
        .a(a),
        .b(b),
        .ci(ci),
        .s(s),
        .co(co)
    );

    initial begin
        a=4'b0000; b=4'b0000; ci=1'b0;
        #10;
        if (co !== 1'b0 || s !== 4'b0000)
            $error("Error: 0 + 0 + 0");

        a=4'b0001; b=4'b0001; ci=1'b0;
        #10;
        if (co !== 1'b0 || s !== 4'b0010)
            $error("Error: 1 + 1 + 0");

        a=4'b0101; b=4'b0011; ci=1'b0;
        #10;
        if (co !== 1'b0 || s !== 4'b1000)
            $error("Error: 5 + 3 + 0");

        a=4'b0101; b=4'b0011; ci=1'b1;
        #10;
        if (co !== 1'b0 || s !== 4'b1001)
            $error("Error: 5 + 3 + 1");

        a=4'b0111; b=4'b0001; ci=1'b0;
        #10;
        if (co !== 1'b0 || s !== 4'b1000)
            $error("Error: 7 + 1 + 0");

        a=4'b1111; b=4'b0000; ci=1'b1;
        #10;
        if (co !== 1'b1 || s !== 4'b0000)
            $error("Error: 15 + 0 + 1");

        a=4'b1001; b=4'b1001; ci=1'b0;
        #10;
        if (co !== 1'b1 || s !== 4'b0010)
            $error("Error: 9 + 9 + 0");

        a=4'b1111; b=4'b1111; ci=1'b1;
        #10;
        if (co !== 1'b1 || s !== 4'b1111)
            $error("Error: 15 + 15 + 1");

        $display("Los 8 casos del sumador de 4 bits pasaron correctamente");
        $finish;
    end

endmodule
