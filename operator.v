/**
 * БО
 * блока операций
 * 操作器 or 操作部件
**/

module operator (
    input  clk,
    input  resetn,

    input  reg_a_sign,
    input  reg_b_sign,

    output [ 5:0] pulse_unit_ctrl,

    input  do_c_to_operator,
    input  [ 5:0] c_to_operator_value,

    output [ 5:0] op_code_value
);

reg  [ 5:0] op_code;

wire [ 2:0] op_code_p1;
wire [ 2:0] op_code_p2;

wire ctrl_abs;

wire ctrl_select_to_start_at_4;
wire ctrl_select_to_start_at_7;
wire ctrl_move_b_to_c_at_7;         // opp: ctrl_move_c_to_b_at_7
wire ctrl_mem_read_at_3;
wire ctrl_mem_rw_at_5;
wire ctrl_mem_write_at_5;

always @ (posedge clk) begin
    if (~resetn) begin
        op_code <= 6'h0;
    end else if (do_c_to_operator) begin
        op_code <= c_to_operator_value;
    end
end

assign op_code_value = op_code;
assign op_code_p1 = op_code[5:3];
assign op_code_p2 = op_code[2:0];

// control line for operator & arith
assign ctrl_abs         = op_code_p1[2] && op_code_p1[0];
assign ctrl_write_res   = ~op_code_p1[0];
assign ctrl_print_out   = ~op_code_p1[0] && op_code_p1[2];
assign ctrl_stop        = 1'b0;

// control line for pulse_unit unit
assign ctrl_select_to_start_at_4    = op_code_p2 == 3'o4 && op_code_p1[1];
assign ctrl_select_to_start_at_7    = op_code_p2 == 3'o4 && op_code_p1[1] && op_code_p1[0] && ~reg_b_sign;
assign ctrl_move_b_to_c_at_7        = op_code_p1[1];
assign ctrl_mem_read_at_3           = op_code_p2 == 3'o4;
assign ctrl_mem_rw_at_5             = ~op_code_p1[1];
assign ctrl_mem_write_at_5          = op_code_p2 == 3'o5;

assign pulse_unit_ctrl = {
    ctrl_select_to_start_at_4,
    ctrl_select_to_start_at_7,
    ctrl_move_b_to_c_at_7,
    ctrl_mem_read_at_3,
    ctrl_mem_rw_at_5,
    ctrl_mem_write_at_5
};

endmodule