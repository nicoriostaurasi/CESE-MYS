`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: contador_binario_N_bits_estructural_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica el contador estructural parametrizable.
//
// Dependencies: contador_binario_N_bits_estructural.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module contador_binario_N_bits_estructural_tb;

    localparam N=5;

    reg ena;
    reg rst;
    reg clk=1'b0;
    wire [N-1:0] q;
    integer i;

    contador_binario_N_bits_estructural #(
        .N(N)
    ) uut (
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

        if (q !== {N{1'b0}})
            $error("Error: el contador no quedo en cero despues del reset");

        @(posedge clk);
        #1;
        if (q !== {N{1'b0}})
            $error("Error: el contador cambio con ena=0");

        ena=1'b1;

        for (i=1; i<=(1<<N); i=i+1) begin
            @(posedge clk);
            #1;
            if (q !== (i%(1<<N)))
                $error("Error durante la secuencia del contador generico");
        end

        ena=1'b0;
        @(posedge clk);
        #1;
        if (q !== {N{1'b0}})
            $error("Error: no mantuvo el valor con ena=0");

        ena=1'b1;
        @(posedge clk);
        #1;
        if (q !== {{N-1{1'b0}},1'b1})
            $error("Error: no reanudo el conteo correctamente");

        $display("Todas las pruebas del contador estructural pasaron correctamente");
        $finish;
    end

endmodule
