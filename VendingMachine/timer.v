module timer #(
    parameter TIME_WAIT_SELECT    = 30,
    parameter TIME_PRODUCT_RETURN = 5,
    parameter TIME_CHANGE_RETURN  = 5
)(
    input wire clk,
    input wire rst_n,
    input wire [1:0] start_timer,   // Chế độ timer
    output reg timeout_flag
);

    // Các chế độ
    localparam WAIT_SELECT    = 2'b01;
    localparam PRODUCT_RETURN = 2'b10;
    localparam CHANGE_RETURN  = 2'b11;

    reg [4:0] counter;
    reg running;
    reg [1:0] prev_timer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 5'd0;
            timeout_flag <= 1'b0;
            running <= 1'b0;
            prev_timer <= 2'b00;
        end else begin
            if (start_timer != prev_timer && start_timer != 2'b00) begin
                // Chuyển sang chế độ mới
                case (start_timer)
                    WAIT_SELECT:    counter <= TIME_WAIT_SELECT;
                    PRODUCT_RETURN: counter <= TIME_PRODUCT_RETURN;
                    CHANGE_RETURN:  counter <= TIME_CHANGE_RETURN;
                    default:        counter <= 0;
                endcase
                timeout_flag <= 1'b0;
                running <= 1'b1;
                prev_timer <= start_timer;
            end else if (running) begin
                if (counter > 0) begin
                    counter <= counter - 1;
                    timeout_flag <= 1'b0;
                end else begin
                    timeout_flag <= 1'b1;
                    running <= 1'b0;
                end
            end
        end
    end

endmodule
