`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: contador_bcd_4_digitos_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica la cascada de cuatro digitos BCD.
//
// Dependencies: contador_bcd_4_digitos.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module contador_bcd_4_digitos_tb;

    reg ena;
    reg rst;
    reg clk=1'b0;
    wire [4-1:0] bcd0;
    wire [4-1:0] bcd1;
    wire [4-1:0] bcd2;
    wire [4-1:0] bcd3;
    wire co;
    integer i;

    contador_bcd_4_digitos uut (
        .ena(ena),
        .rst(rst),
        .clk(clk),
        .bcd0(bcd0),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .co(co)
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

        if (bcd3 !== 4'b0000 || bcd2 !== 4'b0000 ||
            bcd1 !== 4'b0000 || bcd0 !== 4'b0000)
            $error("Error: el contador no quedo en 0000 despues del reset");

        @(posedge clk);
        #1;
        if (bcd3 !== 4'b0000 || bcd2 !== 4'b0000 ||
            bcd1 !== 4'b0000 || bcd0 !== 4'b0000)
            $error("Error: el contador cambio con ena=0");

        ena=1'b1;

        for (i=1; i<=1000; i=i+1) begin
            @(posedge clk);
            #1;
            if (bcd0 !== (i%10) || bcd1 !== ((i/10)%10) ||
                bcd2 !== ((i/100)%10) || bcd3 !== ((i/1000)%10))
                $error("Error durante la secuencia del contador BCD de 4 digitos");
            if (co !== 1'b0)
                $error("Error: co se activo antes de 9999");
        end

        ena=1'b0;
        @(posedge clk);
        #1;
        if (bcd3 !== 4'b0001 || bcd2 !== 4'b0000 ||
            bcd1 !== 4'b0000 || bcd0 !== 4'b0000)
            $error("Error: no mantuvo 1000 con ena=0");

        $display("Todas las pruebas de contador_bcd_4_digitos pasaron correctamente");
        $finish;
    end

endmodule
