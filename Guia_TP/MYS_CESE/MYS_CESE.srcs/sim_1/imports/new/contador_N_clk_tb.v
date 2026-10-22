`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: contador_N_clk_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica el pulso periodico generado cada N ciclos.
//
// Dependencies: contador_N_clk.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module contador_N_clk_tb;

    localparam N=5;

    reg rst;
    reg clk=1'b0;
    wire s;
    integer i;

    contador_N_clk #(
        .N(N)
    ) uut (
        .rst(rst),
        .clk(clk),
        .s(s)
    );

    always #5 clk=~clk;

    initial begin
        rst=1'b1;
        #50;
        rst=1'b0;
    end

    initial begin
        @(negedge rst);
        #1;

        if (s !== 1'b0)
            $error("Error: s no quedo en cero despues del reset");

        for (i=1; i<=3*N; i=i+1) begin
            @(posedge clk);
            #1;
            if (s !== ((i%N)==(N-1)))
                $error("Error en el pulso de habilitacion, ciclo %0d",i);
        end

        $display("Todas las pruebas de contador_N_clk pasaron correctamente");
        $finish;
    end

endmodule
