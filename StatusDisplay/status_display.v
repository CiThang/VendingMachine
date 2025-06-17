module status_display#(
    parameter pIDLE = 3'b000,
    parameter pWAIT_COIN = 3'b001,
    parameter pSELECT_PRODUCT = 3'b010,
    parameter pDISPENSE_CHANGE = 3'b011,
    parameter pRETURN_MONEY = 3'b100
)(
    input wire clk,
    input wire rst_n,
    input wire cancel,
    input wire display_status_en,
    input wire product_dispense_done,
    input wire change_dispense_done,
    input wire [2:0] state_out,
    output reg [7:0] status_display,
    output reg [3:0] led_indicators
);
    

    always @(posedge clk or negedge rst_n) begin
    if (!rst_n || cancel) begin
        status_display   <= 8'b0000_0000;
        led_indicators   <= 4'b0000;
    end else if (display_status_en) begin
        case (state_out)
            pIDLE: begin
                status_display <= 8'h49;      // Hiển thị "I" = 0x49
                led_indicators <= 4'b0001;    // LED trạng thái IDLE
            end
            pWAIT_COIN: begin
                status_display <= 8'h57;      // Hiển thị "W" = 0x57
                led_indicators <= 4'b0010;
            end
            pSELECT_PRODUCT: begin 
                if(product_dispense_done) begin
                status_display <= 8'h53;      // "S" = Select
                led_indicators <= 4'b0011;
                end
            end
            pDISPENSE_CHANGE: begin
                if (change_dispense_done) begin
                    status_display <= 8'h43;  // "C" = Change
                    led_indicators <= 4'b0101;
                end
            end
            pRETURN_MONEY: begin
                if (cancel) begin
                    status_display <= 8'h52;  // "R" = Return
                    led_indicators <= 4'b0110;
                end
            end
            default: begin
                status_display <= 8'h2D;      // "-" unknown
                led_indicators <= 4'b1111;
            end
        endcase
    end
end


endmodule