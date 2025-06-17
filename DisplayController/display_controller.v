module display_controller(
    input wire [4:0] current_amount,
    output wire [6:0] seg_a, 
    output wire [6:0] seg_b,
    output wire [4:0] current_amount_display
);

    wire [3:0] digit_a = current_amount / 10;
    wire [3:0] digit_b = current_amount % 10;

    display dis_a (
        .value(digit_a),
        .seg(seg_a)
    );

    display dis_b (
        .value(digit_b),
        .seg(seg_b)
    );

    assign current_amount_display = current_amount;

endmodule


module display (
    input  [3:0] value,
    output reg [6:0] seg
);

    always @(*) begin
        case (value)
            4'd0: seg = 7'b1111110;
            4'd1: seg = 7'b0110000;
            4'd2: seg = 7'b1101101;
            4'd3: seg = 7'b1111001;
            4'd4: seg = 7'b0110011;
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1111011;
            default: seg = 7'b0000000;
        endcase
    end

endmodule