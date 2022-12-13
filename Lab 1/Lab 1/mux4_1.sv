// Arnav Mathur
// EE 469
// 10/12/2022

`timescale 1ns/10ps

// Mux for 4 inputs.
module mux4_1(in, out, sel);
    output logic out;
    input logic [3:0] in;
    input logic [1:0] sel;
    logic [1:0] subout;

    mux2_1 mux1 (.in(in[1:0]), .out(subout[0]), .sel(sel[0]));
    mux2_1 mux2 (.in(in[3:2]), .out(subout[1]), .sel(sel[0]));
    mux2_1 mux3 (.in(subout[1:0]), .out(out), .sel(sel[1]));

endmodule

// Testbench for the module.
module mux4_1_testbench();
    logic [3:0] in;
    logic [1:0] sel;
    logic out;
    integer i, j;

    mux4_1 dut (.out, .in, .sel);
    
    initial begin
        for (i=0; i<4; i++) begin
            for (j=0; j<16; j++) begin
                sel[1:0]=i; in[3:0]=j; #1000;
            end
        end
    end
endmodule