`timescale 1ns/1ps
`include "timer.v"
module timer_tb;

    reg clk;
    reg rst_n;
    reg [1:0] start_timer;
    wire timeout_flag;

    // Instantiate timer
    timer uut (
        .clk(clk),
        .rst_n(rst_n),
        .start_timer(start_timer),
        .timeout_flag(timeout_flag)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    initial begin
        $dumpfile("timer_tb.vcd");
        $dumpvars(0, timer_tb);

        // Khởi tạo
        rst_n = 0;
        start_timer = 2'b00;
        #20;
        rst_n = 1;

        // Test chế độ WAIT_SELECT
        @(negedge clk);
        start_timer = 2'b01; // WAIT_SELECT
        @(negedge clk);
        start_timer = 2'b00;

        wait(timeout_flag == 1);
        $display("WAIT_SELECT timeout at time %t", $time);

        // Test chế độ PRODUCT_RETURN
        @(negedge clk);
        start_timer = 2'b10;
        @(negedge clk);
        start_timer = 2'b00;

        wait(timeout_flag == 1);
        $display("PRODUCT_RETURN timeout at time %t", $time);

        // Test chế độ CHANGE_RETURN
        @(negedge clk);
        start_timer = 2'b11;
        @(negedge clk);
        start_timer = 2'b00;

        wait(timeout_flag == 1);
        $display("CHANGE_RETURN timeout at time %t", $time);

        $finish;
    end

endmodule
