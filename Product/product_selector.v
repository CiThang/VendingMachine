module product_selector #(
    parameter PRODUCT_A_PRICE = 5'd15, 
    parameter PRODUCT_B_PRICE = 5'd20, 
    parameter PRODUCT_C_PRICE = 5'd25
)(
    input wire clk,
    input wire rst_n,
    input wire [1:0] product_sel,
    input wire product_dispense_en,
    input wire signal_product_selector,
    output reg [4:0] product_price,
    output reg [1:0] product_out,
    output reg product_dispense_done,
    output reg product_selector_done
);

    parameter PRODUCT_A = 2'b01;
    parameter PRODUCT_B = 2'b10;
    parameter PRODUCT_C = 2'b11;

    reg [4:0] temp_product_price;
    reg [1:0] temp_product_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_price <= 5'd0;
            product_out <= 2'b00;
            product_dispense_done <= 1'b0;
            product_selector_done <= 1'b0;
        end else begin
            if (signal_product_selector) begin
                case (product_sel)
                    PRODUCT_A: begin
                        temp_product_price <= PRODUCT_A_PRICE;
                        temp_product_out <= PRODUCT_A;
                        product_selector_done <= 1'b1;
                    end
                    PRODUCT_B: begin
                        temp_product_price <= PRODUCT_B_PRICE;
                        temp_product_out <= PRODUCT_B;
                        product_selector_done <= 1'b1;
                    end
                    PRODUCT_C: begin
                        temp_product_price <= PRODUCT_C_PRICE;
                        temp_product_out <= PRODUCT_C;
                        product_selector_done <= 1'b1;
                    end
                    default: begin
                        temp_product_price <= 5'd0;
                        temp_product_out <= 2'b00;
                        product_selector_done <= 1'b0;
                    end
                endcase
            end else begin
                temp_product_price <= 5'd0;
                temp_product_out <= 2'b00;
            end

            if (product_dispense_en) begin
                product_price <= temp_product_price;
                product_out <= temp_product_out;
                product_dispense_done <= 1'b1;
            end 
            else begin
                product_price <= 5'd0;
                product_out <= 2'b00;
            end 
        end
    end

endmodule
