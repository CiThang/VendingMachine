module change_calculator(
    input wire clk,
    input wire rst_n,
    input wire [4:0] current_amount_display,
    input wire [4:0] product_price,
    input wire timeout_flag,
    input wire change_calculator_en,
    output reg [4:0] change_out,
    output reg change_calculator_done
);

    reg [4:0] temp_change_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            change_out <= 5'd0;
            change_calculator_done <= 1'b0;
        end else begin
            if (change_calculator_en) begin   
                if(current_amount_display>product_price) begin
                    temp_change_out <= current_amount_display - product_price; 
                    change_calculator_done <= 1'b1;   // bawys dau dem  
                end
            end else if (timeout_flag) begin
                change_out <= temp_change_out;
                change_calculator_done <= 1'b0;   //dem xong
            end
        end
    end

endmodule
