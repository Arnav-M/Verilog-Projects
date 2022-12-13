// Arnav Mathur
// CSE 469
// 10/26/2022

`timescale 1ps/1ps

// Module for bitwise OR.
module bitwiseOr(out, a, b);
    output logic [63:0] out;
    input logic [63:0] a;
    input logic [63:0] b;
    parameter delay = 50;

    genvar i;
    generate
        for (i = 0; i < 64; i++) begin: eachOrs
            or #delay orgate(out[i], a[i], b[i]);
        end
    endgenerate

endmodule

// Testbench for module.
module bitwiseOr_testbench();
    logic [63:0] out;
    logic [63:0] a;
    logic [63:0] b;

    bitwiseOr dut (.out, .a, .b);

    initial begin;
        a = 64'h0000000000000000; b = 64'h0000000000000000; #500;
        a = 64'hFFFFFFFFFFFFFFFF; b = 64'hFFFFFFFFFFFFFFFF; #500;
		  a = 64'h1010101010101010; b = 64'h1010101010101010; #500;
        $stop;
    end
endmodule