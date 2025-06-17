module coin_decoder(
    input wire clk,
    input wire rst_n,
    input wire [1:0] coin_in,
    output wire [4:0] coin_value
);
    // 00 - 1đ
    // 01 - 5đ
    // 10 - 10đ
    reg [4:0] temp_coin_value;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp_coin_value <= 4'b00000;
        end else begin
            case (coin_in)
                2'b00: temp_coin_value <= 5'd1;   // 1
                2'b01: temp_coin_value <= 5'd5;   // 5
                2'b10: temp_coin_value <= 5'd10;  // 10
                default: temp_coin_value <= 5'd0; // lỗi
            endcase
        end
    end

    assign coin_value = temp_coin_value;

endmodule
