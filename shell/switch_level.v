module switch_level (
    input  clk,
    input  resetn,

    input  sw,          // switch
    output level        // level
);

reg  sw_r;

always @(posedge clk) begin
    if (~resetn) begin
        sw_r <= 1'b0;
    end else begin
        sw_r <= sw;
    end
end

assign level = sw_r;

endmodule
