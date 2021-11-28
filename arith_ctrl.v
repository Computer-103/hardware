/**
 * МПД
 * местного программного датчика
 * 局部程序发送器
**/

`include "const.vh"
module arith_ctrl (
    input  clk,
    input  resetn,

    output do_clear_a,
    output do_clear_b,
    output do_clear_c,
    output do_not_a,
    output do_not_b,
    output do_sum,
    output do_and,
    output do_set_c_30,
    output do_left_shift_b,
    output do_left_shift_c,
    output do_left_shift_c29,
    output do_right_shift_bc,
    output do_move_c_to_a,
    output do_move_c_to_b,
    output do_move_b_to_c,
    
    input  reg_d_0,
    input  reg_b_0,
    input  reg_c_30,

    input  start,
    output finish,

    output reg_a_sign,
    output reg_b_sign,
    output reg_c_sign,
    
    input  do_arr_c,
    input  arr_reg_c_sign,

    input  do_read_mem,
    input  mem_read_sign,

    input  [2:0] operation
);

// current operation
reg [2:0] cur_op;

always @(posedge clk) begin
    if (~resetn) begin
        cur_op <= `OP_NULL;
    end else if (finish) begin
        cur_op <= `OP_NULL;
    end else if (start) begin
        cur_op <= operation;
    end
end

// TODO: add

// TODO: sub

// TODO: mul

// TODO: div

// and
wire doing_and = cur_op == `OP_AND;
reg [1:0] and_status;

wire and_do_and;
wire and_do_move_c_to_b;
wire and_finish;

always @ (posedge clk) begin
    if (~resetn) begin
        and_status <= 2'h0;
    end if (!doing_and || and_status == 2'h2) begin
        and_status <= 2'h0;
    end else begin
        and_status <= and_status + 1;
    end 
end

assign and_do_and           = doing_and && and_status == 2'h0;
assign and_do_move_c_to_b   = doing_and && and_status == 2'h1;
assign and_finish           = doing_and && and_status == 2'h2;

// TODO: left4

// left3
wire doing_left3 = cur_op == `OP_LEFT3;
reg  [1:0] left3_status;

wire left3_do_left_shift_c;
wire left3_do_left_shift_c29;
wire left3_finish;

always @ (posedge clk) begin
    if (~resetn) begin
        left3_status <= 2'h0;
    end if (!doing_left3 || left3_status == 2'h3) begin
        left3_status <= 2'h0;
    end else begin
        left3_status <= left3_status + 1;
    end 
end

assign left3_do_left_shift_c = doing_left3 && (
    left3_status == 2'h0 ||
    left3_status == 2'h1 ||
    left3_status == 2'h2
);
assign left3_do_left_shift_c29 = left3_do_left_shift_c;

assign left3_finish = left3_status == 2'h3;

// finish
assign finish = 
    and_finish ||
    left3_finish;

assign do_clear_a           = 1'b0;
assign do_clear_b           = 1'b0;
assign do_clear_c           = 1'b0;
assign do_not_a             = 1'b0;
assign do_not_b             = 1'b0;
assign do_sum               = 1'b0;
assign do_and               = and_do_and;
assign do_set_c_30          = 1'b0;
assign do_left_shift_b      = 1'b0;
assign do_left_shift_c      = left3_do_left_shift_c;
assign do_left_shift_c29    = left3_do_left_shift_c29;
assign do_right_shift_bc    = 1'b0;
assign do_move_c_to_a       = 1'b0;
assign do_move_c_to_b       = and_do_move_c_to_b;
assign do_move_b_to_c       = 1'b0;

assign reg_a_sign = 1'b0;
assign reg_b_sign = 1'b0;
assign reg_c_sign = 1'b0;

endmodule