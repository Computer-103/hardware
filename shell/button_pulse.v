module button_pulse (
    input  clk,
    input  resetn,

    input  btn,         // button
    output pulse        // pulse
);

wire btn_now;

debouncer sw_debouncer (
    .clk            (clk),
    .resetn         (resetn),
    .original_sig   (btn),
    .debounced_sig  (btn_now)
);

reg  btn_last;
reg  pulse_r;

always @(posedge clk) begin
    if (~resetn) begin
        btn_last <= 1'b0;
        pulse_r <= 1'b0;
    end else begin
        btn_last <= btn_now;
        pulse_r <= btn_last && !btn_now;
    end
end

assign pulse = pulse_r;

endmodule
