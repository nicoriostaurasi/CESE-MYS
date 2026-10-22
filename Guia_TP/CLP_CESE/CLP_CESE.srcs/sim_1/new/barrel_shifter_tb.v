`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: barrel_shifter_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica todos los desplazamientos del barrel shifter.
//
// Dependencies: barrel_shifter.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module barrel_shifter_tb;

    reg [8-1:0] a;
    reg [3-1:0] des;
    wire [8-1:0] s;
    barrel_shifter uut (
        .a(a),
        .des(des),
        .s(s)
    );

    initial begin
        a=8'b10110101;

        des=3'b000;
        #10;
        if (s !== 8'b10110101) $error("Error al desplazar 0 posiciones");

        des=3'b001;
        #10;
        if (s !== 8'b01011010) $error("Error al desplazar 1 posicion");

        des=3'b010;
        #10;
        if (s !== 8'b00101101) $error("Error al desplazar 2 posiciones");

        des=3'b011;
        #10;
        if (s !== 8'b00010110) $error("Error al desplazar 3 posiciones");

        des=3'b100;
        #10;
        if (s !== 8'b00001011) $error("Error al desplazar 4 posiciones");

        des=3'b101;
        #10;
        if (s !== 8'b00000101) $error("Error al desplazar 5 posiciones");

        des=3'b110;
        #10;
        if (s !== 8'b00000010) $error("Error al desplazar 6 posiciones");

        des=3'b111;
        #10;
        if (s !== 8'b00000001) $error("Error al desplazar 7 posiciones");

        $display("Todas las pruebas de barrel_shifter pasaron correctamente");
        $finish;
    end

endmodule
