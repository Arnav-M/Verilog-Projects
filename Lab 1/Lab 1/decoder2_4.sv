// Arnav Mathur
// EE 469
// 10/12/2022

`timescale 1ns/10ps

// Decoder with 2 inputs and 4 outputs.
module decoder2_4(in, out, en);
    output logic [3:0] out;
    input logic [1:0] in;
    input logic en;
    logic no, nz;
    parameter delay = 50;

	 not #delay n1 (nz, in[0]); // nz is !zero
    not #delay n2 (no, in[1]); // no is !one 
    
    and #delay a1 (out[0], no, nz, en);
    and #delay a2 (out[1], no, in[0], en);
    and #delay a3 (out[2], in[1], nz, en);
    and #delay a4 (out[3], in[1], in[0], en);
endmodule

// Testbench for the module.
module decoder2_4_testbench();
    logic [3:0] out;
    logic [1:0] in;
    logic en;
    integer i;
     
    decoder2_4 dut(.in, .out, .en);
    
    initial begin
        en = 1;
        for (i = 0; i < 4; i++) begin
            in[1:0] = i; #200;
        end

        en = 0;
        for (i = 0; i < 4; i++) begin
            in[1:0] = i; #200;
        end
    end
endmodule