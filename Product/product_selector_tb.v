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
    wire product_selector_done;

    // Instantiate the DUT
    product_selector uut (
        .clk(clk),
        .rst_n(rst_n),
        .product_sel(product_sel),
        .product_dispense_en(product_dispense_en),
        .signal_product_selector(signal_product_selector),
        .product_price(product_price),
        .product_out(product_out),
        .product_dispense_done(product_dispense_done),
        .product_selector_done(product_selector_done)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns period

    // Task for product selection test
    task select_product(input [1:0] sel);
        begin
            product_sel = sel;
            signal_product_selector = 1;
            #10;
            signal_product_selector = 0;
            product_dispense_en = 1;
            #10;
            product_dispense_en = 0;
        end
    endtask

    initial begin
        $dumpfile("product_selector_tb.vcd");
        $dumpvars(0,product_selector_tb);

    end


    initial begin
        
        $display("=== Starting product_selector test ===");
        
        // Initialize
        clk = 0;
        rst_n = 0;
        product_sel = 2'b00;
        product_dispense_en = 0;
        signal_product_selector = 0;

        // Reset pulse
        #10 rst_n = 1;

        // Test PRODUCT_A: 2'b01
        #10;
        $display("Selecting PRODUCT_A");
        select_product(2'b01);
        #10;

        // // Test PRODUCT_B: 2'b10
        // $display("Selecting PRODUCT_B");
        // select_product(2'b10);
        // #10;

        // // Test PRODUCT_C: 2'b11
        // $display("Selecting PRODUCT_C");
        // select_product(2'b11);
        // #10;

        // Test invalid input: 2'b00
        $display("Selecting INVALID PRODUCT");
        select_product(2'b00);
        #10;

        $display("=== Simulation complete ===");
        $finish;
    end

endmodule
