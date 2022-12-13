// Arnav Mathur
// EE 469
// 10/12/2022

`timescale 1ns/10ps

// Mux for 16 inputs.
module mux16_1(in, out, sel);
    output logic out;
    input logic [15:0] in;
    input logic [3:0] sel;
    logic [3:0] subout;

    mux4_1 mux1 (.in(in[3:0]), .out(subout[0]), .sel(sel[1:0]));
    mux4_1 mux2 (.in(in[7:4]), .out(subout[1]), .sel(sel[1:0]));
    mux4_1 mux3 (.in(in[11:8]), .out(subout[2]), .sel(sel[1:0]));
    mux4_1 mux4 (.in(in[15:12]), .out(subout[3]), .sel(sel[1:0]));
    mux4_1 muxControl (.in(subout[3:0]), .out(out), .sel(sel[3:2]));

endmodule

// Testbench for the module.
module mux16_1_testbench();
    logic out;
    logic [15:0] in;
    logic [3:0] sel;
    logic [3:0] subout;
    integer i, j;

    mux16_1 dut (.out, .in, .sel);

    initial begin
        for (i=0; i<16; i++) begin
            for (j=0; j<65536; j++) begin
                sel[3:0]=i; in[15:0]=j; #1000;
            end
        end
    end
endmodule