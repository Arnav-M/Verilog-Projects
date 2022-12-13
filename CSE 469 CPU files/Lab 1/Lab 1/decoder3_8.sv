// Arnav Mathur
// EE 469
// 10/12/2022

`timescale 1ns/10ps

// Decoder for 3 inputs and 8 outputs.
module decoder3_8(in, out, en);
    output logic[7:0] out;
    input logic [2:0] in;
    input logic en;
    logic nt, no, nz;
    parameter delay = 50;

    not #delay n1 (nz, in[0]); // nz is !zero (00)
    not #delay n2 (no, in[1]); // no is !one (01)
    not #delay n3 (nt, in[2]); // nt is !two (02)

    and #delay a1 (out[0], nt, no, nz, en);
    and #delay a2 (out[1], nt, no, in[0], en);
    and #delay a3 (out[2], nt, in[1], nz, en);
    and #delay a4 (out[3], nt, in[1], in[0], en);
    and #delay a5 (out[4], in[2], no, nz, en);
    and #delay a6 (out[5], in[2],no, in[0], en);
    and #delay a7 (out[6], in[2], in[1], nz, en);
    and #delay a8 (out[7], in[2], in[1], in[0], en);
endmodule

// Testbench for the module.
module decoder3_8_testbench();
    logic [7:0] out;
    logic [2:0] in;
    logic en;
    integer i;
     
    decoder3_8 dut(.in, .out, .en);
    
    initial begin
        en = 1;
        for (i = 0; i < 8; i++) begin
            in[2:0] = i; #500;
        end

        en = 0;
        for (i = 0; i < 8; i++) begin
            in[2:0] = i; #500;
        end
    end
endmodule