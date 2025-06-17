`timescale 1ns/1ps
`include "display_controller.v"

module display_controller_tb;

    // Inputs
    reg [4:0] current_amount;

    // Outputs
    wire [6:0] seg_a;
    wire [6:0] seg_b;
    wire [4:0] current_amount_display;

    // Instantiate the module under test
    display_controller uut (
        .current_amount(current_amount),
        .seg_a(seg_a),
        .seg_b(seg_b),
        .current_amount_display(current_amount_display)
    );

    initial begin
        $display("=== BẮT ĐẦU TEST display_controller ===");
        $dumpfile("display_controller_tb.vcd");
        $dumpvars(0, display_controller_tb);

        // Test 1: current_amount = 0
        current_amount = 0;
        #10;
        $display("Test 1: current_amount = %2d, current_amount_display = %2d, seg_a = %b, seg_b = %b",
                 current_amount, current_amount_display, seg_a, seg_b);

        // Test 2: current_amount = 9
        current_amount = 9;
        #10;
        $display("Test 2: current_amount = %2d, current_amount_display = %2d, seg_a = %b, seg_b = %b",
                 current_amount, current_amount_display, seg_a, seg_b);

        // Test 3: current_amount = 15
        current_amount = 15;
        #10;
        $display("Test 3: current_amount = %2d, current_amount_display = %2d, seg_a = %b, seg_b = %b",
                 current_amount, current_amount_display, seg_a, seg_b);

        // Test 4: current_amount = 23
        current_amount = 23;
        #10;
        $display("Test 4: current_amount = %2d, current_amount_display = %2d, seg_a = %b, seg_b = %b",
                 current_amount, current_amount_display, seg_a, seg_b);

        // Test 5: current_amount = 31
        current_amount = 31;
        #10;
        $display("Test 5: current_amount = %2d, current_amount_display = %2d, seg_a = %b, seg_b = %b",
                 current_amount, current_amount_display, seg_a, seg_b);

        $display("=== KẾT THÚC TEST ===");
        $finish;
    end

endmodule
