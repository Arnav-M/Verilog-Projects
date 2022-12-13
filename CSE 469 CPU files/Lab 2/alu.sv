// Arnav Mathur
// EE 469
// 1/26/2022

`timescale 1ps/1ps

// This is the module for the whole alu.
module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
    output logic zero, overflow, carry_out, negative;
    output logic [63:0] result;
    input logic [2:0] cntrl;
    input logic [63:0] A, B;
    parameter delay = 50;
    logic [15:0] tempa;
    logic [3:0] tempb;
    logic [63:0] aluout;
    logic [63:0][7:0] muxinput;
    logic [63:0] andOut, orOut, xorOut;

    // construct 64 bit adder
    bitAddSub64 cal64(.A(A), .B(B), .result(aluout), .sub(cntrl[0]), .carryOut(carry_out), .overflow(overflow));
    bitwiseAnd an(.out(andOut), .a(A), .b(B));
    bitwiseOr bn(.out(orOut), .a(A), .b(B));
    bitwiseXOR cn(.out(xorOut), .a(A), .b(B));

    assign negative = result[63];

    genvar i;
    generate
        for (i = 0; i < 16; i++) begin : eachOr
            or #delay orgate(tempa[i], aluout[i*4], aluout[i*4+1], aluout[i*4+2], aluout[i*4+3]);
        end
    endgenerate

    generate
        for (i = 0; i < 4; i++) begin : eachSecondOr
            or #delay orgate(tempb[i], tempa[i*4], tempa[i*4+1], tempa[i*4+2], tempa[i*4+3]);
        end
    endgenerate

    nor #delay zeroDetect(zero, tempb[0], tempb[1], tempb[2], tempb[3]);

    // connect mux
    generate
        for (i = 0; i < 64; i++) begin : eachwire
            assign muxinput[i][0] = B[i];
            assign muxinput[i][2] = aluout[i];
            assign muxinput[i][3] = aluout[i];
            assign muxinput[i][4] = andOut[i];
            assign muxinput[i][5] = orOut[i];
            assign muxinput[i][6] = xorOut[i];
        end
    endgenerate
    
    // construct mux
    generate
        for (i = 0; i < 64; i++) begin : eachMux
            mux8_1 controlMux(.in(muxinput[i][7:0]), .out(result[i]), .sel(cntrl[2:0]));
        end
    endgenerate
endmodule