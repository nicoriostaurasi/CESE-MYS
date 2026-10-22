`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: contador_bcd_comportamiento_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica el contador BCD descripto por comportamiento.
//
// Dependencies: contador_bcd_comportamiento.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module contador_bcd_comportamiento_tb;

    reg ena;
    reg rst;
    reg clk=1'b0;
    wire [4-1:0] q;
    integer i;

    contador_bcd_comportamiento uut (
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
            $error("Error: el contador BCD no quedo en cero despues del reset");

        @(posedge clk);
        #1;
        if (q !== 4'h0)
            $error("Error: el contador BCD cambio con ena=0");

        ena=1'b1;

        for (i=1; i<=20; i=i+1) begin
            @(posedge clk);
            #1;
            if (q !== (i%10))
                $error("Error durante la secuencia del contador BCD");
        end

        ena=1'b0;
        @(posedge clk);
        #1;
        if (q !== 4'h0)
            $error("Error: el contador BCD no mantuvo el valor");

        ena=1'b1;
        @(posedge clk);
        #1;
        if (q !== 4'h1)
            $error("Error: el contador BCD no reanudo correctamente");

        $display("Todas las pruebas de contador_bcd_comportamiento pasaron correctamente");
        $finish;
    end

endmodule
