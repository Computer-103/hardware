module operator (
    input  clk,
    input  resetn,

    output read_addr2,
    output write_addr2,
    output arth_and,

    input  op_code_valid,
    input  [5:0] op_code_data
);

reg [5:0] op_code;

always @ (posedge clk) begin
    if (~resetn) begin
        op_code <= 6'h0;
    end else if (op_code_valid) begin
        op_code <= op_code_data;
    end
end

assign read_addr2   = op_code[4] == 1'b0;
assign write_addr2  = op_code[3] == 1'b0;
assign arth_and     = op_code[2:0] == 3'o6;

// TODO:

endmodule