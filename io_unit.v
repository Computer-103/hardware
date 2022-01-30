/**
 * ЭУВВ
 * электронный блок устройства ввода и вывода
 * 输入输出电子部件
**/

module io_unit (
    input clk,
    input resetn,

    input  order_write_from_op,         // pulse, from op
    input  order_input_from_op,         // pulse, from op
    input  order_output_from_op,        // pulse, from op
    input  start_pulse_from_op,         // pulse, from op

    input  do_left_shift_c_from_ac,     // pulse, from ac
    input  ac_answer_from_ac,           // pulse, from ac

    input  mem_write_reply_from_mem,    // pulse, from mem
    input  mem_reply_from_mem,          // pulse, from mem

    input  start_pulse_from_pnl,        // pulse, from pnl
    input  automatic_from_pnl,          // level, from pnl

    input  start_input_from_pnl,        // pulse, from pnl
    input  stop_input_from_pnl,         // pulse, from pnl
    input  start_output_from_pnl,       // pulse, from pnl
    input  stop_output_from_pnl,        // pulse, from pnl
    input  input_oct_from_pnl,          // level, from pnl
    input  input_dec_from_pnl,          // level, from pnl
    input  output_oct_from_pnl,         // level, from pnl
    input  output_dec_from_pnl,         // level, from pnl
    input  continuous_input_from_pnl,   // level, from pnl
    input  stop_after_output_from_pnl,  // level, from pnl

    output input_active_to_pnl,             // level, to pnl
    output output_active_to_pnl,            // level, to pnl

    output shift_3_bit_to_ac,           // level, to ac
    output shift_4_bit_to_ac,           // level, to ac

    output order_io_to_ac,              // pulse, to ac
    output do_addr2_to_sel_to_sel,      // pulse, to sel
    output mem_write_to_mem,            // pulse, to mem
    output start_pulse_to_pu,           // pulse, to pu

    input  output_sign_from_ac,         // value, from ac
    input  [ 3:0] output_data_from_au,  // value, from au
    output [ 4:0] input_data_to_au,     // value, to au

    output input_rdy_to_dev,            // handshake
    input  input_val_from_dev,          // handshake
    input  [ 4:0] input_data_from_dev,  // value, from dev

    output output_rdy_to_dev,           // handshake
    input  output_ack_from_dev,         // handshake
    output [ 4:0] output_data_to_dev    // value, to dev
);

`define IN_IDLE 0
`define IN_RDY 1
`define IN_VAL 2
`define IN_DONE 3
`define IN_NUM 4
`define IN_WRITE 5

`define OUT_IDLE 7'b0000_000
`define OUT_RDY 0
`define OUT_ACK 1
`define OUT_DONE 2
`define OUT_SHIFT 3

// input statement machine
reg  input_active;
reg  [ 5:0] input_state;
reg  [ 5:0] input_state_next;
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
reg  [ 3:0] output_state_a;
reg  [ 3:0] output_state_b;
reg  [ 3:0] output_state_a_next;
reg  [ 3:0] output_state_b_next;

wire output_sign;
wire output_num;
wire output_finish;

wire order_io_from_output;
wire start_pulse_from_output;
wire stop_output_from_output;

// order_write & start_pulse
reg  order_write_r;
wire start_pulse_delay;
reg  start_pulse_r;
wire start_pulse_auto;

// input statement machine
always @(posedge clk) begin
    if (~resetn) begin
        input_active <= 1'b0;
    end else if (stop_input_from_input || stop_input_from_pnl) begin
        input_active <= 1'b0;
    end else if (order_input_from_op || start_input_from_pnl) begin
        input_active <= 1'b1;
    end
end
assign input_active_to_pnl = input_active;

always @(posedge clk) begin
    if (~resetn) begin
        input_state <= 0;
        // input_state[`IN_IDLE] <= 1;
    // ? need clear signal?
    end else begin
        input_state <= input_state_next;
    end
end

always @(*) begin
    input_state_next = 0;
    case (1'b1)
        input_state[`IN_IDLE]: begin
            if (input_active) begin
                input_state_next[`IN_RDY] = 1;
            end else begin
                input_state_next[`IN_IDLE] = 1;
            end
        end
        input_state[`IN_RDY]: begin
            if (input_val_from_dev) begin
                input_state_next[`IN_VAL] = 1;
            end else begin
                input_state_next[`IN_RDY] = 1;
            end
        end
        input_state[`IN_VAL]: begin
            if (!input_val_from_dev) begin
                input_state_next[`IN_DONE] = 1;
            end else begin
                input_state_next[`IN_VAL] = 1;
            end
        end
        input_state[`IN_DONE]: begin
            if (input_is_num) begin
                input_state_next[`IN_NUM] = 1;
            end else if (input_is_write) begin
                input_state_next[`IN_WRITE] = 1;
            end else begin
                input_state_next[`IN_IDLE] = 1;
            end
        end
        input_state[`IN_NUM]: begin
            if (ac_answer_from_ac) begin
                input_state_next[`IN_IDLE] = 1;
            end else begin
                input_state_next[`IN_NUM] = 1;
            end
        end
        input_state[`IN_WRITE]: begin
            if (mem_write_reply_from_mem) begin
                input_state_next[`IN_IDLE] = 1;
            end else begin
                input_state_next[`IN_WRITE] = 1;
            end
        end
        default: begin
            input_state_next[`IN_IDLE] = 1;
        end
    endcase
end

assign input_rdy_to_dev = input_state[`IN_RDY];

always @(posedge clk) begin
    if (~resetn) begin
        reg_input <= 5'b0;
    end else if (input_state[`IN_RDY] && input_val_from_dev) begin
        reg_input <= input_data_from_dev;
    end else if (do_left_shift_c_from_ac) begin
        reg_input <= {reg_input[3:0], 1'b0};
    end
end
assign input_data_to_au = 
    {5{input_active}} & reg_input;

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

// output statement machine
always @(posedge clk) begin
    if (~resetn) begin
        output_active <= 1'b0;
    end else if (stop_output_from_output || stop_output_from_pnl) begin
        output_active <= 1'b0;
    end else if (order_output_from_op || start_output_from_pnl) begin
        output_active <= 1'b1;
    end
end
assign output_active_to_pnl = output_active;

always @(posedge clk) begin
    if (~resetn) begin
        output_state_a <= 4'd0;
        output_state_b <= 4'b0000;
    end else begin
        output_state_a <= output_state_a_next;
        output_state_b <= output_state_b_next;
    end
end

always @(*) begin
    if (output_state_b[`OUT_DONE]) begin
        if (output_finish) begin
            output_state_a_next = 4'd0;
        end else begin
            output_state_a_next = output_state_a + 4'd1;
        end
    end else begin
        output_state_a_next = output_state_a;
    end

    output_state_b_next = 0;
    case (1'b1)
        output_state_b[`OUT_RDY]: begin
            if (output_ack_from_dev) begin
                output_state_b_next[`OUT_ACK] = 1;
            end else begin
                output_state_b_next[`OUT_RDY] = 1;
            end
        end
        output_state_b[`OUT_ACK]: begin
            if (~output_ack_from_dev) begin
                output_state_b_next[`OUT_DONE] = 1;
            end else begin
                output_state_b_next[`OUT_ACK] = 1;
            end
        end
        output_state_b[`OUT_DONE]: begin
            if (!output_finish) begin
                if (output_num) begin
                    output_state_b_next[`OUT_SHIFT] = 1;
                end else begin
                    output_state_b_next[`OUT_RDY] = 1;
                end
            end
        end
        output_state_b[`OUT_SHIFT]: begin
            if (ac_answer_from_ac) begin
                output_state_b_next[`OUT_RDY] = 1;
            end else begin
                output_state_b_next[`OUT_SHIFT] = 1;
            end
        end
        default: begin
            if (output_active) begin
                output_state_b_next[`OUT_RDY] = 1;
            end
        end
    endcase
end

assign output_rdy_to_dev = output_state_b[`OUT_RDY];

assign output_data_to_dev = 
    ({5{output_sign}} & {4'b1111, output_sign_from_ac}) |
    ({5{output_num && output_oct_from_pnl}} & {2'b10, output_data_from_au[3:1]}) |
    ({5{output_num && output_dec_from_pnl}} & {1'b1, output_data_from_au[3:0]}) |
    ({5{output_finish}} & 5'b00110);

assign output_sign = 
    output_state_a == 4'd00;
assign output_num = 
    output_state_a == 4'd01 ||
    output_state_a == 4'd02 ||
    output_state_a == 4'd03 ||
    output_state_a == 4'd04 ||
    output_state_a == 4'd05 ||
    output_state_a == 4'd06 ||
    output_state_a == 4'd07 ||
    (output_oct_from_pnl && output_state_a == 4'd08) ||
    (output_oct_from_pnl && output_state_a == 4'd09) ||
    (output_oct_from_pnl && output_state_a == 4'd10);
assign output_finish = 
    (output_oct_from_pnl && output_state_a == 4'd11) || 
    (output_dec_from_pnl && output_state_a == 4'd08);

assign order_io_from_output = 
    output_num && output_state_b[`OUT_DONE];
assign start_pulse_from_output =
    output_finish && output_state_b[`OUT_DONE] && 
    !stop_after_output_from_pnl;
assign stop_output_from_output =
    output_finish && output_state_b[`OUT_DONE];

// level for oct/dec
assign shift_3_bit_to_ac =
    (input_active  && input_oct_from_pnl) ||
    (output_active && output_oct_from_pnl);
assign shift_4_bit_to_ac =
    (input_active  && input_dec_from_pnl) ||
    (output_active && output_dec_from_pnl);

// pulses
assign start_pulse_delay = 
    start_pulse_from_op ||
    (mem_reply_from_mem && !order_output_from_op);

always @(posedge clk) begin
    if (~resetn) begin
        order_write_r <= 1'b0;
        start_pulse_r <= 1'b0;
    end else begin
        order_write_r <= order_write_from_op;
        start_pulse_r <= start_pulse_delay;
    end
end

assign mem_write_to_mem  = 
    order_write_r || order_write_from_input;
// TODO: need add start pulse button from pnl
assign start_pulse_auto = 
    start_pulse_r || start_pulse_from_output;
assign start_pulse_to_pu = 
    (automatic_from_pnl && start_pulse_auto) ||
    (start_pulse_from_pnl);

assign order_io_to_ac = 
    order_io_from_input || order_io_from_output;

endmodule
