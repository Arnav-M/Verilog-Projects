// Arnav Mathur
// CSE 469
// 10/26/2022

`timescale 1ps/1ps

// 64 bit adder and subtractor
module bitAddSub64(A, B, result, sub, carryOut, overflow);
    input logic [63:0] A, B;
    input logic sub;
    output logic [63:0] result;
    output logic carryOut, overflow;
    logic [63:0] Cout_all;

    assign carryOut = Cout_all[63];
    xor #50 overflowDetect(overflow, Cout_all[63], Cout_all[62]);

    bitAddSub firstBit (.a(A[0]), .b(B[0]), .out(result[0]), .Cin(sub), .Cout(Cout_all[0]), .sub(sub));
    
    genvar i;
    generate
        for (i = 1; i < 64; i++) begin : eachAddSub
            bitAddSub AddSub (.a(A[i]), .b(B[i]), .out(result[i]), .Cin(Cout_all[i-1]), .Cout(Cout_all[i]), .sub(sub));
        end
    endgenerate
endmodule

// Testbench for module.
module bitAddSub64_testbench();
    logic [63:0] A, B, result;
    logic sub, carryOut, overflow;

    bitAddSub64 dut (.A, .B, .result, .sub, .carryOut, .overflow);
    
    parameter delay = 10000;

    initial begin
        A=0; B=10; sub=0; #delay;
        A=91; B=0; sub=0; #delay;
        A=0; B=0; sub=0; #delay;
        A=-40; B=10; sub=0; #delay;
        A=-23; B=-11; sub=0; #delay;
        A=38; B=10; sub=1; #delay;
        A=-100; B=10; sub=1; #delay;
        A=0; B=4; sub=1; #delay;
        A=45; B=-204; sub=1; #delay;
        A=10; B=24; sub=1; #delay;
        A=64'hFFFFFFFFFFFFFFFF; B=1; sub=1; #delay;
        #delay;
    end
endmodule