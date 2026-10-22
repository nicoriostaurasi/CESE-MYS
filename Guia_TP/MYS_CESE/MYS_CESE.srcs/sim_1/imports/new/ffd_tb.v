`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: ffd_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica reset, carga y retencion del flip-flop D.
//
// Dependencies: ffd.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module ffd_tb;

    reg d;
    reg ena;
    reg rst;
    reg clk=1'b0;
    wire q;

    ffd uut (
        .d(d),
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
        d=1'b0;
        ena=1'b0;

        @(negedge rst);
        #1;

        if (q !== 1'b0)
            $error("Error: q no quedo en 0 despues del reset");

        d=1'b1;
        ena=1'b1;
        @(posedge clk);
        #1;
        if (q !== 1'b1)
            $error("Error: no capturo d=1 con ena=1");

        d=1'b0;
        ena=1'b0;
        @(posedge clk);
        #1;
        if (q !== 1'b1)
            $error("Error: q cambio con ena=0");

        ena=1'b1;
        @(posedge clk);
        #1;
        if (q !== 1'b0)
            $error("Error: no capturo d=0 con ena=1");

        d=1'b1;
        @(posedge clk);
        #1;
        if (q !== 1'b1)
            $error("Error: no realizo la segunda captura de d=1");

        $display("Todas las pruebas de ffd pasaron correctamente");
        $finish;
    end

endmodule
