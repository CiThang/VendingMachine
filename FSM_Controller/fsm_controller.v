module fsm_controller #(
    parameter IDLE              = 3'b000,
    parameter WAIT_COIN         = 3'b001,
    parameter SELECT_PRODUCT    = 3'b010,
    parameter DISPENSE_CHANGE   = 3'b100,
    parameter DISPENSE_PRODUCT  = 3'b011,
    parameter RETURN_MONEY      = 3'b101
)(
    input wire clk,
    input wire rst_n,
    input wire cancel,
    input wire [1:0] product_sell,
    input wire enough_money,
    input wire timeout_flag,
    input wire product_dispense_done,
    input wire change_dispense_done,

    output reg [2:0] state_out,
    output reg signal_display_controller,
    output reg display_status_en,
    output reg display_amount_en,
    output reg signal_change_calculator,
    output reg change_dispense_en,
    output reg product_dispense_en,
    output reg signal_product_selector,
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
                    next_state = RETURN_MONEY;
                else if (enough_money)
                    next_state = SELECT_PRODUCT;
            end

            SELECT_PRODUCT: begin
                if (cancel)
                    next_state = RETURN_MONEY;
                else if (product_dispense_done && timeout_flag)
                    next_state = RETURN_MONEY;
            end


            RETURN_MONEY: begin
                if (change_dispense_done && timeout_flag)
                    next_state = IDLE;
                else 
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // ----------------------------
    // Output Logic
    // ----------------------------
    always @(*) begin
        // Mặc định
        state_out = state;
        signal_display_controller = 0;
        display_status_en         = 1;
        display_amount_en         = 0;
        signal_change_calculator  = 0;
        change_dispense_en        = 0;
        product_dispense_en       = 0;
        signal_product_selector   = 0;
        start_timer               = 2'b11;

        case (state)
            IDLE: begin
                // Chờ khởi động
            end

            WAIT_COIN: begin
                signal_display_controller = 1;
                display_amount_en = 1;
            end

            SELECT_PRODUCT: begin
                signal_product_selector = 1;
                if(product_selector_done) begin
                    start_timer = 2'b00; // 30s
                    if(timeout_flag)
                        product_dispense_en = 1;
                        start_timer = 2'b01; // 5s
                        if(timeout_flag)
                            product_dispense_done =1;
                end
            end

            RETURN_MONEY: begin
                signal_change_calculator = 1;
                if(signal_change_calculator)
                    start_timer = 2'b10;
                    if(timeout_flag)
                    change_dispense_done =1;
            end
        endcase
    end

endmodule
