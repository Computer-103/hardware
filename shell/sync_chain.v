module sync_chain #(
    parameter width = 1
) (
    input  clk,
    input  resetn,
    input  [width - 1:0] input_sig,
    output [width - 1:0] sync_sig
);

reg  [width - 1:0] ff_1;
reg  [width - 1:0] ff_2;
reg  [width - 1:0] ff_3;

always @ (posedge clk) begin
    if (~resetn) begin
        ff_1 <= 0;
        ff_2 <= 0;
        ff_3 <= 0;
    end else begin
        ff_1 <= input_sig;
        ff_2 <= ff_1;
        ff_3 <= ff_2;
    end
end

assign sync_sig = ff_3;

endmodule
