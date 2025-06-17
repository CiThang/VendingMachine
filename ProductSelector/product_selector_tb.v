`timescale 1ns/1ps
`include "product_selector.v"
module product_selector_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg [1:0] product_sel;
    reg product_dispense_en;
    reg signal_product_selector;

    // Outputs
    wire [4:0] product_price;
    wire [1:0] product_out;
    wire product_dispense_done;

    // Instantiate DUT
    product_selector uut (
        .clk(clk),
        .rst_n(rst_n),
        .product_sel(product_sel),
        .product_dispense_en(product_dispense_en),
        .signal_product_selector(signal_product_selector),
        .product_price(product_price),
        .product_out(product_out),
        .product_dispense_done(product_dispense_done)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock

    initial begin
        $dumpfile("product_selector_tb.vcd");
        $dumpvars(0, product_selector_tb);
    end

    initial begin
        // Initial values
        clk = 0;
        rst_n = 0;
        product_sel = 2'b00;
        product_dispense_en = 0;
        signal_product_selector = 0;

        // Reset
        #10;
        rst_n = 1;

        // Test case 1: select PRODUCT_A
        #10;
        product_sel = 2'b01;
        signal_product_selector = 1;
        product_dispense_en=1;
        // #10;
        // signal_product_selector = 0;

        // // Test case 2: select PRODUCT_B
        // #10;
        // product_sel = 2'b01;
        // signal_product_selector = 1;
        // #10;
        // signal_product_selector = 0;

        // // Test case 3: enable dispense
        // #10;
        // product_dispense_en = 1;
        // #10;
        // product_dispense_en = 0;

        // // Test case 4: select PRODUCT_C
        // #10;
        // product_sel = 2'b10;
        // signal_product_selector = 1;
        // #10;
        // signal_product_selector = 0;

        #20;
        $finish;
    end

endmodule
 