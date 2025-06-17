module total_amount(
    input wire clk,
    input wire rst_n,
    input wire cancel, // 1đ, 5đ, 10đ
    input wire [4:0] coin_value, 
    output reg [4:0] current_amount
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || cancel) begin
            current_amount <= 5'd0;
        end else begin
            current_amount <= current_amount + coin_value; // Update current amount with new coin value
        end
    end
   
endmodule