`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 21.10.2026
// Design Name:
// Module Name: contador_bcd_1_seg_tb
// Project Name: CLP_CESE
// Target Devices:
// Tool Versions:
// Description: Verifica el contador BCD habilitado por un divisor de reloj.
//
// Dependencies: contador_bcd_1_seg.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments: SYS_CLK se reduce para acelerar la simulacion.
//
//////////////////////////////////////////////////////////////////////////////////

module contador_bcd_1_seg_tb;

    localparam SYS_CLK_SIM=5;

    reg ena;
    reg rst;
    reg clk=1'b0;
    wire [4-1:0] q;
    integer i;

    contador_bcd_1_seg #(
        .SYS_CLK(SYS_CLK_SIM)
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

        if (q !== 4'b0000)
            $error("Error: el contador no quedo en cero despues del reset");

        repeat (SYS_CLK_SIM) @(posedge clk);
        #1;
        if (q !== 4'h0)
            $error("Error: conto con ena=0");

        ena=1'b1;
        for (i=1; i<=12; i=i+1) begin
            repeat (SYS_CLK_SIM) @(posedge clk);
            #1;
            if (q !== (i%10))
                $error("Error: el contador BCD no avanzo en el instante esperado");
        end

        ena=1'b0;
        repeat (2*SYS_CLK_SIM) @(posedge clk);
        #1;
        if (q !== 4'b0010)
            $error("Error: el contador no se detuvo con ena=0");

        ena=1'b1;
        repeat (SYS_CLK_SIM) @(posedge clk);
        #1;
        if (q !== 4'b0011)
            $error("Error: el contador no reanudo correctamente");

        $display("Todas las pruebas de contador_bcd_1_seg pasaron correctamente");
        $finish;
    end

endmodule
