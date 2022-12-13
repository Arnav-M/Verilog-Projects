// Arnav Mathur
// EE 469
// 2/8/2022

`timescale 1ps/1ps

module dataSel2_1(out, A, B, sel);
    output logic [63:0] out;
    input logic [63:0] A, B;
    input logic sel;

    genvar i;

    generate
        for (i = 0; i < 64; i++) begin: eachMux
            mux2_1 selector(.out(out[i]), .i0(A), .i1(B), .sel(sel));
        end
    endgenerate
endmodule

module dataSel2_1_testbench();
    logic [63:0] out;
    logic [63:0] A, B;
    logic sel;

    dataSel2_1 dut (.out, .A, .B, .sel);

    parameter delay = 1000;

    initial begin
        sel = 0; A = 64'hABCDABCDABCDABCD; B = 64'h0123456789ABCDEF; #delay;
        sel = 1; A = 64'hABCDABCDABCDABCD; B = 64'h0123456789ABCDEF; #delay;
    end
endmodule