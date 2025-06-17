`timescale 1ns/1ps
`include "fsm_controller.v"
module fsm_controller_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg cancel;
    reg [1:0] product_sell;
    reg enough_money;
    reg timeout_flag;
    reg product_dispense_done;
    reg change_dispense_done;

    // Outputs
    wire [2:0] state_out;
    wire signal_display_controller;
    wire display_status_en;
    wire display_amount_en;
    wire signal_change_calculator;
    wire change_dispense_en;
    wire product_dispense_en;
    wire signal_product_selector;
    wire [1:0] start_timer;

    // Instantiate DUT
    fsm_controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .cancel(cancel),
        .product_sell(product_sell),
        .enough_money(enough_money),
        .timeout_flag(timeout_flag),
        .product_dispense_done(product_dispense_done),
        .change_dispense_done(change_dispense_done),
        .state_out(state_out),
        .signal_display_controller(signal_display_controller),
        .display_status_en(display_status_en),
        .display_amount_en(display_amount_en),
        .signal_change_calculator(signal_change_calculator),
        .change_dispense_en(change_dispense_en),
        .product_dispense_en(product_dispense_en),
        .signal_product_selector(signal_product_selector),
        .start_timer(start_timer)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $dumpfile("fsm_controller_tb.vcd");
        $dumpvars(0,fsm_controller_tb);
    end

    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        cancel = 0;
        product_sell = 2'b00;
        enough_money = 0;
        timeout_flag = 0;
        product_dispense_done = 0;
        change_dispense_done = 0;

        // Reset pulse
        #10 rst_n = 1;

        // Wait for FSM to go to WAIT_COIN
        #10;

        // Enough money inserted
        enough_money = 1;
        #10 enough_money = 0;

        // Wait for SELECT_PRODUCT
        #10;

        // Simulate user choosing product, trigger dispense
        product_dispense_done = 1;
        timeout_flag = 1;
        #10;
        product_dispense_done = 0;
        timeout_flag = 0;

        // Simulate change dispense done
        change_dispense_done = 1;
        #10 change_dispense_done = 0;

        // Back to IDLE
        #40;

 

        $finish;
    end

endmodule
