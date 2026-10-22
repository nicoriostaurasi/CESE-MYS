`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: reg_desp_comportamiento_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica el registro de desplazamiento por comportamiento.
//
// Dependencies: reg_desp_comportamiento.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module reg_desp_comportamiento_tb;

    reg E;
    reg rst;
    reg clk=1'b0;
    wire S;
    reg_desp_comportamiento uut (
        .E(E),
        .S(S),
        .rst(rst),
        .clk(clk)
    );

    always #5 clk=~clk;

    initial begin
        rst=1'b1;
        #50;
        rst=1'b0;
    end

    initial begin
        E=1'b0;

        @(negedge rst);
        #1;
        if (S !== 1'b0) $error("Error: S no quedo en 0 despues del reset");

        E=1'b1;
        @(posedge clk);
        #1;
        if (S !== 1'b0) $error("Error despues de desplazar el primer bit");

        E=1'b0;
        @(posedge clk);
        #1;
        if (S !== 1'b0) $error("Error despues de desplazar el segundo bit");

        E=1'b1;
        @(posedge clk);
        #1;
        if (S !== 1'b0) $error("Error despues de desplazar el tercer bit");

        E=1'b1;
        @(posedge clk);
        #1;
        if (S !== 1'b1) $error("Error: no aparecio el primer bit cargado en S");

        E=1'b0;
        @(posedge clk);
        #1;
        if (S !== 1'b0) $error("Error: segundo bit desplazado incorrecto");

        @(posedge clk);
        #1;
        if (S !== 1'b1) $error("Error: tercer bit desplazado incorrecto");

        @(posedge clk);
        #1;
        if (S !== 1'b1) $error("Error: cuarto bit desplazado incorrecto");

        @(posedge clk);
        #1;
        if (S !== 1'b0) $error("Error: el registro no se vacio con ceros");

        $display("Todas las pruebas de reg_desp_comportamiento pasaron correctamente");
        $finish;
    end

endmodule
