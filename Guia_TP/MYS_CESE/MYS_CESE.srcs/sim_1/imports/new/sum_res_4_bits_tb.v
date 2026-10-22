`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: sum_res_4_bits_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica exhaustivamente la suma y resta de cuatro bits.
//
// Dependencies: sum_res_4_bits.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module sum_res_4_bits_tb;

    reg [4-1:0] a;
    reg [4-1:0] b;
    reg sum_res;
    wire [4-1:0] s;
    wire co;
    sum_res_4_bits uut (
        .a(a),
        .b(b),
        .sr(sum_res),
        .s(s),
        .co(co)
    );

    initial begin
        sum_res=1'b0; a=4'b0000; b=4'b0000;
        #10;
        if (co !== 1'b0 || s !== 4'b0000) $error("Error en suma: 0 + 0");

        sum_res=1'b0; a=4'b0001; b=4'b0001;
        #10;
        if (co !== 1'b0 || s !== 4'b0010) $error("Error en suma: 1 + 1");

        sum_res=1'b0; a=4'b0101; b=4'b0011;
        #10;
        if (co !== 1'b0 || s !== 4'b1000) $error("Error en suma: 5 + 3");

        sum_res=1'b0; a=4'b0111; b=4'b1000;
        #10;
        if (co !== 1'b0 || s !== 4'b1111) $error("Error en suma: 7 + 8");

        sum_res=1'b0; a=4'b1111; b=4'b0000;
        #10;
        if (co !== 1'b0 || s !== 4'b1111) $error("Error en suma: 15 + 0");

        sum_res=1'b0; a=4'b1111; b=4'b0001;
        #10;
        if (co !== 1'b1 || s !== 4'b0000) $error("Error en suma: 15 + 1");

        sum_res=1'b0; a=4'b1001; b=4'b1001;
        #10;
        if (co !== 1'b1 || s !== 4'b0010) $error("Error en suma: 9 + 9");

        sum_res=1'b0; a=4'b1111; b=4'b1111;
        #10;
        if (co !== 1'b1 || s !== 4'b1110) $error("Error en suma: 15 + 15");

        $display("Los 8 casos de suma pasaron correctamente");

        sum_res=1'b1; a=4'b0000; b=4'b0000;
        #10;
        if (co !== 1'b1 || s !== 4'b0000) $error("Error en resta: 0 - 0");

        sum_res=1'b1; a=4'b0111; b=4'b0011;
        #10;
        if (co !== 1'b1 || s !== 4'b0100) $error("Error en resta: 7 - 3");

        sum_res=1'b1; a=4'b1111; b=4'b0001;
        #10;
        if (co !== 1'b1 || s !== 4'b1110) $error("Error en resta: 15 - 1");

        sum_res=1'b1; a=4'b1000; b=4'b1000;
        #10;
        if (co !== 1'b1 || s !== 4'b0000) $error("Error en resta: 8 - 8");

        sum_res=1'b1; a=4'b0011; b=4'b0101;
        #10;
        if (co !== 1'b0 || s !== 4'b1110) $error("Error en resta: 3 - 5");

        sum_res=1'b1; a=4'b0000; b=4'b0001;
        #10;
        if (co !== 1'b0 || s !== 4'b1111) $error("Error en resta: 0 - 1");

        sum_res=1'b1; a=4'b0010; b=4'b1001;
        #10;
        if (co !== 1'b0 || s !== 4'b1001) $error("Error en resta: 2 - 9");

        sum_res=1'b1; a=4'b1111; b=4'b0000;
        #10;
        if (co !== 1'b1 || s !== 4'b1111) $error("Error en resta: 15 - 0");

        $display("Los 8 casos de resta pasaron correctamente");
        $display("Todos los casos del sumador/restador pasaron correctamente");
        $finish;
    end

endmodule
