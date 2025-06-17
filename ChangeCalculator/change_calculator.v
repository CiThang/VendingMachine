module change_calculator(
    input wire clk,
    input wire rst_n,
    input wire [4:0] current_amount_display,
    input wire [4:0] product_price,
    input wire change_dispense_en,
    input wire single_change_calculator,
    output reg [4:0] change_out,
    output reg change_dispense_done
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            change_out <= 5'd0;
            change_dispense_done <= 1'b0;
        end else begin
            if (single_change_calculator && change_dispense_en) begin
                if (current_amount_display >= product_price) begin
                    change_out <= current_amount_display - product_price;
                    change_dispense_done <= 1'b1;
                end else begin
                    change_out <= 5'd0;
                    change_dispense_done <= 1'b0;
                end
            end else begin
                change_dispense_done <= 1'b0;
            end
        end
    end

endmodule
