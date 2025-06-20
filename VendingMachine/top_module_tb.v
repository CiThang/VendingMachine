// File: top_module_tb.v

`timescale 1ns/1ps
`include "top_module.v"
module top_module_tb;

    // Clock and reset
    reg clk;
    reg rst_n;
    
    // Inputs
    reg [1:0] coin_in;
    reg [1:0] product_sel;
    reg cancel;

    // Outputs
    wire [2:0] state_out;
    wire [6:0] amount_display_seg_a;
    wire [6:0] amount_display_seg_b;
    wire [1:0] product_out;
    wire [4:0] change_out;
    wire [7:0] status_display;
    wire [3:0] led_indicators;
    wire [4:0] current_amount_display;

    // Instantiate DUT
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .coin_in(coin_in),
        .product_sel(product_sel),
        .cancel(cancel),
        .state_out(state_out),
        .amount_display_seg_a(amount_display_seg_a),
        .amount_display_seg_b(amount_display_seg_b),
        .product_out(product_out),
        .change_out(change_out),
        .status_display(status_display),
        .led_indicators(led_indicators),
        .current_amount_display(current_amount_display)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    // Test stimulus
    initial begin
        $dumpfile("top_module_tb.vcd");
        $dumpvars(0, top_module_tb);

        // Initial values
        clk = 0;
        rst_n = 0;
        coin_in = 2'b00;
        product_sel = 2'b00;
        cancel = 0;

        // Reset sequence
        #20;
        rst_n = 1;

        // Insert coin 5đ
        coin_in = 2'b10;
        #10; coin_in = 2'b00;
       

        // Insert coin 5đ
        #10; coin_in = 2'b10;
        #10; coin_in = 2'b00;
       

        // Insert coin 10đ
        #10; coin_in = 2'b11;
        #10; coin_in = 2'b00;
        
    

        // Select product B (15đ)
        #40; product_sel = 2'b01;

        // Wait
        #1000;

        // Finish
        $finish;
    end

endmodule
