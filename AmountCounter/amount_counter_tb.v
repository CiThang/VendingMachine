`timescale 1ns/1ps
`include "amount_counter.v"
module amount_counter_tb;

    // Khai báo tín hiệu kết nối với DUT
    reg clk;
    reg rst_n;
    reg cancel;
    reg [4:0] current_amount;
    reg [4:0] product_price;
    wire enough_money;

    // Khởi tạo module cần test (DUT)
    amount_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .cancel(cancel),
        .current_amount(current_amount),
        .product_price(product_price),
        .enough_money(enough_money)
    );

    // Tạo xung clock 10ns (tần số 100MHz)
    always #5 clk = ~clk;

    initial begin
        $display("=== BẮT ĐẦU TEST amount_counter ===");
        $dumpfile("amount_counter_tb.vcd");
        $dumpvars(0, amount_counter_tb);

        // Khởi tạo các giá trị ban đầu
        clk = 0;
        rst_n = 0;
        cancel = 0;
        current_amount = 5'd0;
        product_price = 5'd10; // Sản phẩm giá 10đ

        // Reset hệ thống
        #10;
        rst_n = 1;

        // Test 1: current_amount = 5 -> chưa đủ
        #10;
        current_amount = 5;
        #10;
        $display("Test 1: current_amount = %d, product_price = %d, enough_money = %b (expect 0)",
                 current_amount, product_price, enough_money);

        // Test 2: current_amount = 10 -> đủ tiền
        #10;
        current_amount = 10;
        #10;
        $display("Test 2: current_amount = %d, product_price = %d, enough_money = %b (expect 1)",
                 current_amount, product_price, enough_money);

        // Test 3: current_amount = 15 -> đủ tiền
        #10;
        current_amount = 15;
        #10;
        $display("Test 3: current_amount = %d, product_price = %d, enough_money = %b (expect 1)",
                 current_amount, product_price, enough_money);

        // Test 4: cancel = 1 -> dù có đủ tiền cũng phải reset cờ
        #10;
        cancel = 1;
        #10;
        $display("Test 4: CANCEL -> enough_money = %b (expect 0)", enough_money);
        cancel = 0;

        // Test 5: Reset hệ thống
        #10;
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
        $display("Test 5: RESET -> enough_money = %b (expect 0)", enough_money);

        #10;
        $display("=== KẾT THÚC TEST ===");
        $finish;
    end

endmodule
