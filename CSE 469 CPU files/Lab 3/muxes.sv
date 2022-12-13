`timescale 1ps/1ps

// Arnav Mathur & Anthony Pham
// CSE 469
// 11/18/2022

// Mux for 2 inputs
module mux2_1 (out, i0, i1, sel);
	parameter delay = 50;
	output logic out;
	input logic i0, i1, sel;
	logic i1AndSel, NotSel,  i0AndNotSel;
	
	and #delay (i1AndSel, i1, sel);
	not #delay (NotSel, sel);
	and #delay (i0AndNotSel, i0, NotSel);
	or #delay (out, i0AndNotSel, i1AndSel);

endmodule

module mux2_1_testbench();   
  logic i0, i1, sel;    
  logic out;   
     
  mux2_1 dut (.out, .i0, .i1, .sel);   
   
  initial begin   
    sel=0; i0=0; i1=0; #10;    
    sel=0; i0=0; i1=1; #10;    
    sel=0; i0=1; i1=0; #10;    
    sel=0; i0=1; i1=1; #10;    
    sel=1; i0=0; i1=0; #10;    
    sel=1; i0=0; i1=1; #10;    
    sel=1; i0=1; i1=0; #10;    
    sel=1; i0=1; i1=1; #10;    
  end   
endmodule

// Mux for 4 inputs.
module mux4_1(in, out, sel);
    output logic out;
    input logic [3:0] in;
    input logic [1:0] sel;
    logic [1:0] subout;

    mux2_1 mux1 (.out(subout[0]), .i0(in[0]), .i1(in[1]), .sel(sel[0]));
    mux2_1 mux2 (.out(subout[1]), .i0(in[2]), .i1(in[3]), .sel(sel[0]));
    mux2_1 mux3 (.out(out), .i0(subout[0]), .i1(subout[1]), .sel(sel[1]));

endmodule

// Mux for 8 inputs.
module mux8_1(in, out, sel);
    output logic out;
    input logic [7:0] in;
    input logic [2:0] sel;
    logic [1:0] subout;

    mux2_1 mux1 (.out(out), .i0(subout[0]), .i1(subout[1]), .sel(sel[2]));
    mux4_1 mux2 (.out(subout[1]), .in(in[7:4]), .sel(sel[1:0]));
    mux4_1 mux3 (.out(subout[0]), .in(in[3:0]), .sel(sel[1:0]));
endmodule


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
	
// Mux for 32 inputs.
module mux32_1(in, out, sel);
    output logic out;
    input logic [31:0] in;
    input logic [4:0] sel;
    logic [1:0] subout;

    mux16_1 mux1 (.in(in[15:0]), .out(subout[0]), .sel(sel[3:0]));
    mux16_1 mux2 (.in(in[31:16]), .out(subout[1]), .sel(sel[3:0]));
    mux2_1 muxControl (.out(out), .i0(subout[0]), .i1(subout[1]), .sel(sel[4]));
endmodule