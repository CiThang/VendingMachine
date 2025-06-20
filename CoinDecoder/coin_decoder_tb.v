`timescale 1ns/1ps
`include "coin_decoder.v"
module coin_decoder_tb;

    // Khai báo tín hiệu testbench
    reg clk;
    reg rst_n;
    reg [1:0] coin_in;
    wire [4:0] coin_value;
    wire coin_valid;

    // Gọi module coin_decoder
    coin_decoder uut (
        .clk(clk),
        .rst_n(rst_n),
        .coin_in(coin_in),
        .coin_value(coin_value),
        .coin_valid(coin_valid)
    );

    // Clock 10ns
    always #5 clk = ~clk;

    initial begin
        $dumpfile("coin_decoder_tb.vcd");
        $dumpvars(0,coin_decoder_tb);
    end

    initial begin
        // Khởi tạo
        clk = 0;
        rst_n = 0;
        coin_in = 2'b11;  // Không có xu
        #12;

        rst_n = 1;  // Bỏ reset
        #10;

        // ----- Test xu 1đ (2'b00) -----
        $display(">>> Test xu 1đ");
        coin_in = 2'b00;   // Đưa xu vào
        #10;
        coin_in = 2'b11;   // Rút xu ra (trở về trạng thái nghỉ)
        #10;

        // ----- Test xu 5đ (2'b01) -----
        $display(">>> Test xu 5đ");
        coin_in = 2'b01;
        #10;
        coin_in = 2'b11;
        #10;

        // ----- Test xu 10đ (2'b10) -----
        $display(">>> Test xu 10đ");
        coin_in = 2'b10;
        #10;
        coin_in = 2'b11;
        #10;

        // ----- Test không có xu -----
        $display(">>> Test không có xu");
        coin_in = 2'b11;
        #20;

        $finish;
    end

    // Theo dõi tín hiệu
    initial begin
        $monitor("Time: %t | coin_in = %b | coin_value = %d | coin_valid = %b", 
                  $time, coin_in, coin_value, coin_valid);
    end

endmodule
