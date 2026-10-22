`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: contador_binario_4_bits_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica el contador binario estructural de cuatro bits.
//
// Dependencies: contador_binario_4_bits.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module contador_binario_4_bits_tb;

    reg ena;
    reg rst;
    reg clk=1'b0;
    wire [4-1:0] q;
    integer i;

    contador_binario_4_bits uut (
        .ena(ena),
        .rst(rst),
        .clk(clk),
        .q(q)
    );

    always #5 clk=~clk;

    initial begin
        rst=1'b1;
        #50;
        rst=1'b0;
    end

    initial begin
        ena=1'b0;

        @(negedge rst);
        #1;

        if (q !== 4'h0)
            $error("Error: el contador no quedo en cero despues del reset");

        repeat (2) begin
            @(posedge clk);
            #1;
            if (q !== 4'h0)
                $error("Error: el contador cambio con ena=0");
        end

        ena=1'b1;

        for (i=1; i<=16; i=i+1) begin
            @(posedge clk);
            #1;
            if (q !== (i%16))
                $error("Error durante la secuencia de conteo");
        end

        ena=1'b0;
        @(posedge clk);
        #1;
        if (q !== 4'h0)
            $error("Error: no mantuvo el valor luego del conteo");

        ena=1'b1;
        @(posedge clk);
        #1;
        if (q !== 4'h1)
            $error("Error: no reanudo el conteo correctamente");

        $display("Todas las pruebas de contador_binario_4_bits pasaron correctamente");
        $finish;
    end

endmodule
