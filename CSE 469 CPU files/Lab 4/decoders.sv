// Arnav Mathur & Anthony Pham
// CSE 469
// 12/1/2022

// decoder modules
`timescale 1ps/1ps
module decoder2_4 (i, d, enable);
	input logic [1:0] i;
	output logic [3:0] d;
	input logic enable;
	
	logic ni0, ni1;
	
	not #50 inv0 (ni0, i[0]);
	not #50 inv1 (ni1, i[1]);
	
	and #50 d3 (d[3], i[0], i[1], enable);
	and #50 d2 (d[2], ni0, i[1], enable);
	and #50 d1 (d[1], i[0], ni1, enable);
	and #50 d0 (d[0], ni0, ni1, enable);
	
endmodule

module decoder3_8(i, d, enable);
	input logic [2:0] i;
	output logic [7:0] d;
	input logic enable;
	
	logic ni0, ni1, ni2;
	
	not #50 inv0 (ni0, i[0]);
	not #50 inv1 (ni1, i[1]);
	not #50 inv2 (ni2, i[2]);
	
	and #50 d0 (d[0], ni2, ni1, ni0, enable);
	and #50 d1 (d[1], ni2, ni1, i[0], enable);
	and #50 d2 (d[2], ni2, i[1], ni0, enable);
	and #50 d3 (d[3], ni2, i[1], i[0], enable);
	and #50 d4 (d[4], i[2], ni1, ni0, enable);
	and #50 d5 (d[5], i[2], ni1, i[0], enable);
	and #50 d6 (d[6], i[2], i[1], ni0, enable);
	and #50 d7 (d[7], i[2], i[1], i[0], enable);
	
endmodule
