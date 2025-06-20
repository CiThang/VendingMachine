module fsm_controller #(
    parameter IDLE              = 3'b000,
    parameter WAIT_COIN         = 3'b001,
    parameter SELECT_PRODUCT    = 3'b010,
    parameter DISPENSE_PRODUCT  = 3'b100,
    parameter CHANGE_CALCULATOR = 3'b011
)(
    input wire clk,
    input wire rst_n,
    input wire cancel,
    input wire [1:0] product_sel,
    input wire total_amount_done,
    input wire timeout_flag,
    input wire coin_value_in,
    input wire product_selector_done,
    input wire change_calculator_done,

    output reg [2:0] state_out,
    output reg change_calculator_en,
    output reg product_selector_en,
    output reg [7:0] status_display,
    output reg [3:0] led_indicators,
    output reg [1:0] start_timer
);

    // ----------------------------
    // State Register
    // ----------------------------
    reg [2:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // ----------------------------
    // Next State Logic
    // ----------------------------
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                next_state = WAIT_COIN;
            end

            WAIT_COIN: begin
                if (cancel)
                    next_state = IDLE;
                else if (total_amount_done)
                    next_state = SELECT_PRODUCT;
                else
                    next_state = WAIT_COIN;
            end

            SELECT_PRODUCT: begin
                if (cancel)
                    next_state = IDLE;
                else if (product_selector_done || timeout_flag)
                    next_state = DISPENSE_PRODUCT;
                else
                    next_state = SELECT_PRODUCT;
            end

            DISPENSE_PRODUCT: begin
                next_state = CHANGE_CALCULATOR;
            end

            CHANGE_CALCULATOR: begin
                if (change_calculator_done || timeout_flag)
                    next_state = IDLE;
                else
                    next_state = CHANGE_CALCULATOR;
            end

            default: next_state = IDLE;
        endcase
    end

    // ----------------------------
    // Output Logic
    // ----------------------------
    always @(*) begin
        // Mặc định
        state_out              = state;
        change_calculator_en   = 0;
        product_selector_en    = 0;
        start_timer            = 2'b00;
        led_indicators         = 4'b0000;
        status_display          = 8'h2D;  // "-" mặc định

        case (state)
            IDLE: begin
                led_indicators  = 4'b0000;
                status_display   = 8'h49; // 'I' - Idle
            end

            WAIT_COIN: begin
                led_indicators  = 4'b0001;
                status_display   = 8'h57; // 'W' - Wait coin

                if (coin_value_in) begin
                    start_timer = 2'b01; // Reset 30s timer khi nhét xu
                end

                

            end

            SELECT_PRODUCT: begin
                led_indicators      = 4'b0010;
                status_display       = 8'h53; // 'S' - Select product
                product_selector_en = 1;
                start_timer         = 2'b10; // 30s chọn SP
            end

            DISPENSE_PRODUCT: begin
                led_indicators = 4'b0011;
                status_display  = 8'h44; // 'D' - Dispensing
                // Không kích timer ở đây
            end

            CHANGE_CALCULATOR: begin
                led_indicators        = 4'b0100;
                status_display         = 8'h52; // 'R' - Return change
                change_calculator_en  = 1;
                start_timer           = 2'b11; // 5s chờ nhận tiền thừa
            end
        endcase
    end

endmodule
