module button_pulse (
    input  clk,
    input  resetn,

    input  btn,         // button
    output pulse        // pulse
);

reg  btn_r;
reg  pulse_r;

always @(posedge clk) begin
    if (~resetn) begin
        btn_r <= 1'b0;
        pulse_r <= 1'b0;
    end else begin
        btn_r <= btn;
        pulse_r <= !btn && btn_r;
    end
end

assign pulse = pulse_r;

endmodule
