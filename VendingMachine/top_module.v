`include "coin_decoder.v"
`include "display_controller.v"
`include "fsm_controller.v"
`include "product_selector.v"
`include "timer.v"
`include "total_amount.v"
`include "change_calculator.v"

module top_module #(
    parameter IDLE              = 3'b000,
    parameter WAIT_COIN         = 3'b001,
    parameter SELECT_PRODUCT    = 3'b010,
    parameter DISPENSE_PRODUCT  = 3'b011,
    parameter CHANGE_CALCULATOR = 3'b100,

    parameter PRODUCT_A = 2'b01,
    parameter PRODUCT_B = 2'b10,
    parameter PRODUCT_C = 2'b11,
    parameter PRICE_A = 5'd15,
    parameter PRICE_B = 5'd20,
    parameter PRICE_C = 5'd25,

    parameter TIME_WAIT_SELECT   = 5'd30,
    parameter TIME_PRODUCT_RETURN = 5'd5,
    parameter TIME_CHANGE_RETURN  = 5'd5
)(
    input wire clk,
    input wire rst_n,
    input wire [1:0] coin_in,
    input wire [1:0] product_sel,
    input wire cancel,

    output wire [2:0] state_out,
    output wire [6:0] amount_display_seg_a,
    output wire [6:0] amount_display_seg_b,
    output wire [1:0] product_out,
    output wire [4:0] change_out,
    output wire [7:0] status_display,
    output wire [3:0] led_indicators,
    output wire [4:0] current_amount_display
);

    // Các kết nối nội bộ
    wire [4:0] coin_value;
    wire [4:0] current_amount;
    wire total_amount_done;
    wire coin_value_in;
    wire timeout_flag;
    wire product_selector_done;
    wire change_calculator_done;
    wire change_calculator_en;
    wire product_selector_en;  
    wire [1:0] start_timer;
    wire [4:0] product_price;
    wire coin_valid;
   

    // Decoder xu
    coin_decoder dut1 (
        .clk(clk),
        .rst_n(rst_n),
        .coin_in(coin_in),
        .coin_value(coin_value),
        .coin_valid(coin_valid)
    );

    // Tính tổng tiền
    total_amount dut2(
        .clk(clk),
        .rst_n(rst_n),
        .cancel(cancel),
        .coin_value(coin_value),
        .coin_valid(coin_valid),
        .product_sel(product_sel),
        .timeout_flag(timeout_flag),
        .current_amount(current_amount),
        .total_amount_done(total_amount_done),
        .coin_value_in(coin_value_in)
    );

    // Hiển thị tiền
    display_controller dut3(
        .current_amount(current_amount),
        .seg_a(amount_display_seg_a),
        .seg_b(amount_display_seg_b),
        .current_amount_display(current_amount_display)
    );

    // Timer
    timer #(
        .TIME_WAIT_SELECT(TIME_WAIT_SELECT),
        .TIME_PRODUCT_RETURN(TIME_PRODUCT_RETURN),
        .TIME_CHANGE_RETURN(TIME_CHANGE_RETURN)
    ) dut4 (
        .clk(clk),
        .rst_n(rst_n),
        .start_timer(start_timer),
        .timeout_flag(timeout_flag)
        
    );

    // FSM Controller
    fsm_controller  #(
        .IDLE(IDLE),
        .WAIT_COIN(WAIT_COIN),
        .SELECT_PRODUCT(SELECT_PRODUCT),
        .DISPENSE_PRODUCT(DISPENSE_PRODUCT),
        .CHANGE_CALCULATOR(CHANGE_CALCULATOR)
    ) dut5 (  
        .clk(clk),
        .rst_n(rst_n),
        .cancel(cancel),
        .product_sel(product_sel),
        .total_amount_done(total_amount_done),
        .timeout_flag(timeout_flag),
        .coin_value_in(coin_value_in),
        .product_selector_done(product_selector_done),
        .change_calculator_done(change_calculator_done),
        .state_out(state_out),
        .change_calculator_en(change_calculator_en),
        .product_selector_en(product_selector_en),
        .status_display(status_display),
        .led_indicators(led_indicators),
        .start_timer(start_timer)
    );

    // Chọn sản phẩm
    product_selector #(
        .PRODUCT_A(PRODUCT_A),
        .PRODUCT_B(PRODUCT_B),
        .PRODUCT_C(PRODUCT_C),
        .PRICE_A(PRICE_A),
        .PRICE_B(PRICE_B),
        .PRICE_C(PRICE_C)
    ) dut7 (
        .clk(clk),
        .rst_n(rst_n),
        .product_sel(product_sel),
        .product_selector_en(product_selector_en),
        .timeout_flag(timeout_flag),
        .product_price(product_price),
        .product_out(product_out),
        .product_selector_done(product_selector_done)
    );

    // Tính tiền thừa
    change_calculator dut8(
        .clk(clk),
        .rst_n(rst_n),
        .current_amount_display(current_amount_display),
        .product_price(product_price),
        .timeout_flag(timeout_flag),
        .change_calculator_en(change_calculator_en),
        .change_out(change_out),
        .change_calculator_done(change_calculator_done)
    );

endmodule
