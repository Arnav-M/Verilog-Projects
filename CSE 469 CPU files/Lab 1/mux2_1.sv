// Arnav Mathur
// EE 469
// 10/12/2022

`timescale 1ps/1ps

// Mux for 2 inputs.
module mux2_1(out, in, sel);
    output logic out;
    input logic [1:0] in;
    input logic sel;
    parameter delay = 50;
    logic i1, i2, i3;

    not #delay n1 (i1, sel);
    and #delay a1 (i2, in[0], i1);
    and #delay a2 (i3, in[1], sel);
    or #delay o1 (out, i2, i3);

endmodule

// Testbench for the module.
module mux2_1_testbench();
    logic [1:0] in;
    logic sel;
    logic out;
    
    mux2_1 dut (.out, .in, .sel);
    
    initial begin
        sel=0; in[0]=0; in[1]=0; #500;
        sel=0; in[0]=0; in[1]=1; #500;
        sel=0; in[0]=1; in[1]=0; #500;
        sel=0; in[0]=1; in[1]=1; #500;
        sel=1; in[0]=0; in[1]=0; #500;
        sel=1; in[0]=0; in[1]=1; #500;
        sel=1; in[0]=1; in[1]=0; #500;
        sel=1; in[0]=1; in[1]=1; #500;
        #500;
    end
endmodule