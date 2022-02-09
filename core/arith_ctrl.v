/**
 * МПД
 * местного программного датчика
 * 局部程序发送器
**/

module arith_ctrl (
    input  clk,
    input  resetn,

    input  do_clear_a_from_pu,      // pulse, from pu
    input  do_move_b_to_c_from_pu,  // pulse, from pu
    input  do_move_c_to_b_from_pu,  // pulse, from pu
    input  do_move_c_to_a_from_pu,  // pulse, from pu

    input  order_add_from_op,       // pulse, from op
    input  order_sub_from_op,       // pulse, from op
    input  order_mul_from_op,       // pulse, from op
    input  order_div_from_op,       // pulse, from op
    input  order_and_from_op,       // pulse, from op
    input  order_io_from_io,        // pulse, from io

    input  ctrl_abs_from_op,        // level, from op

    input  shift_3_bit_from_io,     // level, from io
    input  shift_4_bit_from_io,     // level, from io

    input  read_sign_from_mem,      // level, from mem

    input  carry_out_from_au,       // level, from au
    input  reg_c1_from_au,          // level, from au
    input  reg_c30_from_au,         // level, from au
    input  reg_b0_from_au,          // level, from au
    input  arr_reg_c_sign_from_pnl, // level, from pnl

    // input  do_mem_to_c_from_pu,     // level, from pu
    input  mem_read_reply_from_mem, // pulse, from mem
    input  do_arr_c_from_pnl,       // level, from pnl

    output ac_answer_to_op,         // pulse, to op
    output ac_answer_to_io,         // pulse, to io

    output do_clear_a_to_au,        // pulse, to au
    output do_clear_b_to_au,        // pulse, to au
    output do_clear_c_to_au,        // pulse, to au
    output do_not_a_to_au,          // pulse, to au
    output do_not_b_to_au,          // pulse, to au
    output do_sum_to_au,            // pulse, to au
    output do_and_to_au,            // pulse, to au
    output do_set_c_30_to_au,       // pulse, to au
    output do_left_shift_b_to_au,   // pulse, to au
    output do_left_shift_c_to_au,   // pulse, to au
    output do_left_shift_c_to_io,   // pulse, to io
    output do_left_shift_c29_to_au, // pulse, to au
    output do_right_shift_bc_to_au, // pulse, to au
    output do_move_c_to_a_to_au,    // pulse, to au
    output do_move_c_to_b_to_au,    // pulse, to au
    output do_move_b_to_c_to_au,    // pulse, to au
    output do_mem_to_c_to_au,       // pulse, to au

    output reg_a_sign_to_op,        // level, to op
    output reg_b_sign_to_op,        // level, to op
    // output reg_b_sign_to_pu,        // level, to pu
    output reg_c_sign_to_pnl,       // level, to pnl
    output write_sign_to_mem,       // level, to mem
    output output_sign_to_io        // level, to io
);

// counter_r for mul, div, io
reg [ 4:0] counter_r;

wire counter_clear;
wire counter_clear_mul;
wire counter_clear_div;
wire counter_clear_io;

wire counter_count;
wire counter_count_mul;
wire counter_count_div;
wire counter_count_io;

wire counter_finish_mul_div;
wire counter_finish_io;

// add
reg  [ 2:0] add_state;
reg  [ 2:0] add_state_next;
wire add_do_sum;
wire add_do_move_b_to_c;
wire add_ac_answer;

// sub
reg  [ 4:0] sub_state;
reg  [ 4:0] sub_state_next;
wire sub_do_not_a;
wire sub_do_not_b;
wire sub_do_sign;
wire sub_do_sum;
wire sub_do_move_b_to_c;
wire sub_ac_answer;

// mul
reg  [ 4:0] mul_state;
reg  [ 4:0] mul_state_next;
wire mul_do_clear_b;
wire mul_do_sign;
wire mul_do_sum;
wire mul_do_right_shift_bc;
wire mul_do_move_b_to_c;
wire mul_ac_answer;

// div
reg  [ 5:0] div_state;
reg  [ 5:0] div_state_next;
wire div_do_not_a;
wire div_do_sign;
wire div_do_left_shift_b;
wire div_do_left_shift_c;
wire div_do_left_shift_c29;
wire div_do_sum;
wire div_do_set_c_30;
wire div_do_move_c_to_b;
wire div_ac_answer;

// and
reg  [ 2:0] and_state;
reg  [ 2:0] and_state_next;
wire and_do_and;
wire and_do_move_c_to_b;
wire and_ac_answer;

// io
reg  [ 2:0] io_state;
reg  [ 2:0] io_state_next;
wire io_do_left_shift_c;
wire io_do_left_shift_c29;
wire io_ac_answer;

// sign
wire sign_mul_div;
wire sign_sub;
wire do_move_sign;

reg  reg_a_sign;
reg  reg_b_sign;
reg  reg_c_sign;

// counter_r for mul, div, io
always @(posedge clk) begin
    if (~resetn) begin
        counter_r <= 5'b0;
    end else if (do_clear_a_from_pu) begin
        counter_r <= 5'b0;
    end else if (counter_clear) begin
        counter_r <= 5'b0;
    end else if (counter_count) begin
        counter_r <= counter_r + 5'b1;
    end
end

assign counter_clear =
    counter_clear_mul || counter_clear_div || counter_clear_io;

assign counter_count = 
    counter_count_mul || counter_count_div || counter_count_io;

assign counter_finish_mul_div = 
    counter_r == 5'd29;
assign counter_finish_io = 
    (shift_3_bit_from_io && counter_r == 5'd2) ||
    (shift_4_bit_from_io && counter_r == 5'd3);

// add
always @(posedge clk) begin
    if (~resetn) begin
        add_state <= 0;
        // add_state[0] <= 1'b1;
    end else if (do_clear_a_from_pu) begin
        add_state <= 0;
        // add_state[0] <= 1'b1;
    end else begin
        add_state <= add_state_next;
    end
end

always @(*) begin
    add_state_next = 0;
    case (1'b1)
        add_state[0]: begin
            if (order_add_from_op) begin
                add_state_next[1] = 1'b1;
            end else begin
                add_state_next[0] = 1'b1;
            end
        end
        add_state[1]: begin
            if (carry_out_from_au) begin
                add_state_next[0] = 1'b1;
            end else begin
                add_state_next[2] = 1'b1;
            end
        end
        add_state[2]: begin
            add_state_next[0] = 1'b1;
        end
        default: begin
            add_state_next[0] = 1'b1;
        end
    endcase
end

assign add_do_sum =
    add_state[1] && !carry_out_from_au;
assign add_do_move_b_to_c =
    add_state[2];
assign add_ac_answer = 
    add_state[2];

// sub
always @(posedge clk) begin
    if (~resetn) begin
        sub_state <= 0;
        // sub_state[0] <= 1'b1;
    end else if (do_clear_a_from_pu) begin
        sub_state <= 0;
        // sub_state[0] <= 1'b1;
    end else begin
        sub_state <= sub_state_next;
    end
end

always @(*) begin
    sub_state_next = 0;
    case (1'b1)
        sub_state[0]: begin
            if (order_sub_from_op) begin
                sub_state_next[1] = 1'b1;
            end else begin
                sub_state_next[0] = 1'b1;
            end
        end
        sub_state[1]: begin
            sub_state_next[2] = 1'b1;
        end
        sub_state[2]: begin
            if (carry_out_from_au) begin
                sub_state_next[4] = 1'b1;
            end else begin
                sub_state_next[3] = 1'b1;
            end
        end
        sub_state[3]: begin
            sub_state_next[4] = 1'b1;
        end
        sub_state[4]: begin
            sub_state_next[0] = 1'b1;
        end
        default: begin
            sub_state_next[0] = 1'b1;
        end
    endcase
end

assign sub_do_not_a =
    sub_state[1] ||
    (sub_state[2] && !carry_out_from_au);
assign sub_do_not_b =
    (sub_state[2] && !carry_out_from_au);
assign sub_do_sign =
    sub_state[2];
assign sub_do_sum = 
    (sub_state[2] && carry_out_from_au) || 
    (sub_state[3]);
assign sub_do_move_b_to_c =
    (sub_state[4]);
assign sub_ac_answer =
    (sub_state[4]);

// mul
always @(posedge clk) begin
    if (~resetn) begin
        mul_state <= 0;
        // mul_state[0] <= 1'b1;
    end else if (do_clear_a_from_pu) begin
        mul_state <= 0;
        // mul_state[0] <= 1'b1;
    end else begin
        mul_state <= mul_state_next;
    end
end

always @(*) begin
    mul_state_next = 0;
    case (1'b1)
        mul_state[0]: begin
            if (order_mul_from_op) begin
                mul_state_next[1] = 1'b1;
            end else begin
                mul_state_next[0] = 1'b1;
            end
        end
        mul_state[1]: begin
            mul_state_next[2] = 1'b1;
        end
        mul_state[2]: begin
            mul_state_next[3] = 1'b1;
        end
        mul_state[3]: begin
            if (counter_finish_mul_div) begin
                mul_state_next[4] = 1'b1;
            end else begin
                mul_state_next[2] = 1'b1;
            end
        end
        mul_state[4]: begin
            mul_state_next[0] = 1'b1;
        end
        default: begin
            mul_state_next[0] = 1'b1;
        end
    endcase
end

assign mul_do_clear_b = 
    mul_state[1];
assign mul_do_sign =
    mul_state[1];
assign mul_do_sum =
    reg_c30_from_au && mul_state[2];
assign mul_do_right_shift_bc = 
    mul_state[3];
assign mul_do_move_b_to_c =
    mul_state[4];
assign mul_ac_answer =
    mul_state[4];
assign counter_clear_mul =
    mul_state[4];
assign counter_count_mul = 
    mul_state[3];

// div
always @(posedge clk) begin
    if (~resetn) begin
        div_state <= 0;
        // div_state[0] <= 1'b1;
    end else if (do_clear_a_from_pu) begin
        div_state <= 0;
        // div_state[0] <= 1'b1;
    end else begin
        div_state <= div_state_next;
    end
end

always @(*) begin
    div_state_next = 0;
    case (1'b1)
        div_state[0]: begin
            if (order_div_from_op) begin
                div_state_next[1] = 1'b1;
            end else begin
                div_state_next[0] = 1'b1;
            end
        end
        div_state[1]: begin
            div_state_next[2] = 1'b1;
        end
        div_state[2]: begin
            if (carry_out_from_au) begin
                div_state_next[0] = 1'b1;
            end else begin
                div_state_next[3] = 1'b1;
            end
        end
        div_state[3]: begin
            div_state_next[4] = 1'b1;
        end
        div_state[4]: begin
            if (counter_finish_mul_div) begin
                div_state_next[5] = 1'b1;
            end else begin
                div_state_next[3] = 1'b1;
            end
        end
        div_state[5]: begin
            div_state_next[0] = 1'b1;
        end
        default: begin
            div_state_next[0] = 1'b1;
        end
    endcase
end

assign div_do_not_a = 
    div_state[1];
assign div_do_sign = 
    div_state[1];
assign div_do_left_shift_b =
    div_state[3];
assign div_do_left_shift_c = div_do_left_shift_b;
assign div_do_left_shift_c29 = div_do_left_shift_b;
assign div_do_sum =
    div_state[4] && (carry_out_from_au != reg_b0_from_au);
assign div_do_set_c_30 = div_do_sum;
assign div_do_move_c_to_b = 
    div_state[5];
assign div_ac_answer = 
    div_state[5];
assign counter_clear_div =
    div_state[5];
assign counter_count_div =
    div_state[4];

// and
always @(posedge clk) begin
    if (~resetn) begin
        and_state <= 0;
        // and_state[0] <= 1'b1;
    end else if (do_clear_a_from_pu) begin
        and_state <= 0;
        // and_state[0] <= 1'b1;
    end else begin
        and_state <= and_state_next;
    end
end

always @(*) begin
    and_state_next = 0;
    case (1'b1)
        and_state[0]: begin
            if (order_and_from_op) begin
                and_state_next[1] = 1'b1;
            end else begin
                and_state_next[0] = 1'b1;
            end
        end
        and_state[1]: begin
            and_state_next[2] = 1'b1;
        end
        and_state[2]: begin
            and_state_next[0] = 1'b1;
        end
        default: begin
            and_state_next[0] = 1'b1;
        end
    endcase
end

assign and_do_and =
    and_state[1];
assign and_do_move_c_to_b =
    and_state[2];
assign and_ac_answer =
    and_state[2];

// io
always @(posedge clk) begin
    if (~resetn) begin
        io_state <= 0;
        // io_state[0] <= 1'b1;
    end else if (do_clear_a_from_pu) begin
        io_state <= 0;
        // io_state[0] <= 1'b1;
    end else begin
        io_state <= io_state_next;
    end
end

always @(*) begin
    io_state_next = 0;
    case (1'b1)
        io_state[0]: begin
            if (order_io_from_io) begin
                io_state_next[1] = 1'b1;
            end else begin
                io_state_next[0] = 1'b1;
            end
        end
        io_state[1]: begin
            if (counter_finish_io) begin
                io_state_next[2] = 1'b1;
            end else begin
                io_state_next[1] = 1'b1;
            end
        end
        io_state[2]: begin
            io_state_next[0] = 1'b1;
        end
        default: begin
            io_state_next[0] = 1'b1;
        end
    endcase
end

assign io_do_left_shift_c =
    io_state[1];
assign io_do_left_shift_c29 =
    io_state[1] && shift_3_bit_from_io;
assign io_ac_answer =
    io_state[2];
assign counter_clear_io =
    io_state[2];
assign counter_count_io =
    io_state[1];

// sign
assign sign_mul_div = reg_a_sign ^ reg_b_sign;
assign sign_sub = reg_b_sign ^ !carry_out_from_au;

always @(posedge clk) begin
    if (~resetn) begin
        reg_a_sign <= 1'b0;
    end else if (do_move_c_to_a_from_pu)  begin
        reg_a_sign <= reg_c_sign && (!ctrl_abs_from_op);
    end else if (do_clear_a_to_au) begin
        reg_a_sign <= 1'b0;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        reg_b_sign <= 1'b0;
    end else if (do_move_c_to_b_from_pu)  begin
        reg_b_sign <= reg_c_sign && (!ctrl_abs_from_op);
    end else if (do_move_b_to_c_from_pu)  begin
        reg_b_sign <= reg_b_sign && (!ctrl_abs_from_op);
    end else if (mul_do_sign || div_do_sign) begin
        reg_b_sign <= sign_mul_div;
    end else if (sub_do_sign) begin
        reg_b_sign <= sign_sub;
    end else if (do_clear_b_to_au) begin
        reg_b_sign <= 1'b0;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        reg_c_sign <= 1'b0;
    end else if (do_move_b_to_c_from_pu) begin
        reg_c_sign <= reg_b_sign && (!ctrl_abs_from_op);
    end else if (do_move_sign) begin
        reg_c_sign <= reg_b_sign;
    end else if (do_clear_c_to_au) begin
        reg_c_sign <= 1'b0;
    end else if (do_left_shift_c_to_au) begin
        reg_c_sign <= reg_c1_from_au;
    end else if (mem_read_reply_from_mem) begin
        reg_c_sign <= read_sign_from_mem;
    end else if (do_arr_c_from_pnl) begin
        reg_c_sign <= arr_reg_c_sign_from_pnl;
    end
end

// output
assign ac_answer_to_op =
    add_ac_answer ||
    sub_ac_answer ||
    mul_ac_answer ||
    div_ac_answer ||
    and_ac_answer;
assign ac_answer_to_io =
    io_ac_answer;
assign do_clear_a_to_au =
    do_clear_a_from_pu;
assign do_clear_b_to_au =
    mul_do_clear_b;
assign do_clear_c_to_au =
    1'b0;
assign do_not_a_to_au =
    sub_do_not_a ||
    div_do_not_a;
assign do_not_b_to_au =
    sub_do_not_b;
assign do_sum_to_au =
    add_do_sum ||
    sub_do_sum ||
    mul_do_sum ||
    div_do_sum;
assign do_and_to_au =
    and_do_and;
assign do_set_c_30_to_au =
    div_do_set_c_30;
assign do_left_shift_b_to_au =
    div_do_left_shift_b;
assign do_left_shift_c_to_au =
    div_do_left_shift_c ||
    io_do_left_shift_c;
assign do_left_shift_c_to_io = do_left_shift_c_to_au;
assign do_left_shift_c29_to_au =
    div_do_left_shift_c29 ||
    io_do_left_shift_c29;
assign do_right_shift_bc_to_au =
    mul_do_right_shift_bc;
assign do_move_c_to_a_to_au =
    do_move_c_to_a_from_pu;
assign do_move_c_to_b_to_au =
    do_move_c_to_b_from_pu ||
    div_do_move_c_to_b ||
    and_do_move_c_to_b;
assign do_move_b_to_c_to_au =
    do_move_b_to_c_from_pu ||
    add_do_move_b_to_c ||
    sub_do_move_b_to_c ||
    mul_do_move_b_to_c;
assign do_move_sign = 
    add_do_move_b_to_c || 
    sub_do_move_b_to_c ||
    mul_do_move_b_to_c ||
    div_do_move_c_to_b ||
    and_do_move_c_to_b;
assign do_mem_to_c_to_au =
    mem_read_reply_from_mem;

assign reg_a_sign_to_op = reg_a_sign;
assign reg_b_sign_to_op = reg_b_sign;
// assign reg_b_sign_to_pu = reg_b_sign;
assign reg_c_sign_to_pnl = reg_c_sign;
assign write_sign_to_mem = reg_c_sign;
assign output_sign_to_io = reg_c_sign;

endmodule
