`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2026 18:39:46
// Design Name: 
// Module Name: barrel_shifter_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module barrel_shifter_mux(
    input  [8-1:0] a,
    input  [3-1:0] des,
    output [8-1:0] s
    );

    wire[8-1:0] etapa_1, etapa_2, etapa_3;    
    wire[8-1:0] desp_1, desp_2, desp_3;    

    // Desplazamientos fijos armados mediante concatenacion.
    assign desp_1 = {1'h0,a[8-1:1]};
    assign desp_2 = {2'h0,a[8-1:2]};
    assign desp_4 = {4'h0,a[8-1:4]};
    
    // Primera etapa: desplaza 0 o 1 posicion.
    genvar i;
    generate
        for(i=0;i<8;i=i+1) begin : genShifter1
            mux_2_a_1 uMux (
                .a(a[i]),
                .b(desp_1[i]),
                .sel(des[0]),
                .mux(etapa_1[i])
            );
        end
    endgenerate

    // Segunda etapa: desplaza 0 o 2 posiciones.
    genvar j;
    generate
        for(j=0;j<8;j=j+1) begin : genShifter2
            mux_2_a_1 uMux (
                .a(a[j]),
                .b(desp_2[j]),
                .sel(des[1]),
                .mux(etapa_2[j])
            );
        end
    endgenerate
    
    // Tercera etapa: desplaza 0 o 4 posiciones.
    genvar k;
    generate
        for(k=0;k<8;k=k+1) begin : genShifter3
            mux_2_a_1 uMux (
                .a(a[k]),
                .b(desp_2[k]),
                .sel(des[2]),
                .mux(etapa_3[k])
            );
        end
    endgenerate


endmodule