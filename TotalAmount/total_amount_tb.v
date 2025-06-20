`timescale 1ns/1ps
`include "total_amount.v"
module total_amount_tb;

    // Inputs
    reg clk, rst_n, cancel, coin_valid, timeout_flag;
    reg [4:0] coin_value;
    reg [1:0] product_sel;

    // Outputs
    wire [4:0] current_amount;
    wire total_amount_done;
    wire coin_value_in;

    // Instantiate the total_amount module
    total_amount uut (
        .clk(clk),
        .rst_n(rst_n),
        .cancel(cancel),
        .coin_value(coin_value),
        .coin_valid(coin_valid),
        .product_sel(product_sel),
        .timeout_flag(timeout_flag),
        .current_amount(current_amount),
        .total_amount_done(total_amount_done),
        .coin_value_in(coin_value_in)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns period

    initial begin
        $dumpfile("total_amount_tb.vcd");
        $dumpvars(0,total_amount_tb);
    end


    initial begin
        // Initial values
        clk = 0;
        rst_n = 0;
        cancel = 0;
        coin_value = 5'd0;
        coin_valid = 0;
        product_sel = 2'b00;
        timeout_flag = 0;

        // Reset
        #12; rst_n = 1;

        // --- Test 1: Insert 5đ ---
        #10; coin_value = 5'd5; coin_valid = 1;
        #10; coin_valid = 0;

        // --- Test 2: Insert 10đ ---
        #10; coin_value = 5'd10; coin_valid = 1;
        #10; coin_valid = 0;

        // --- Test 3: Insert 1đ ---
        #10; coin_value = 5'd1; coin_valid = 1;
        #10; coin_valid = 0;

        // --- Test 4: Select product ---
        #10; product_sel = 2'b01;
       

        // --- Test 5: Timeout ---
        #10; timeout_flag = 1;
        #10; timeout_flag = 0;

        // --- Test 6: Cancel ---
        #10; cancel = 1;
        #10; cancel = 0;

        #20;
        $finish;
    end

    initial begin
        $monitor("T=%0t | coin_value=%2d | coin_valid=%b | coin_value_in=%b | temp_amt=%2d | curr_amt=%2d | done=%b | product_sel=%b | cancel=%b | timeout=%b",
                 $time, coin_value, coin_valid, coin_value_in,
                 uut.temp_current_amount,
                 current_amount, total_amount_done,
                 product_sel, cancel, timeout_flag);
    end

endmodule
