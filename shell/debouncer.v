module debouncer # (
    parameter cnt_depth = 1048576
) (
    input  clk,
    input  resetn,

    input  original_sig,    // original signal
    output debounced_sig    // debounced signal
);

localparam cnt_width = $clog2(cnt_depth);

reg  [cnt_width:0] counter;

reg  reg_sig;
always @(posedge clk) begin
    if (~resetn) begin
        reg_sig <= 1'b0;
    end else if (counter == cnt_depth - 1) begin
        reg_sig <= original_sig;
    end
end
assign debounced_sig = reg_sig;

// way 1
always @(posedge clk) begin
    if (~resetn) begin
        counter <= 0;
    end else if (reg_sig != original_sig) begin
        if (counter != cnt_depth - 1) begin
            counter <= counter + 1;
        end
    end else begin
        counter <= 0;
    end
end

// way 2
// always @(posedge clk) begin
//     if (~resetn) begin
//         counter <= 0;
//     end else if (counter == 0) begin
//         if (reg_sig != original_sig) begin
//             counter <= 1;
//         end
//     end else begin
//         if (counter == cnt_depth - 1) begin
//             counter <= 0;
//         end else begin
//             counter <= counter + 1;
//         end
//     end
// end

endmodule
