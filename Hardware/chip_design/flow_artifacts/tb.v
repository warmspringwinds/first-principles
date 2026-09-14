`timescale 1ns/1ps
module tb;
    reg clk = 0, rst_n = 0, clear = 0, en = 0;
    reg [3:0] a = 0, b = 0;
    wire [7:0] acc;
    reg [7:0] expected = 0;
    integer i, errors = 0;

    mac4 dut (.clk(clk), .rst_n(rst_n), .clear(clear), .en(en), .a(a), .b(b), .acc(acc));
    always #0.5 clk = ~clk;                       // 1 GHz clock: the target we will constrain to

    initial begin
        $dumpfile("waves.vcd"); $dumpvars(0, tb);
        #1.2 rst_n = 1;
        // directed test: 3*5, then 2*7, then clear, then 15*15
        @(negedge clk) en = 1; a = 3;  b = 5;
        @(negedge clk) a = 2;  b = 7;
        @(negedge clk) en = 0; clear = 1;
        @(negedge clk) clear = 0; en = 1; a = 15; b = 15;
        @(negedge clk) en = 0;
        // constrained-random test: 200 cycles against the reference model
        for (i = 0; i < 200; i = i + 1) begin
            @(negedge clk);
            a = $random; b = $random; en = ($random % 4) != 0; clear = ($random % 16) == 0;
        end
        @(negedge clk) $display("random test done: %0d mismatches", errors); $finish;
    end

    // the reference model + scoreboard, checked at every clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) expected <= 0;
        else if (clear) expected <= 0;
        else if (en) expected <= expected + a * b;
    end
    always @(negedge clk) if (rst_n && acc !== expected) begin
        errors = errors + 1;
        $display("MISMATCH t=%0t acc=%0d expected=%0d", $time, acc, expected);
    end
endmodule
