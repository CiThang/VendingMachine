module timer #(
    parameter TIME_WAIT_SELECT   = 5'd30,
    parameter TIME_PRODUCT_RETURN = 5'd5,
    parameter TIME_CHANGE_RETURN  = 5'd5
)(
    input wire clk,
    input wire rst_n,
    input wire [1:0] start_timer,
    output reg timeout_flag,
    output reg [4:0] debug_counter  // Để debug hoặc kiểm tra testbench
);

    // Các chế độ
    localparam WAIT_SELECT   = 2'b00;
    localparam PRODUCT_RETURN = 2'b01;
    localparam CHANGE_RETURN  = 2'b10;

    reg [4:0] counter;
    reg running;
    reg [1:0] prev_mode;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 5'd0;
            timeout_flag <= 1'b0;
            running <= 1'b0;
            prev_mode <= 2'b11;
            debug_counter <= 5'd0;
        end else begin
            if (start_timer != prev_mode) begin
                // Chuyển sang chế độ mới
                case (start_timer)
                    WAIT_SELECT:      counter <= TIME_WAIT_SELECT;
                    PRODUCT_RETURN:   counter <= TIME_PRODUCT_RETURN;
                    CHANGE_RETURN:    counter <= TIME_CHANGE_RETURN;
                    default:          counter <= 5'd0;
                endcase
                timeout_flag <= 1'b0;
                running <= 1'b1;
                prev_mode <= start_timer;
            end else if (running) begin
                if (counter > 0) begin
                    counter <= counter - 1;
                    timeout_flag <= 1'b0;
                end else begin
                    timeout_flag <= 1'b1;
                    running <= 1'b0;
                end
            end
            debug_counter <= counter;
        end
    end

endmodule
