/**
 * МПД
 * местного программного датчика
 * 局部程序发送器
**/

`include "const.vh"
module arith_ctrl (
    input  clk,
    input  resetn,

    input  clear_a_from_pu,         // pulse, from pu
    input  move_b_to_c_from_pu,     // pulse, from pu
    input  move_c_to_b_from_pu,     // pulse, from pu
    input  move_c_to_a_from_pu,     // pulse, from pu

    input  order_add_from_op,       // pulse, from op
    input  order_sub_from_op,       // pulse, from op
    input  order_mul_from_op,       // pulse, from op
    input  order_div_from_op,       // pulse, from op
    input  order_and_from_op,       // pulse, from op
    input  order_io_from_io,        // pulse, from io

    input  shift_3_bit,             // level, from io
    input  shift_4_bit,             // level, from io

    input  mem_read_sign_from_mem,  // level, from mem

    input  carry_out_from_au,       // level, from au
    input  reg_c_30_from_au,        // level, from au
    input  reg_b_0_from_au,         // level, from au

    output au_answer_to_op,         // pulse, to op

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
    output do_left_shift_c29_to_au, // pulse, to au
    output do_right_shift_bc_to_au, // pulse, to au
    output do_move_c_to_a_to_au,    // pulse, to_au
    output do_move_c_to_b_to_au,    // pulse, to_au
    output do_move_b_to_c_to_au,    // pulse, to au

    output reg_a_sign_to_op,        // level, to op
    output reg_b_sign_to_op,        // level, to op
    output reg_b_sign_to_pu,        // level, to pu
    output mem_write_sign_to_mem,   // level, to mem
    output reg_c_sign_to_io         // level, to io
);

// counter_r for mul, div, io
reg [ 4:0] counter_r;

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
wire add_au_answer;

// sub
reg  [ 4:0] sub_state;
reg  [ 4:0] sub_state_next;
wire sub_do_not_a;
wire sub_do_not_b;
wire sub_do_sum;
wire sub_do_move_b_to_c;
wire sub_au_answer;

// mul
reg  [ 4:0] mul_state;
reg  [ 4:0] mul_state_next;
wire mul_do_clear_b;
wire mul_do_sum;
wire mul_do_right_shift_bc;
wire mul_do_move_b_to_c;
wire mul_au_answer;

// div
reg  [ 5:0] div_state;
reg  [ 5:0] div_state_next;
wire div_do_not_a;
wire div_do_left_shift_b;
wire div_do_left_shift_c;
wire div_do_left_shift_c29;
wire div_do_sum;
wire div_do_set_c_30;
wire div_do_move_c_to_b;
wire div_au_answer;

// and
reg  [ 2:0] and_state;
reg  [ 2:0] and_state_next;
wire and_do_and;
wire and_do_move_c_to_b;
wire and_au_answer;

// io
reg  [ 2:0] io_state;
reg  [ 2:0] io_state_next;
wire io_do_left_shift_c;
wire io_do_left_shift_c29;
wire io_au_answer;

// TODO: sign
reg  reg_a_sign;
reg  reg_b_sign;
reg  reg_c_sign;

// counter_r for mul, div, io
always @(posedge clk) begin
    if (~resetn) begin
        counter_r <= 5'b0;
    end else if (clear_a_from_pu) begin
        counter_r <= 5'b0;
    end else if (counter_count) begin
        counter_r <= counter_r + 5'b1;
    end
end

assign counter_count = 
    counter_count_mul || counter_count_div || counter_count_io;

assign counter_finish_mul_div = 
    counter_r == 5'd29;
assign counter_finish_io = 
    (shift_3_bit && counter_r == 5'd2) ||
    (shift_4_bit && counter_r == 5'd3);

// add
always @(posedge clk) begin
    if (~resetn) begin
        add_state <= 0;
        add_state[1] <= 1'b1;
    end else if (clear_a_from_pu) begin
        add_state <= 0;
        add_state[1] <= 1'b1;
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
assign add_au_answer = 
    add_state[2];

// sub
always @(posedge clk) begin
    if (~resetn) begin
        sub_state <= 0;
        sub_state[1] <= 1'b1;
    end else if (clear_a_from_pu) begin
        sub_state <= 0;
        sub_state[1] <= 1'b1;
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
assign sub_do_sum = 
    (sub_state[2] && carry_out_from_au) || 
    (sub_state[3]);
assign sub_do_move_b_to_c =
    (sub_state[4]);
assign sub_au_answer =
    (sub_state[4]);

// mul
always @(posedge clk) begin
    if (~resetn) begin
        mul_state <= 0;
        mul_state[1] <= 1'b1;
    end else if (clear_a_from_pu) begin
        mul_state <= 0;
        mul_state[1] <= 1'b1;
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
assign mul_do_sum =
    reg_c_30_from_au && mul_state[2];
assign mul_do_right_shift_bc = 
    mul_state[3];
assign mul_do_move_b_to_c =
    mul_state[4];
assign mul_au_answer =
    mul_state[4];

// div
always @(posedge clk) begin
    if (~resetn) begin
        div_state <= 0;
        div_state[1] <= 1'b1;
    end else if (clear_a_from_pu) begin
        div_state <= 0;
        div_state[1] <= 1'b1;
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
assign div_do_left_shift_b =
    div_state[3];
assign div_do_left_shift_c = div_do_left_shift_b;
assign div_do_left_shift_c29 = div_do_left_shift_b;
assign div_do_sum =
    div_state[4] && (carry_out_from_au != reg_b_0_from_au);
assign div_do_set_c_30 = div_do_sum;
assign div_do_move_c_to_b = 
    div_state[5];
assign div_au_answer = 
    div_state[5];


// and
always @(posedge clk) begin
    if (~resetn) begin
        and_state <= 0;
        and_state[1] <= 1'b1;
    end else if (clear_a_from_pu) begin
        and_state <= 0;
        and_state[1] <= 1'b1;
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
assign and_au_answer =
    and_state[2];

// io
always @(posedge clk) begin
    if (~resetn) begin
        io_state <= 0;
        io_state[1] <= 1'b1;
    end else if (clear_a_from_pu) begin
        io_state <= 0;
        io_state[1] <= 1'b1;
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
    io_state[1] && shift_4_bit;
assign io_au_answer =
    io_state[2];

// TODO: sign

endmodule