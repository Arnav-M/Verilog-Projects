// Arnav Mathur
// EE 469
// 10/12/2022

`timescale 1ns/10ps

// Mux for 32 inputs.
module mux32_1(in, out, sel);
    output logic out;
    input logic [31:0] in;
    input logic [4:0] sel;
    logic [1:0] subout;

    mux16_1 mux1 (.in(in[15:0]), .out(subout[0]), .sel(sel[3:0]));
    mux16_1 mux2 (.in(in[31:16]), .out(subout[1]), .sel(sel[3:0]));
    mux2_1 muxControl (.in(subout[1:0]), .out(out), .sel(sel[4]));

endmodule

// Testbench for the module.
module mux32_1_testbench();
    logic out;
    logic [31:0] in;
    logic [4:0] sel;

    mux32_1 dut (.out, .in, .sel);

    parameter delay = 2000;

    initial begin
        sel=0; in=32'b10100110110100011111001001110011; #delay; // 1
        sel=2; #delay; // 0
        sel=5; #delay; // 1
        sel=8; #delay; // 0
        sel=9; #delay; // 1
        sel=10; #delay; // 0
        sel=14; #delay; // 1
        sel=15; #delay; // 1
        sel=16; #delay; // 1
        sel=19; #delay; // 0
        sel=22; #delay; // 1
        sel=23; #delay; // 1
        sel=25; #delay; // 1
        sel=29; #delay; // 1
        sel=30; #delay; // 0
        sel=31; #delay; // 1

        sel=0; in=32'b01111010100111101001001001110100; #delay;
        sel=2; #delay;
        sel=5; #delay;
        sel=8; #delay;
        sel=9; #delay;
        sel=10; #delay;
        sel=14; #delay;
        sel=15; #delay;
        sel=16; #delay;
        sel=19; #delay;
        sel=22; #delay;
        sel=23; #delay;
        sel=25; #delay;
        sel=29; #delay;
        sel=30; #delay;
        sel=31; #delay;
        #delay;
    end
endmodule