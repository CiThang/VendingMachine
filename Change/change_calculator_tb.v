`timescale 1ns / 1ps
`include "change_calculator.v"
module change_calculator_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg [4:0] current_amount_display;
    reg [4:0] product_price;
    reg change_dispense_en;
    reg single_change_calculator;

    // Outputs
    wire [4:0] change_out;
    wire change_dispense_done;

    // Instantiate the UUT
    change_calculator uut (
        .clk(clk),
        .rst_n(rst_n),
        .current_amount_display(current_amount_display),
        .product_price(product_price),
        .change_dispense_en(change_dispense_en),
        .single_change_calculator(single_change_calculator),
        .change_out(change_out),
        .change_dispense_done(change_dispense_done)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10ns period

    // Task to run a single test case
        task run_test(
        input [4:0] money,
        input [4:0] price,
        input [127:0] desc  // dùng reg kiểu vector thay cho string
    );
        begin
            $display("=== %s ===", desc);
            current_amount_display = money;
            product_price = price;
            single_change_calculator = 1;
            change_dispense_en = 1;
            #10;

            change_dispense_en = 1;
            #10;

            change_dispense_en = 0;
            single_change_calculator = 0;
            #10;

            $display("Time: %0t | Input: %0d - %0d | Change: %0d | Done: %b\n",
                $time, money, price, change_out, change_dispense_done);
        end
    endtask


    // Initial block
    initial begin
        // Optional: waveform
        $dumpfile("change_calculator_tb.vcd");
        $dumpvars(0, change_calculator_tb);

        // Reset and init
        clk = 0;
        rst_n = 0;
        current_amount_display = 0;
        product_price = 0;
        change_dispense_en = 0;
        single_change_calculator = 0;

        #20 rst_n = 1;

        // Run tests
        run_test(5'd20, 5'd15, "Test 1: Enough money, should return 5");
        run_test(5'd25, 5'd5,  "Test 2: Large change, should return 20");
        run_test(5'd10, 5'd10, "Test 3: Exact amount, should return 0");
        run_test(5'd8,  5'd10, "Test 4: Not enough money, return 0");

        #20;
        $finish;
    end

endmodule
