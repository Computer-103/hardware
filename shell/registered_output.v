module registered_output #(
    parameter width = 1
) (
    input  clk,
    input  resetn,
    input  [width - 1:0] output_sig,
    output [width - 1:0] registered_sig
);

reg  [width - 1:0] ff;

always @ (posedge clk) begin
    if (~resetn) begin
        ff <= 0;
    end else begin
        ff <= output_sig;
    end
end

assign registered_sig = ff;

endmodule
