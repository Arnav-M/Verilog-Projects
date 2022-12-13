// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// 32x1 mux
`timescale 1ps/1ps
module mux_32_1 (inputs, out, readReg);
	input logic [31:0] inputs; 
	input logic [4:0] readReg;
	output logic out;
	
	logic [7:0] stage1;
	logic [1:0] stage2;
	
	genvar i;
	generate
		for (i = 0; i < 8; i++) begin : building_mux
			mux4_1 inputs (.s(readReg[1:0]), .ins(inputs[i*4+3:i*4]), .out(stage1[i]));
		end
	endgenerate
	
	mux4_1 control1 (.s(readReg[3:2]), .ins(stage1[3:0]), .out(stage2[0]));
	mux4_1 control2 (.s(readReg[3:2]), .ins(stage1[7:4]), .out(stage2[1]));
	Mux2_1 outStage (.s0(readReg[4]), .a(stage2[0]), .b(stage2[1]), .out);

endmodule

// 2x1 mux
module Mux2_1 (s0, a, b, out);

	input logic a, b, s0;
	output logic out;
	
	logic temp0, temp1, ns0;
	
	not #50 inv0 (ns0, s0); 
	
	and #50 a0 (temp0, a, ns0);
	and #50 b1 (temp1, b, s0);
	
	or #50 outp (out, temp0, temp1);
	
endmodule

// 2x1 mux
module mux2_1 (s0, a, b, out);

	input logic a, b; 
	input logic s0;
	output logic out;
	
	logic temp0, temp1, ns0;
	
	not #50 inv0 (ns0, s0); 
	
	and #50 a0 (temp0, a, ns0);
	and #50 b1 (temp1, b, s0);
	
	or #50 outp (out, temp0, temp1);
	
endmodule

// 64 2x1 mux
module dataSel2_1 #(parameter WIDTH = 64) (s0, A, B, OUT);
	input logic [WIDTH-1:0] A, B; 
	input logic s0;
	output logic [WIDTH-1:0] OUT;
	
	genvar i;
	generate
		for (i = 0; i < WIDTH; i++) begin : eachBit
			mux2_1  mu (.s0, .a(A[i]), .b(B[i]), .out(OUT[i]));
		end
	endgenerate
	
endmodule

// 3x1 mux
module mux3_1 #(parameter WIDTH = 64) (A, B, C, sel, OUT);
    input logic [WIDTH-1:0] A, B, C;
    input logic [1:0] sel;

    output logic [WIDTH-1:0] OUT;

    logic [63:0] temp;
    genvar i;
	generate
		for (i = 0; i < WIDTH; i++) begin : eachBit
			mux2_1  stge1 (.s0(sel[0]), .a(A[i]), .b(B[i]), .out(temp[i]));
            mux2_1  stge2 (.s0(sel[1]), .a(temp[i]), .b(C[i]), .out(OUT[i]));
		end
	endgenerate
endmodule

// 4x1 mux
module mux4_1 (s, ins, out);
	input logic [3:0] ins;
	input logic  [1:0] s;
	output logic out;
	
	logic temp0, temp1, temp2, temp3;
	logic ns0, ns1;
	
	not #50 inv0 (ns0, s[0]);
	not #50 inv1 (ns1, s[1]);
	
	and #50 a0 (temp0, ins[0], ns1, ns0);
	and #50 b1 (temp1, ins[1], ns1, s[0]);
	and #50 c2 (temp2, ins[2], s[1], ns0);
	and #50 d3 (temp3, ins[3], s[1], s[0]);
	
	or #50 outp (out, temp0, temp1, temp2, temp3);
	
endmodule

// 8x1 mux
module mux8_1 (out, d, sel);
	input logic [7:0] d;
	input logic [2:0] sel;
	output logic out;
	
	logic mux0_out, mux1_out;

	mux4_1 mux0 (.s(sel[1:0]), .ins(d[3:0]), .out(mux0_out));
	mux4_1 mux1 (.s(sel[1:0]), .ins(d[7:4]), .out(mux1_out));
	mux2_1 mux2 (.s0(sel[2]), .a(mux0_out), .b(mux1_out), .out);

endmodule 
