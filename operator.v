/**
 * БО
 * блока операций
 * 操作器 or 操作部件
**/

module operator (
    input  clk,
    input  resetn,

    input  do_code_to_op_from_pu,       // pulse, from pu
    input  operate_pulse_from_pu,       // pulse, from pu
    input  do_move_b_to_c_from_pu,      // pulse, from pu
    input  do_move_c_to_a_from_pu,      // pulse, from pu
    input  mem_write_reply_from_mem,    // pulse, from pu

    input  ac_answer_from_ac,           // pulse, from ac

    input  reg_a_sign_from_ac,          // level, from ac
    input  reg_b_sign_from_ac,          // level, from ac

    input  [ 5:0] op_code_from_au,      // level, from au

    output order_add_to_ac,             // pulse, to ac
    output order_sub_to_ac,             // pulse, to ac
    output order_mul_to_ac,             // pulse, to ac
    output order_div_to_ac,             // pulse, to ac
    output order_and_to_ac,             // pulse, to ac
    output order_input_to_io,           // pulse, to io

    output order_write_to_io,           // pulse, to io
    output order_output_to_io,          // pulse, to io
    output start_pulse_to_io,           // pulse, to io

    output ctrl_abs_to_ac,              // level, to ac
    output [ 5:0] ctrl_bus_to_pu,       // level bus, to pu

    output [ 5:0] op_code_value_to_pnl  // level bus, to pnl
);

// operate code register
reg  [ 5:0] op_code;

wire [ 2:0] op_code_p1;
wire [ 2:0] op_code_p2;

// decode for pu
wire ctrl_select_to_start_at_4;
wire ctrl_select_to_start_at_7;
wire ctrl_move_b_to_c_at_7;         // opp: ctrl_move_c_to_b_at_7
wire ctrl_mem_read_at_3;
wire ctrl_mem_read_at_5;
wire wait_start_at_6;

// operate code register
always @ (posedge clk) begin
    if (~resetn) begin
        op_code <= 6'h0;
    end else if (do_code_to_op_from_pu) begin
        op_code <= op_code_from_au;
    end
end

assign op_code_value_to_pnl = op_code;

assign op_code_p1 = op_code[5:3];
assign op_code_p2 = op_code[2:0];

// decode for ac
assign order_add_to_ac = 
    operate_pulse_from_pu && (
        (op_code_p2 == 3'o0 && reg_a_sign_from_ac == reg_b_sign_from_ac) || // (+ [+] +) || (- [+] -)
        (op_code_p2 == 3'o1 && reg_a_sign_from_ac != reg_b_sign_from_ac)    // (+ [-] -) || (- [-] +)
    );
assign order_sub_to_ac =
    operate_pulse_from_pu && (
        (op_code_p2 == 3'o1 && reg_a_sign_from_ac == reg_b_sign_from_ac) || // (+ [-] +) || (- [-] -)
        (op_code_p2 == 3'o0 && reg_a_sign_from_ac != reg_b_sign_from_ac)    // (+ [+] -) || (- [+] +)
    );
assign order_div_to_ac =
    operate_pulse_from_pu && op_code_p2 == 3'o2;
assign order_mul_to_ac =
    operate_pulse_from_pu && op_code_p2 == 3'o3;
assign order_and_to_ac =
    operate_pulse_from_pu && op_code_p2 == 3'o6;

assign ctrl_abs_to_ac =
    op_code_p1[2] && op_code_p1[0];

// decode for io
assign order_input_to_io =
    operate_pulse_from_pu && op_code_p2 == 3'o7 && ~op_code_p1[0];

// decode for pu
assign ctrl_select_to_start_at_4    = op_code_p2 == 3'o4 && op_code_p1[1];
assign ctrl_select_to_start_at_7    = op_code_p2 == 3'o4 && op_code_p1[1] && op_code_p1[0] && ~reg_b_sign_from_ac;
assign ctrl_move_b_to_c_at_7        = op_code_p1[1];
assign ctrl_mem_read_at_3           = op_code_p2 != 3'o4;
assign ctrl_mem_read_at_5           = ~op_code_p1[1] && op_code_p2 != 3'o5;
assign wait_start_at_6              = ~op_code_p1[1];

assign ctrl_bus_to_pu = {
    ctrl_select_to_start_at_4,
    ctrl_select_to_start_at_7,
    ctrl_move_b_to_c_at_7,
    ctrl_mem_read_at_3,
    ctrl_mem_read_at_5,
    wait_start_at_6
};

// for finish (delay one cycle in io)
assign order_write_to_io =
    (do_move_b_to_c_from_pu && op_code_p1[0] == 1'b0 && op_code_p2 == 3'o4) ||  // 04,24,44,64
    (do_move_c_to_a_from_pu && op_code_p2 == 3'o5) ||   // X5
    (ac_answer_from_ac && op_code_p1[0] == 1'b0);
assign order_output_to_io =
    (mem_write_reply_from_mem && op_code_p1[2] == 1'b1);
assign start_pulse_to_io =
    (operate_pulse_from_pu && (op_code_p2 == 3'o5 || op_code == 6'o34 || op_code == 6'o74)) ||
    (ac_answer_from_ac && op_code_p1[0] == 1'b1);

endmodule
