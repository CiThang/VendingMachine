module total_amount(
    input wire clk,
    input wire rst_n,
    input wire cancel,
    input wire [4:0] coin_value,
    input wire coin_valid,
    input wire [1:0] product_sel,
    input wire timeout_flag,

    output reg [4:0] current_amount,
    output reg total_amount_done,
    output reg coin_value_in
);

    reg [4:0] temp_current_amount;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || cancel) begin
            temp_current_amount <= 5'd0;
            current_amount      <= 5'd0;
            total_amount_done   <= 1'b0;
            coin_value_in       <= 1'b0;
        end else begin
            if (coin_valid) begin
                temp_current_amount <= temp_current_amount + coin_value;
                coin_value_in <= 1'b1;
            end else begin
                coin_value_in <= 1'b0;
            end

            if (product_sel != 2'b00 && timeout_flag) begin
                current_amount <= temp_current_amount;
                total_amount_done <= 1'b1;
            end else if (timeout_flag) begin
                temp_current_amount <= 5'd0;
                current_amount <= 5'd0;
                total_amount_done <= 1'b0;
            end else begin
                total_amount_done <= 1'b0;
            end
        end
    end

endmodule
