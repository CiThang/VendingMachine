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
    output reg product_dispense_done
);

    localparam PRODUCT_A = 2'b00;
    localparam PRODUCT_B = 2'b01;
    localparam PRODUCT_C = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_price <= 5'd0;
            product_out <= 2'b00;
            product_dispense_done <= 1'b0;
        end else begin
            if (signal_product_selector) begin
                case (product_sel)
                    PRODUCT_A: begin
                        product_price <= PRODUCT_A_PRICE;
                        product_out <= PRODUCT_A;
                    end
                    PRODUCT_B: begin
                        product_price <= PRODUCT_B_PRICE;
                        product_out <= PRODUCT_B;
                    end
                    PRODUCT_C: begin
                        product_price <= PRODUCT_C_PRICE;
                        product_out <= PRODUCT_C;
                    end
                    default: begin
                        product_price <= 5'd0;
                        product_out <= 2'b00;
                    end
                endcase
            end else begin
                product_price <= 5'd0;
                product_out <= 2'b00;
            end

            if (product_dispense_en)
                product_dispense_done <= 1'b1;
            else
                product_dispense_done <= 1'b0;
        end
    end

endmodule
