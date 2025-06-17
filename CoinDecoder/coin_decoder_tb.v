`timescale 1ps/1ps
`include "coin_decoder.v"

module coin_decoder_tb;

    reg clk;
    reg rst_n;
    reg [1:0] coin_in;
    wire [3:0] coin_value;

    // Instantiate the coin_decoder module
    coin_decoder uut (
        .clk(clk),
        .rst_n(rst_n),
        .coin_in(coin_in),
        .coin_value(coin_value)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    initial begin
        $dumpfile("coin_decoder_tb.vcd");
        $dumpvars(0, coin_decoder_tb);
    end

    // Test sequence
    initial begin
        rst_n = 0; // Reset the system
        #10;
        rst_n = 1; // Release reset

        // Test cases
        coin_in = 2'b00; // Input 1đ
        #10;
        $display("Coin in: %b, Coin value: %d", coin_in, coin_value);

        coin_in = 2'b01; // Input 5đ
        #10;
        $display("Coin in: %b, Coin value: %d", coin_in, coin_value);

        coin_in = 2'b10; // Input 10đ
        #10;
        $display("Coin in: %b, Coin value: %d", coin_in, coin_value);

        coin_in = 2'b11; 
        #10;
        $display("Coin in: %b, Coin value: %d", coin_in, coin_value);

        $finish; // End simulation
    end
endmodule