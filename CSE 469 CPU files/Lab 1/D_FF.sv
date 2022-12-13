// Arnav Mathur
// EE 469
// 10/12/2022

`timescale 1ns/10ps

// Flip-flop module.
module D_FF (q, d, reset, clk);
    output reg q;
    input d, reset, clk;
    
    always_ff @(posedge clk)
    if (reset)
        q <= 0; // On reset, set to 0
    else
        q <= d; // Otherwise out = d
endmodule 

// Testbench for the module.
module D_FF_testbench();
    logic q, d, reset, clk;

    D_FF dut(.q, .d, .reset, .clk);

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        @(posedge clk); reset <= 1; d <= 0;
        @(posedge clk); reset <= 0;
        @(posedge clk); d <= 0;
        @(posedge clk); d <= 1;
        @(posedge clk); d <= 0;
        @(posedge clk); d <= 1;
        @(posedge clk); d <= 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        $stop;
    end
endmodule