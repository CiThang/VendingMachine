`timescale 1ns/1ps
`include "product_selector.v"
module product_selector_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg [1:0] product_sel;
    reg product_selector_en;
    reg timeout_flag;

    // Outputs
    wire [4:0] product_price;
    wire [1:0] product_out;
    wire product_selector_done;

    // Instantiate the Unit Under Test (UUT)
    product_selector uut (
        .clk(clk),
        .rst_n(rst_n),
        .product_sel(product_sel),
        .product_selector_en(product_selector_en),
        .timeout_flag(timeout_flag),
        .product_price(product_price),
        .product_out(product_out),
        .product_selector_done(product_selector_done)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("product_selector_tb.vcd");
        $dumpvars(0,product_selector_tb);
    end

    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        product_sel = 2'b00;
        product_selector_en = 0;
        timeout_flag = 0;

        // Reset
        #10 rst_n = 1;

        // === Test case 1: Chọn PRODUCT_A ===
        #10;
        product_sel = 2'b01; // PRODUCT_A
        product_selector_en = 1;
        #10;
        product_selector_en = 0; // Dừng chọn
        #10;
        timeout_flag = 1; // Giả lập hết thời gian
        #10;
        timeout_flag = 0;

        #20;

        // === Test case 2: Chọn PRODUCT_B ===
        product_sel = 2'b10; // PRODUCT_B
        product_selector_en = 1;
        #10;
        product_selector_en = 0;
        #10;
        timeout_flag = 1;
        #10;
        timeout_flag = 0;

        #20;

        // === Test case 3: Chọn PRODUCT_C ===
        product_sel = 2'b11; // PRODUCT_C
        product_selector_en = 1;
        #10;
        product_selector_en = 0;
        #10;
        timeout_flag = 1;
        #10;
        timeout_flag = 0;

        #20;

        // === Test case 4: chọn không hợp lệ ===
        product_sel = 2'b00; // invalid
        product_selector_en = 1;
        #10;
        product_selector_en = 0;
        #10;
        timeout_flag = 1;
        #10;
        timeout_flag = 0;

        #20;

        $finish;
    end

    initial begin
        $display("Time\tSel\tDone\tOut\tPrice");
        $monitor("%0dns\t%b\t%b\t%b\t%d", $time, product_sel, product_selector_done, product_out, product_price);
    end

endmodule
