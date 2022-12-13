// Arnav Mathur
// EE 469
// 1/26/2022

`timescale 1ps/1ps

// module for one bit adder and subtractor
module bitAddSub(a, b, out, Cin, Cout, sub);
    input logic a, b, Cin, sub;
    output logic out, Cout;
    logic notB, muxOut, xor1, and1, and2;

    parameter delay = 50;

    not #delay n1 (notB, b);
    xor #delay x1 (xor1, a, muxOut);
    xor #delay x2 (out, xor1, Cin);
    and #delay a1 (and1, Cin, xor1);
    and #delay a2 (and2, a, muxOut);
    or #delay o1 (Cout, and1, and2);
    mux2_1 mux (.out(muxOut), .in({notB, b}), .sel(sub));
endmodule

// Testbench for module.
module bitAddSub_testbench();
    logic a, b, out, Cin, Cout, sub;

    bitAddSub dut (.a, .b, .out, .Cin, .Cout, .sub);
    
    initial begin
        a=0; b=0; Cin=0; sub=0; #1000;
        a=0; b=0; Cin=1; sub=0; #1000;
        a=0; b=1; Cin=0; sub=0; #1000;
        a=0; b=1; Cin=1; sub=0; #1000;
        a=1; b=0; Cin=0; sub=0; #1000;
        a=1; b=0; Cin=1; sub=0; #1000;
        a=1; b=1; Cin=0; sub=0; #1000;
        a=1; b=1; Cin=1; sub=0; #1000;
        a=0; b=0; Cin=0; sub=1; #1000;
        a=0; b=0; Cin=1; sub=1; #1000;
        a=0; b=1; Cin=0; sub=1; #1000;
        a=0; b=1; Cin=1; sub=1; #1000;
        a=1; b=0; Cin=0; sub=1; #1000;
        a=1; b=0; Cin=1; sub=1; #1000;
        a=1; b=1; Cin=0; sub=1; #1000;
        a=1; b=1; Cin=1; sub=1; #1000;
        #1000;
    end
endmodule