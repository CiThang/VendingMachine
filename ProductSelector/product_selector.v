module product_selector #(
    parameter PRODUCT_A = 2'b01,
    parameter PRODUCT_B = 2'b10,
    parameter PRODUCT_C = 2'b11,
    parameter PRICE_A = 5'd15,
    parameter PRICE_B = 5'd20,
    parameter PRICE_C = 5'd25
)(
    input wire clk,
    input wire rst_n,
    input wire [1:0] product_sel,
    input wire product_selector_en,
    input wire timeout_flag,
    output reg [4:0] product_price,
    output reg [1:0] product_out,
    output reg product_selector_done
);
    reg [4:0] temp_product_price;
    

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_price <= 5'd00;
            product_out <= 2'b00;
            product_selector_done <= 1'b0;
        end else begin
            if (product_selector_en) begin
                case (product_sel)
                    PRODUCT_A: temp_product_price <= PRICE_A;
                    PRODUCT_B: temp_product_price <= PRICE_B;
                    PRODUCT_C: temp_product_price <= PRICE_C;
                    default:   temp_product_price <= 5'd00;
                endcase
                product_selector_done <= 1'b1; // bawts dau dem 5s
            end else if(timeout_flag) begin
                product_out <= product_sel;
                product_price <= temp_product_price;
                product_selector_done <= 1'b0;
            end
        end
    end

endmodule
