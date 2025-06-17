`timescale 1ns/1ps
`include "total_amount.v"

module total_amount_tb;

    reg clk;
    reg rst_n;
    reg cancel;
    reg [4:0] coin_value;
    wire [4:0] current_amount;


    // Instantiate the total_amount module
    total_amount uut (
        .clk(clk),
        .rst_n(rst_n),
        .cancel(cancel),
        .coin_value(coin_value),
        .current_amount(current_amount)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    initial begin
        $dumpfile("total_amount_tb.vcd");
        $dumpvars(0, total_amount_tb);
    end

    // Display monitor
    initial begin
        $display("Time\tclk\trst_n\tcancel\tcoin_value\tcurrent_amount");
        $monitor("%4dns\t%b\t%b\t%b\t%2d\t\t%2d",
                 $time, clk, rst_n, cancel, coin_value, current_amount);
    end

    // Test sequence
    initial begin
        rst_n = 0; // Reset the system
        cancel = 0;
        coin_value = 5'd0;

        #10 rst_n = 1; // Release reset

        // Test adding coins
        coin_value = 5'd1; // Add 1đ
        #10;

        coin_value = 5'd5; // Add 5đ
        #10;

        coin_value = 5'd10; // Add 10đ
        #10;

        // Test cancel operation
        cancel = 1; // Trigger cancel
        #10;
        
        cancel = 0; // Release cancel

        // Add more coins after cancel
        coin_value = 5'd2; // Add 2đ
        #10;

        coin_value = 5'd3; // Add 3đ
        #10;

        $finish; // End simulation
    end
endmodule
