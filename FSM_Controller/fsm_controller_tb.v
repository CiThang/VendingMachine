`timescale 1ns/1ps
`include "fsm_controller.v"

module fsm_controller_tb;

    // Clock và reset
    reg clk;
    reg rst_n;

    // Input của FSM
    reg cancel;
    reg [1:0] product_sell;
    reg total_amount_done;
    reg timeout_flag;
    reg coin_value_in;
    reg product_selector_done;
    reg change_calculator_done;

    // Output
    wire [2:0] state_out;
    wire change_calculator_en;
    wire product_selector_en;
    wire [7:0] status_diplay;
    wire [3:0] led_indicators;
    wire [1:0] start_timer;

    // Instantiate DUT
    fsm_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .cancel(cancel),
        .product_sell(product_sell),
        .total_amount_done(total_amount_done),
        .timeout_flag(timeout_flag),
        .coin_value_in(coin_value_in),
        .product_selector_done(product_selector_done),
        .change_calculator_done(change_calculator_done),
        .state_out(state_out),
        .change_calculator_en(change_calculator_en),
        .product_selector_en(product_selector_en),
        .status_diplay(status_diplay),
        .led_indicators(led_indicators),
        .start_timer(start_timer)
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz

    initial begin
        $dumpfile("fsm_controller_tb.vcd");
        $dumpvars(0, fsm_controller_tb);

        // Initial values
        clk = 0;
        rst_n = 0;
        cancel = 0;
        product_sell = 2'b00;
        total_amount_done = 0;
        timeout_flag = 0;
        coin_value_in = 0;
        product_selector_done = 0;
        change_calculator_done = 0;

        // Reset
        #10;
        rst_n = 1;

        // Chờ FSM chuyển từ IDLE → WAIT_COIN
        #20;

        // Nhét xu lần 1 → kích hoạt timer
        coin_value_in = 1;
        #10;
        coin_value_in = 0;

        // Nhét xu lần 2 → reset lại timer
        #30;
        coin_value_in = 1;
        #10;
        coin_value_in = 0;

        // Người dùng chọn sản phẩm → total_amount_done
        #20;
        total_amount_done = 1;
        #10;
        total_amount_done = 0;

        // Kích hoạt product selector, chờ timeout
        #10;
        timeout_flag = 1;
        product_selector_done = 1;
        #10;
        timeout_flag = 0;
        product_selector_done = 0;

        // FSM sang DISPENSE_PRODUCT rồi tự chuyển sang CHANGE_CALCULATOR
        #20;
        change_calculator_done = 1;
        #10;
        change_calculator_done = 0;

        // Kết thúc mô phỏng
        #50;
        $finish;
    end

endmodule
