module core_top (
    input clk,
    input resetn,

    input btn_machine_start,
    input btn_clear_pulse,
    input btn_do_read_mem,
    input btn_do_write_mem,
    
    input switch_auto_enable,
    input switch_stop_at_enable,
    input switch_select_or_start,

    input btn_write_reg,
    input btn_clear_reg_c,
    input btn_clear_reg_select,
    input btn_clear_reg_start,
    input switch_arr_reg_c,
    input switch_arr_reg_select,
    input switch_arr_reg_start,

    input  [30:0] input_reg_c_value,
    input  [11:0] input_reg_select_value,
    input  [11:0] input_reg_start_value,

    output [30:0] light_reg_c_value,
    output [11:0] light_reg_select_value,
    output [11:0] light_reg_start_value,
    output [ 5:0] light_op_code_value,
    output [ 2:0] light_pulse_counter_value
);

wire au_do_clear_a;
wire au_do_clear_b;
wire au_do_clear_c;
wire au_do_not_a;
wire au_do_not_b;
wire au_do_sum;
wire au_do_and;
wire au_do_set_c_30;
wire au_do_left_shift_b;
wire au_do_left_shift_c;
wire au_do_left_shift_c29;
wire au_do_right_shift_bc;
wire au_do_move_c_to_a;
wire au_do_move_c_to_b;
wire au_do_move_b_to_c;

wire au_reg_d_0;
wire au_reg_b_0;
wire au_reg_c_30;

wire au_do_arr_c;
wire [29:0] au_arr_reg_c_value;
wire [29:0] au_reg_c_value;

wire au_io_input_data;
wire [ 3:0] au_io_output_data;

wire [ 5:0] au_op_code_value;
wire [11:0] au_addr1_value;
wire [11:0] au_addr2_value;
    
wire au_do_read_mem;
wire [29:0] au_mem_read_data;
wire [29:0] au_mem_write_data;


wire ac_do_clear_a;
wire ac_do_clear_b;
wire ac_do_clear_c;
wire ac_do_not_a;
wire ac_do_not_b;
wire ac_do_sum;
wire ac_do_and;
wire ac_do_set_c_30;
wire ac_do_left_shift_b;
wire ac_do_left_shift_c;
wire ac_do_left_shift_c29;
wire ac_do_right_shift_bc;
wire ac_do_move_c_to_a;
wire ac_do_move_c_to_b;
wire ac_do_move_b_to_c;
    
wire ac_reg_d_0;
wire ac_reg_b_0;
wire ac_reg_c_30;

wire ac_start;
wire ac_finish;

wire ac_reg_a_sign;
wire ac_reg_b_sign;
wire ac_reg_c_sign;
    
wire ac_do_arr_c;
wire ac_arr_reg_c_sign;

wire ac_do_read_mem;
wire ac_mem_read_sign;

wire [2:0] ac_operation;


wire me_write_enable;
wire me_read_enable;
wire me_finish;

wire [11:0] me_addr;
wire [30:0] me_write_data;
wire [30:0] me_read_data;

wire op_read_addr2;
wire op_write_addr2;
wire op_arth_and;

wire op_op_code_valid;
wire [5:0] op_op_code_value;


wire pu_do_c_to_operator;
wire pu_do_addr1_to_select;
wire pu_do_addr2_to_select;
wire pu_do_start_to_select;
wire pu_do_mem_to_c;
wire pu_do_start_inc;
wire pu_do_move_c_to_a;
wire pu_do_move_c_to_b;

wire pu_mem_read_pulse;
wire pu_mem_write_pulse;
wire pu_mem_reply;
    
wire pu_operate_pulse;
wire pu_operate_reply;

wire pu_start_pulse;


wire st_do_arr_reg_start;
wire [11:0] st_arr_reg_start_data;

wire st_do_reg_start_inc;

wire st_do_mod_reg_start;
wire [11:0] st_mod_reg_start_data;

wire [11:0] st_reg_start_value;


wire sl_do_arr_reg_select;
wire [11:0] sl_arr_reg_select_data;

wire sl_start_to_select_enable;
wire [11:0] sl_reg_start_value;

wire sl_addr1_to_select_enable;
wire [11:0] sl_addr1_value;

wire sl_addr2_to_select_enable;
wire [11:0] sl_addr2_value;

wire [11:0] sl_reg_select_value;

arith_unit u_arith_unit(
    .clk (clk),
    .resetn (resetn),

    .do_clear_a (au_do_clear_a),
    .do_clear_b (au_do_clear_b),
    .do_clear_c (au_do_clear_c),
    .do_not_a (au_do_not_a),
    .do_not_b (au_do_not_b),
    .do_sum (au_do_sum),
    .do_and (au_do_and),
    .do_set_c_30 (au_do_set_c_30),
    .do_left_shift_b (au_do_left_shift_b),
    .do_left_shift_c (au_do_left_shift_c),
    .do_left_shift_c29 (au_do_left_shift_c29),
    .do_right_shift_bc (au_do_right_shift_bc),
    .do_move_c_to_a (au_do_move_c_to_a),
    .do_move_c_to_b (au_do_move_c_to_b),
    .do_move_b_to_c (au_do_move_b_to_c),

    .reg_d_0 (au_reg_d_0),
    .reg_b_0 (au_reg_b_0),
    .reg_c_30 (au_reg_c_30),

    .do_arr_c (au_do_arr_c),
    .arr_reg_c_value (au_arr_reg_c_value),
    .reg_c_value (au_reg_c_value),

    .io_input_data (au_io_input_data),
    .io_output_data (au_io_output_data),

    .op_code_value (au_op_code_value),
    .addr1_value (au_addr1_value),
    .addr2_value (au_addr2_value),
    
    .do_read_mem (au_do_read_mem),
    .mem_read_data (au_mem_read_data),
    .mem_write_data (au_mem_write_data)
);

arith_ctrl u_arith_ctrl(
    .clk (clk),
    .resetn (resetn),

    .do_clear_a (ac_do_clear_a),
    .do_clear_b (ac_do_clear_b),
    .do_clear_c (ac_do_clear_c),
    .do_not_a (ac_do_not_a),
    .do_not_b (ac_do_not_b),
    .do_sum (ac_do_sum),
    .do_and (ac_do_and),
    .do_set_c_30 (ac_do_set_c_30),
    .do_left_shift_b (ac_do_left_shift_b),
    .do_left_shift_c (ac_do_left_shift_c),
    .do_left_shift_c29 (ac_do_left_shift_c29),
    .do_right_shift_bc (ac_do_right_shift_bc),
    .do_move_c_to_a (ac_do_move_c_to_a),
    .do_move_c_to_b (ac_do_move_c_to_b),
    .do_move_b_to_c (ac_do_move_b_to_c),
        
    .reg_d_0 (ac_reg_d_0),
    .reg_b_0 (ac_reg_b_0),
    .reg_c_30 (ac_reg_c_30),

    .start (ac_start),
    .finish (ac_finish),

    .reg_a_sign (ac_reg_a_sign),
    .reg_b_sign (ac_reg_b_sign),
    .reg_c_sign (ac_reg_c_sign),
        
    .do_arr_c (ac_do_arr_c),
    .arr_reg_c_sign (ac_arr_reg_c_sign),

    .do_read_mem (ac_do_read_mem),
    .mem_read_sign (ac_mem_read_sign),

    .operation (ac_operation)
);

memory u_memory(
    .clk (clk),
    .resetn (resetn),

    .write_enable (me_write_enable),
    .read_enable (me_read_enable),
    .finish (me_finish),

    .addr (me_addr),
    .write_data (me_write_data),
    .read_data (me_read_data)
);

operator u_operator(
    .clk (clk),
    .resetn (resetn),

    .read_addr2 (op_read_addr2),
    .write_addr2 (op_write_addr2),
    .arth_and (op_arth_and),

    .op_code_valid (op_op_code_valid),
    .op_code_value (op_op_code_value)
);

pulse_unit u_pulse_unit(
    .clk (clk),
    .resetn (resetn),

    .do_c_to_operator (pu_do_c_to_operator),
    .do_addr1_to_select (pu_do_addr1_to_select),
    .do_addr2_to_select (pu_do_addr2_to_select),
    .do_start_to_select (pu_do_start_to_select),
    .do_mem_to_c (pu_do_mem_to_c),
    .do_start_inc (pu_do_start_inc),
    .do_move_c_to_a (pu_do_move_c_to_a),
    .do_move_c_to_b (pu_do_move_c_to_b),

    .mem_read_pulse (pu_mem_read_pulse),
    .mem_write_pulse (pu_mem_write_pulse),
    .mem_reply (pu_mem_reply),
    
    .operate_pulse (pu_operate_pulse),
    .operate_reply (pu_operate_reply),

    .start_pulse (pu_start_pulse)
);

start_reg u_start_reg(
    .clk (clk),
    .resetn (resetn),

    .do_arr_reg_start (st_do_arr_reg_start),
    .arr_reg_start_data (st_arr_reg_start_data),

    .do_reg_start_inc (st_do_reg_start_inc),

    .do_mod_reg_start (st_do_mod_reg_start),
    .mod_reg_start_data (st_mod_reg_start_data),

    .reg_start_value (st_reg_start_value)
);

select_reg u_select_reg(
    .clk (clk),
    .resetn (resetn),

    .do_arr_reg_select (sl_do_arr_reg_select),
    .arr_reg_select_data (sl_arr_reg_select_data),

    .start_to_select_enable (sl_start_to_select_enable),
    .reg_start_value (sl_reg_start_value),

    .addr1_to_select_enable (sl_addr1_to_select_enable),
    .addr1_value (sl_addr1_value),

    .addr2_to_select_enable (sl_addr2_to_select_enable),
    .addr2_value (sl_addr2_value),

    .reg_select_value (sl_reg_select_value)
);

assign au_do_clear_a = ac_do_clear_a;
assign au_do_clear_b = ac_do_clear_b;
assign au_do_clear_c = ac_do_clear_c;
assign au_do_not_a = ac_do_not_a;
assign au_do_not_b = ac_do_not_b;
assign au_do_sum = ac_do_sum;
assign au_do_and = ac_do_and;
assign au_do_set_c_30 = ac_do_set_c_30;
assign au_do_left_shift_b = ac_do_left_shift_b;
assign au_do_left_shift_c = ac_do_left_shift_c;
assign au_do_left_shift_c29 = ac_do_left_shift_c29;
assign au_do_right_shift_bc = ac_do_right_shift_bc;
assign au_do_move_c_to_a = ac_do_move_c_to_a || pu_do_move_c_to_a;
assign au_do_move_c_to_b = ac_do_move_c_to_b || pu_do_move_c_to_b;
assign au_do_move_b_to_c = ac_do_move_b_to_c;

assign au_do_arr_c = 0;
assign au_arr_reg_c_value = 0;

assign au_io_input_data = 0;

assign au_do_read_mem = pu_do_mem_to_c;
assign au_mem_read_data = me_read_data[29:0];

assign ac_reg_d_0 = au_reg_d_0;
assign ac_reg_b_0 = au_reg_b_0;
assign ac_reg_c_30 = au_reg_c_30;

assign ac_start = pu_operate_pulse;

assign ac_do_arr_c = 0;
assign ac_arr_reg_c_sign = 0;

assign ac_do_read_mem = pu_do_mem_to_c;
assign ac_mem_read_sign = me_read_data[30];
assign ac_operation = 0;

assign me_write_enable = pu_mem_write_pulse;
assign me_read_enable = pu_mem_read_pulse;

assign me_addr = sl_reg_select_value;
assign me_write_data = au_mem_write_data;

assign op_op_code_valid = pu_do_c_to_operator;
assign op_op_code_value = au_op_code_value;

assign pu_start_pulse = btn_machine_start;

assign pu_mem_reply = me_finish;
assign pu_operate_reply = ac_finish;

assign st_do_arr_reg_start = 0;
assign st_arr_reg_start_data = 0;

assign st_do_reg_start_inc = pu_do_start_inc;

assign st_do_mod_reg_start = 0;
assign st_mod_reg_start_data = 0;

assign sl_do_arr_reg_select = 0;
assign sl_arr_reg_select_data = 0;

assign sl_start_to_select_enable = pu_do_start_to_select;
assign sl_reg_start_value = st_reg_start_value;

assign sl_addr1_to_select_enable = pu_do_addr1_to_select;
assign sl_addr1_value = au_addr1_value;

assign sl_addr2_to_select_enable = pu_do_addr2_to_select;
assign sl_addr2_value = au_addr2_value;
endmodule