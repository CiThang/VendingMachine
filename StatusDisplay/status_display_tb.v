`timescale 1ns/1ps
`include "status_display.v"
module status_display_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg cancel;
    reg display_status_en;
    reg product_dispense_done;
    reg change_dispense_done;
    reg [2:0] state_out;

    // Outputs
    wire [7:0] status_display;
    wire [3:0] led_indicators;

    // Instantiate DUT
    status_display uut (
        .clk(clk),
        .rst_n(rst_n),
        .cancel(cancel),
        .display_status_en(display_status_en),
        .product_dispense_done(product_dispense_done),
        .change_dispense_done(change_dispense_done),
        .state_out(state_out),
        .status_display(status_display),
        .led_indicators(led_indicators)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $dumpfile("status_display_tb.vcd");
        $dumpvars(0,status_display_tb);
        // Khởi tạo
        clk = 0;
        rst_n = 0;
        cancel = 0;
        display_status_en = 0;
        product_dispense_done = 0;
        change_dispense_done = 0;
        state_out = 3'b000;

        // Reset
        #10 rst_n = 1;

        // 1. Test trạng thái IDLE
        display_status_en = 1;
        state_out = 3'b000;
        #10;

        // 2. Test trạng thái WAIT_COIN
        state_out = 3'b001;
        #10;

        // 3. Test trạng thái SELECT_PRODUCT (chưa xong)
        state_out = 3'b010;
        product_dispense_done = 0;
        #10;

        // 4. SELECT_PRODUCT với product_dispense_done = 1
        product_dispense_done = 1;
        #10;

        // 5. Test trạng thái DISPENSE_CHANGE (chưa xong)
        state_out = 3'b011;
        change_dispense_done = 0;
        #10;

        // 6. DISPENSE_CHANGE xong
        change_dispense_done = 1;
        #10;

        // 7. Test RETURN_MONEY (không cancel)
        state_out = 3'b100;
        cancel = 0;
        #10;

        // 8. RETURN_MONEY khi cancel = 1
        cancel = 1;
        #30;

        // 9. Vô hiệu hóa display
        display_status_en = 0;
        state_out = 3'b010;
        #10;

        $finish;
    end

endmodule
