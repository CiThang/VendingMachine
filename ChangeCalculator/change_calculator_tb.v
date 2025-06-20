`timescale 1ns/1ps
`include "change_calculator.v"
module change_calculator_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg [4:0] current_amount_display;
    reg [4:0] product_price;
    reg timeout_flag;
    reg change_calculator_en;

    // Outputs
    wire [4:0] change_out;
    wire change_calculator_done;

    // Instantiate the Unit Under Test (UUT)
    change_calculator uut (
        .clk(clk),
        .rst_n(rst_n),
        .current_amount_display(current_amount_display),
        .product_price(product_price),
        .timeout_flag(timeout_flag),
        .change_calculator_en(change_calculator_en),
        .change_out(change_out),
        .change_calculator_done(change_calculator_done)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        $dumpfile("change_calculator_tb.vcd");
        $dumpvars(0,change_calculator_tb);
    end


    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        current_amount_display = 0;
        product_price = 0;
        timeout_flag = 0;
        change_calculator_en = 0;

        // Reset
        #10 rst_n = 1;

        // === Test case 1: 25 - 15 = 10 ===
        #10;
        current_amount_display = 5'd25;
        product_price = 5'd15;
        change_calculator_en = 1;
        #10;
        change_calculator_en = 0;

        // Wait for timeout
        #10 timeout_flag = 1;
        #10 timeout_flag = 0;

        #20;

        // === Test case 2: 20 - 20 = 0 ===
        current_amount_display = 5'd20;
        product_price = 5'd20;
        change_calculator_en = 1;
        #10;
        change_calculator_en = 0;

        #10 timeout_flag = 1;
        #10 timeout_flag = 0;

        #20;

        // === Test case 3: 30 - 25 = 5 ===
        current_amount_display = 5'd30;
        product_price = 5'd25;
        change_calculator_en = 1;
        #10;
        change_calculator_en = 0;

        #10 timeout_flag = 1;
        #10 timeout_flag = 0;

        #20;

        $finish;
    end

    initial begin
        $display("Time\tCurrent\tPrice\tChange\tDone");
        $monitor("%0dns\t%d\t%d\t%d\t%b", $time, current_amount_display, product_price, change_out, change_calculator_done);
    end

endmodule
