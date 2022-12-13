// Arnav Mathur
// CSE 469
// 10/26/2022

`timescale 1ps/1ps

// Mux for 8 inputs.
module mux8_1(in, out, sel);
    output logic out;
    input logic [7:0] in;
    input logic [2:0] sel;
    logic [1:0] subout;

    mux2_1 mux1 (.out(out), .in(subout[1:0]), .sel(sel[2]));
    mux4_1 mux2 (.out(subout[1]), .in(in[7:4]), .sel(sel[1:0]));
    mux4_1 mux3 (.out(subout[0]), .in(in[3:0]), .sel(sel[1:0]));
endmodule

// Testbench for the module.
module mux8_1_testbench();
    logic [7:0] in;
    logic [2:0] sel;
    logic out;
    integer i, j;

    mux8_1 dut (.out, .in, .sel);
    
    initial begin
        for (i=0; i<8; i++) begin
            for (j=0; j<256; j++) begin
                sel[2:0]=i; in[7:0]=j; #1000;
            end
        end
    end
endmodule