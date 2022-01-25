/**
 * РИ
 * распределителя импульсов
 * 脉冲分配器
**/

module pulse_unit (
    input clk,
    input resetn,

    output do_code_to_op_to_op,     // pulse, to op
    output do_inc_strt_to_strt,     // pulse, to start_reg
    output do_addr1_to_sel_to_sel,  // pulse, to select_reg
    output do_addr2_to_sel_to_sel,  // pulse, to select_reg
    output do_strt_to_sel_to_sel,   // pulse, to select_reg
    output do_sel_to_strt_to_strt,  // pulse, to start_reg
    output do_mem_to_c_to_ac,       // pulse, to airth_ctrl
    output do_clear_a_to_ac,        // pulse, to airth_ctrl
    output do_move_c_to_a_to_ac,    // pulse, to airth_ctrl
    output do_move_c_to_b_to_ac,    // pulse, to airth_ctrl
    output do_move_b_to_c_to_ac,    // pulse, to airth_ctrl

    output do_move_c_to_a_to_op,    // pulse, to op
    output do_move_b_to_c_to_op,    // pulse, to op

    output operate_pulse_to_op,     // pulse, to op
    output mem_read_to_mem,         // pulse, to mem

    input  mem_read_reply_from_mem, // pulse, from mem
    input  start_pulse_from_io,     // pulse, from io_unit
    input  clear_pu_from_pnl,       // pulse, from pnl

    input  [ 5:0] ctrl_bus_from_op, // level bus, from op
    
    output [ 2:0] pu_state_to_pnl   // level, to pnl
);

reg [ 2:0] cur_pulse;
reg [ 2:0] next_pulse;

wire [7:0] do_pulse;
// wire do_pulse;
wire [7:0] at_pulse;
wire [7:0] entering_pulse;

wire ctrl_select_to_start_at_4;
wire ctrl_select_to_start_at_7;
wire ctrl_move_b_to_c_at_7;         // opp: ctrl_move_c_to_b_at_7
wire ctrl_move_c_to_b_at_7;         // new
wire ctrl_mem_read_at_3;
wire ctrl_mem_read_at_5;
wire wait_start_at_4;
wire wait_start_at_6;

// pulse ctrl

assign {
    ctrl_select_to_start_at_4,
    ctrl_select_to_start_at_7,
    ctrl_move_b_to_c_at_7,
    ctrl_mem_read_at_3,
    ctrl_mem_read_at_5,
    wait_start_at_6
} = ctrl_bus_from_op;

assign ctrl_move_c_to_b_at_7 = !ctrl_move_b_to_c_at_7;
assign wait_start_at_4       = ctrl_mem_read_at_3;

// state machine of pulse
assign pu_state_to_pnl = cur_pulse;

always @(posedge clk) begin
    if (~resetn) begin
        cur_pulse <= 3'o0;
    end else if (clear_pu_from_pnl) begin
        cur_pulse <= 3'o0;
    end else begin
        cur_pulse <= next_pulse;
    end
end

always @ (*) begin
    if (|do_pulse) begin
        next_pulse = cur_pulse + 3'o1;
    end else begin
        next_pulse = cur_pulse;
    end
end

assign at_pulse[0] = cur_pulse == 3'o0;
assign at_pulse[1] = cur_pulse == 3'o1;
assign at_pulse[2] = cur_pulse == 3'o2;
assign at_pulse[3] = cur_pulse == 3'o3;
assign at_pulse[4] = cur_pulse == 3'o4;
assign at_pulse[5] = cur_pulse == 3'o5;
assign at_pulse[6] = cur_pulse == 3'o6;
assign at_pulse[7] = cur_pulse == 3'o7;

assign entering_pulse[1] = do_pulse[0];
assign entering_pulse[2] = do_pulse[1];
assign entering_pulse[3] = do_pulse[2];
assign entering_pulse[4] = do_pulse[3];
assign entering_pulse[5] = do_pulse[4];
assign entering_pulse[6] = do_pulse[5];
assign entering_pulse[7] = do_pulse[6];
assign entering_pulse[0] = do_pulse[7];

assign do_pulse[0] = at_pulse[0] && start_pulse_from_io;
assign do_pulse[1] = at_pulse[1];
assign do_pulse[2] = at_pulse[2] && start_pulse_from_io;
assign do_pulse[3] = at_pulse[3];
assign do_pulse[4] = at_pulse[4] && (start_pulse_from_io || !wait_start_at_4);
assign do_pulse[5] = at_pulse[5];
assign do_pulse[6] = at_pulse[6] && (start_pulse_from_io || !wait_start_at_6);
assign do_pulse[7] = at_pulse[7];


// output control signals
assign do_code_to_op_to_op      = entering_pulse[3];
assign do_inc_strt_to_strt      = entering_pulse[3];
assign do_addr1_to_sel_to_sel   = entering_pulse[3];
assign do_addr2_to_sel_to_sel   =
    (at_pulse[4] && mem_read_reply_from_mem && wait_start_at_4) ||
    (entering_pulse[4]        && !wait_start_at_4);
assign do_strt_to_sel_to_sel    = entering_pulse[1];
assign do_sel_to_strt_to_strt   =
    (entering_pulse[4] && ctrl_select_to_start_at_4) ||
    (entering_pulse[7] && ctrl_select_to_start_at_7);
assign do_move_c_to_a_to_ac     = entering_pulse[5];
assign do_move_c_to_b_to_ac     =
    (entering_pulse[7] && ctrl_move_c_to_b_at_7);
assign do_move_b_to_c_to_ac     =
    (entering_pulse[7] && ctrl_move_b_to_c_at_7);
assign do_mem_to_c_to_ac        =
    (at_pulse[2] && mem_read_reply_from_mem) ||
    (at_pulse[4] && mem_read_reply_from_mem && ctrl_mem_read_at_3) ||
    (at_pulse[6] && mem_read_reply_from_mem && ctrl_mem_read_at_5);
assign mem_read_to_mem          =
    (at_pulse[1]) ||
    (at_pulse[3] && ctrl_mem_read_at_3) ||
    (at_pulse[5] && ctrl_mem_read_at_5);
assign operate_pulse_to_op      = at_pulse[7];
assign do_clear_a_to_ac         = at_pulse[1];

assign do_move_c_to_a_to_op = do_move_c_to_a_to_ac;
assign do_move_b_to_c_to_op = do_move_b_to_c_to_ac;

endmodule
