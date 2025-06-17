`timescale 1ns / 1ps
`include "timer.v"
module timer_tb;

    // Parameters để test nhanh
    parameter TIME_WAIT_SELECT   = 5'd10;
    parameter TIME_PRODUCT_RETURN = 5'd4;
    parameter TIME_CHANGE_RETURN  = 5'd3;

    // Inputs
    reg clk;
    reg rst_n;
    reg [1:0] start_timer;

    // Outputs
    wire timeout_flag;
    wire [4:0] debug_counter;

    // Instantiate the Unit Under Test
    timer #(
        .TIME_WAIT_SELECT(TIME_WAIT_SELECT),
        .TIME_PRODUCT_RETURN(TIME_PRODUCT_RETURN),
        .TIME_CHANGE_RETURN(TIME_CHANGE_RETURN)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .start_timer(start_timer),
        .timeout_flag(timeout_flag),
        .debug_counter(debug_counter)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    // Task để test chế độ
    task test_mode(input [1:0] mode, input [4:0] wait_time);
        integer i;
        begin
            start_timer = mode;
            #10; // chờ 1 chu kỳ để load counter
            for (i = 0; i <= wait_time + 2; i = i + 1) begin
                #10;
                $display("Time: %0t | Mode: %b | Counter: %2d | Timeout: %b", 
                    $time, start_timer, debug_counter, timeout_flag);
            end
            $display("=== Done Testing Mode %b ===\n", mode);
        end
    endtask

    initial begin
        // Ghi waveform nếu cần
        $dumpfile("timer_tb.vcd");
        $dumpvars(0, timer_tb);

        // Khởi tạo
        clk = 0;
        rst_n = 0;
        start_timer = 2'b00;

        #20 rst_n = 1;

        // Test từng chế độ
        test_mode(2'b00, TIME_WAIT_SELECT);     // WAIT_SELECT
        test_mode(2'b01, TIME_PRODUCT_RETURN);  // PRODUCT_RETURN
        test_mode(2'b10, TIME_CHANGE_RETURN);   // CHANGE_RETURN

        // Kết thúc mô phỏng
        $finish;

    end

endmodule
