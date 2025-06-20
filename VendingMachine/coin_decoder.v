module coin_decoder(
    input wire clk,
    input wire rst_n,
    input wire [1:0] coin_in,
    output reg [4:0] coin_value,
    output reg coin_valid
);

    reg [1:0] prev_coin_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            coin_value   <= 5'd0;
            coin_valid   <= 1'b0;
            prev_coin_in <= 2'b00; // trạng thái "không có xu"
        end else begin
            // Phát hiện cạnh lên từ 11 -> 00/01/10
            if (coin_in != 2'b00 && prev_coin_in == 2'b00) begin
                case (coin_in)
                    2'b01: coin_value <= 5'd1;
                    2'b10: coin_value <= 5'd5;
                    2'b11: coin_value <= 5'd10;
                    default: coin_value <= 5'd0;
                endcase
                coin_valid <= 1'b1;
            end else begin
                coin_valid <= 1'b0;
            end
            prev_coin_in <= coin_in;
        end
    end

endmodule
