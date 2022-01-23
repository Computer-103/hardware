/**
 * ЭУВВ
 * электронный блок устройства ввода и вывода
 * 输入输出电子部件
**/

module io_unit (
    input clk,
    input resetn,

    input  reg_c_sign_from_ac,          // level, from ac

    input  order_write_from_op,         // pulse, from op
    input  order_input_from_op,         // pulse, from op
    input  order_output_from_op,        // pulse, from op
    input  start_pulse_from_op,         // pulse, from op

    input  do_left_shift_c_from_ac,     // pulse, from ac
    input  ac_answer_from_ac,           // pulse, from ac

    input  mem_write_reply_from_mem,    // pulse, from mem
    input  mem_reply_from_mem,          // pulse, from mem

    input  input_oct_from_pnl,          // level, from pnl
    input  input_dec_from_pnl,          // level, from pnl
    input  output_oct_from_pnl,         // level, from pnl
    input  output_dec_from_pnl,         // level, from pnl
    input  continuous_input_from_pnl,   // level, from pnl
    input  stop_after_output_from_pnl,  // level, from pnl

    output shift_3_bit_to_ac,           // level, to ac
    output shift_4_bit_to_ac,           // level, to ac

    output order_io_to_ac,              // pulse, to ac
    output do_addr2_to_sel_to_sel,      // pulse, to sel
    output mem_write_to_mem,            // pulse, to mem
    output start_pulse_to_pu,           // pulse, to pu

    input  output_sign_from_ac,         // value, from ac
    input  [ 3:0] output_data_from_au,  // value, from au
    output [ 4:0] input_data_to_ac,     // value, to ac

    input  input_rdy_from_dev,
    output input_ack_to_dev,
    input  [ 4:0] input_data_from_dev,  // value, from dev

    output [ 4:0] output_data_to_dev    // value, to dev
);

`define IDLE 0
`define IN_ACK 1
`define IN_DONE 2
`define IN_NUM 3
`define IN_WRITE 4

// input statement machine
reg  input_active;
reg  [ 4:0] input_state;
reg  [ 4:0] input_state_next;
reg  [ 4:0] reg_input;

wire input_is_num;
wire input_is_write;
wire input_is_end;
wire input_is_sel;

wire order_io_from_input;
wire order_write_from_input;
wire stop_input_from_input;

// output statement machine
reg  output_active;

wire order_io_from_output;
wire start_pulse_from_output;


// order_write & start_pulse
reg  order_write_r;
reg  start_pulse_r;

// input statement machine
always @(posedge clk) begin
    if (~resetn) begin
        input_active <= 1'b0;
    end else if (stop_input_from_input || 1'b0) begin
        // TODO: need input stop button
        input_active <= 1'b0;
    end else if (order_input_from_op || 1'b0) begin
        // TODO: need input start button
        input_active <= 1'b1;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        input_state <= 0;
        input_state[`IDLE] <= 1;
    // ? need clear signal?
    end else begin
        input_state <= input_state_next;
    end
end

always @(*) begin
    input_state_next = 0;
    case (1'b1)
        input_state[`IDLE]: begin
            if (input_active && input_rdy_from_dev) begin
                input_state_next[`IN_ACK] = 1;
            end else begin
                input_state_next[`IDLE] = 1;
            end
        end
        input_state[`IN_ACK]: begin
            if (~input_rdy_from_dev) begin
                input_state_next[`IN_DONE] = 1;
            end else begin
                input_state_next[`IN_ACK] = 1;
            end
        end
        input_state[`IN_DONE]: begin
            if (input_is_num) begin
                input_state_next[`IN_NUM] = 1;
            end else if (input_is_write) begin
                input_state_next[`IN_WRITE] = 1;
            end else begin
                input_state_next[`IDLE] = 1;
            end
        end
        input_state[`IN_NUM]: begin
            if (ac_answer_from_ac) begin
                input_state_next[`IDLE] = 1;
            end else begin
                input_state_next[`IN_NUM] = 1;
            end
        end
        input_state[`IN_WRITE]: begin
            if (mem_write_reply_from_mem) begin
                input_state_next[`IDLE] = 1;
            end else begin
                input_state_next[`IN_NUM] = 1;
            end
        end
        default: begin
            input_state_next[`IDLE] = 1;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        reg_input <= 5'b0;
    end else if (input_state[`IDLE] && input_active && input_rdy_from_dev) begin
        reg_input <= input_data_from_dev;
    end
end

assign input_is_num = 
    (reg_input & 5'b10000) == 5'b10000;
assign input_is_write =
    (reg_input & 5'b10111) == 5'b00110;
assign input_is_end =
    (reg_input & 5'b10111) == 5'b00111;
assign input_is_sel =
    (reg_input & 5'b10111) == 5'b00001;

assign order_io_from_input =
    input_state[`IN_DONE] && input_is_num;
assign order_write_from_input =
    input_state[`IN_DONE] && input_is_write;
assign do_addr2_to_sel_to_sel =
    input_state[`IN_DONE] && input_is_sel;
assign stop_input_from_input =
    input_state[`IN_DONE] && (
        (input_is_write && !continuous_input_from_pnl) ||
        input_is_end
    );

// TODO: output statement machine

// level for oct/dec
assign shift_3_bit_to_ac =
    (input_active  && input_oct_from_pnl) ||
    (output_active && output_oct_from_pnl);
assign shift_4_bit_to_ac =
    (input_active  && input_dec_from_pnl) ||
    (output_active && output_dec_from_pnl);

// pulses
always @(posedge clk) begin
    if (~resetn) begin
        order_write_r  <= 1'b0;
        start_pulse_r  <= 1'b0;
    end else begin
        order_write_r  <= order_write_from_op;
        start_pulse_r  <= start_pulse_from_op;
    end
end

assign mem_write_to_mem  = order_write_r || order_write_from_input;
// TODO: need add start pulse button from pnl
assign start_pulse_to_pu = start_pulse_r || start_pulse_from_output;

assign order_io_to_ac = 
    order_io_from_input || order_io_from_output;

endmodule
