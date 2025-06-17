module amount_counter(
    input wire clk,
    input wire rst_n,
    input wire cancel, // Nút hủy
    input wire [4:0] current_amount, // 1đ, 5đ, 10đ
    input wire [4:0] product_price,
    output reg enough_money
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || cancel) begin
            enough_money <= 1'b0; // Reset cờ đủ tiền
        end else begin
            if (current_amount >= product_price) begin
                enough_money <= 1'b1; // Đủ tiền
            end else begin
                enough_money <= 1'b0; // Không đủ tiền
            end
        end
    end
   
endmodule 