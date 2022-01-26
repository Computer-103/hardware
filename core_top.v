module core_top (
    input clk, 
    input resetn,

    output dev_input_rdy,               // handshake
    input  dev_input_val,               // handshake

    output dev_output_rdy,              // handshake
    input  dev_output_ack,              // handshake

    input  [ 4:0] dev_input_data,       // level
    output [ 4:0] dev_output_data,      // level

    input  pnl_start_pulse,             // pulse
    input  pnl_clear_pu,                // pulse
    input  pnl_automatic,               // level
    // TODO

    input  pnl_start_input,             // pulse
    input  pnl_stop_input,              // pulse
    input  pnl_start_output,            // pulse
    input  pnl_stop_output,             // pulse

    input  pnl_input_dec,               // level
    input  pnl_output_dec,              // level

    input  pnl_continuous_input,        // level
    input  pnl_stop_after_output,       // level

    input  pnl_do_arr_c,                // pulse
    input  [30:0] pnl_arr_reg_c_value,  // level

    input  pnl_do_arr_strt,             // pulse
    input  [11:0] pnl_arr_strt_value,   // level

    input  pnl_do_arr_sel,              // pulse
    input  [11:0] pnl_arr_sel_value,    // level

    output [ 5:0] pnl_op_code,          // level
    output [11:0] pnl_strt_value,       // level
    output [11:0] pnl_sel_value,        // level
    output [30:0] pnl_reg_c_value,      // level
    output [ 2:0] pnl_pu_state          // level
);

// arith_unit output signals
wire  carry_out_from_au_to_ac;
wire  reg_b0_from_au_to_ac;
wire  reg_c1_from_au_to_ac;
wire  reg_c30_from_au_to_ac;
wire  [ 5:0]  op_code_from_au_to_op;
wire  [11:0]  addr1_value_from_au_to_sel;
wire  [11:0]  addr2_value_from_au_to_sel;
wire  [ 3:0]  output_data_from_au_to_io;
wire  [29:0]  reg_c_value_from_au_to_pnl;
wire  [29:0]  write_data_from_au_to_mem;

// arith_ctrl output signals
wire  ac_answer_from_ac_to_op;
wire  ac_answer_from_ac_to_io;
wire  do_clear_a_from_ac_to_au;
wire  do_clear_b_from_ac_to_au;
wire  do_clear_c_from_ac_to_au;
wire  do_not_a_from_ac_to_au;
wire  do_not_b_from_ac_to_au;
wire  do_sum_from_ac_to_au;
wire  do_and_from_ac_to_au;
wire  do_set_c_30_from_ac_to_au;
wire  do_left_shift_b_from_ac_to_au;
wire  do_left_shift_c_from_ac_to_au;
wire  do_left_shift_c_from_ac_to_io;
wire  do_left_shift_c29_from_ac_to_au;
wire  do_right_shift_bc_from_ac_to_au;
wire  do_move_c_to_a_from_ac_to_au;
wire  do_move_c_to_b_from_ac_to_au;
wire  do_move_b_to_c_from_ac_to_au;
wire  do_mem_to_c_from_ac_to_au;
wire  reg_a_sign_from_ac_to_op;
wire  reg_b_sign_from_ac_to_op;
// wire  reg_b_sign_from_ac_to_pu;
wire  reg_c_sign_from_ac_to_pnl;
wire  write_sign_from_ac_to_mem;
wire  output_sign_from_ac_to_io;

// operator output signals
wire  order_add_from_op_to_ac;
wire  order_sub_from_op_to_ac;
wire  order_mul_from_op_to_ac;
wire  order_div_from_op_to_ac;
wire  order_and_from_op_to_ac;
wire  order_input_from_op_to_io;
wire  order_write_from_op_to_io;
wire  order_output_from_op_to_io;
wire  start_pulse_from_op_to_io;
wire  ctrl_abs_from_op_to_ac;
wire  [ 5:0]  ctrl_bus_from_op_to_pu;
wire  [ 5:0]  op_code_from_op_to_pnl;

// start_reg output signals
wire  [11:0]  strt_value_from_strt_to_sel;
wire  [11:0]  strt_value_from_strt_to_pnl;

// select_reg output signals
wire  [11:0]  sel_value_from_sel_to_strt;
wire  [11:0]  sel_value_from_sel_to_mem;
wire  [11:0]  sel_value_from_sel_to_pnl;

// pulse_unit output signals
wire  do_code_to_op_from_pu_to_op;
wire  do_inc_strt_from_pu_to_strt;
wire  do_addr1_to_sel_from_pu_to_sel;
wire  do_addr2_to_sel_from_pu_to_sel;
wire  do_strt_to_sel_from_pu_to_sel;
wire  do_sel_to_strt_from_pu_to_strt;
wire  do_mem_to_c_from_pu_to_ac;
wire  do_clear_a_from_pu_to_ac;
wire  do_move_c_to_a_from_pu_to_ac;
wire  do_move_c_to_b_from_pu_to_ac;
wire  do_move_b_to_c_from_pu_to_ac;
wire  do_move_c_to_a_from_pu_to_op;
wire  do_move_b_to_c_from_pu_to_op;
wire  operate_pulse_from_pu_to_op;
wire  mem_read_from_pu_to_mem;
wire  [ 2:0] pu_state_from_pu_to_pnl;

// memory output signals
wire  mem_read_reply_from_mem_to_pu;
wire  mem_write_reply_from_mem_to_op;
wire  mem_write_reply_from_mem_to_io;
wire  mem_reply_from_mem_to_io;
wire  read_sign_from_mem_to_ac;
wire  [29:0]  read_data_from_mem_to_au;

// io_unit output signals
wire  shift_3_bit_from_io_to_ac;
wire  shift_4_bit_from_io_to_ac;
wire  order_io_from_io_to_ac;
wire  do_addr2_to_sel_from_io_to_sel;
wire  mem_write_from_io_to_mem;
wire  start_pulse_from_io_to_pu;
wire  [ 4:0]  input_data_from_io_to_au;
wire  input_rdy_from_io_to_dev;
wire  output_rdy_from_io_to_dev;
wire  [ 4:0]  output_data_from_io_to_dev;

// dev signals
wire  input_val_from_dev_to_io;
wire  output_ack_from_dev_to_io;
wire  [4:0] input_data_from_dev_to_io;

// pnl signals
wire  do_arr_c_from_pnl_to_au;
wire  do_arr_c_from_pnl_to_ac;
wire  arr_reg_c_sign_from_pnl_to_ac;
wire  [29:0] arr_reg_c_value_from_pnl_to_au;

wire  do_arr_strt_from_pnl_to_strt;
wire  [11:0] arr_strt_data_from_pnl_to_strt;

wire  do_arr_sel_from_pnl_to_sel;
wire  [11:0] arr_sel_data_from_pnl_to_sel;

wire  start_pulse_from_pnl_to_io;
wire  clear_pu_from_pnl_to_pu;
wire  automatic_from_pnl_to_io;
wire  start_input_from_pnl_to_io;
wire  stop_input_from_pnl_to_io;
wire  start_output_from_pnl_to_io;
wire  stop_output_from_pnl_to_io;

wire  input_oct_from_pnl_to_io;
wire  input_dec_from_pnl_to_io;
wire  output_oct_from_pnl_to_io;
wire  output_dec_from_pnl_to_io;
wire  continuous_input_from_pnl_to_io;
wire  stop_after_output_from_pnl_to_io;

arith_unit  u_arith_unit (
    .clk                        ( clk                         ),
    .resetn                     ( resetn                      ),
    .do_clear_a_from_ac         ( do_clear_a_from_ac_to_au          ),
    .do_clear_b_from_ac         ( do_clear_b_from_ac_to_au          ),
    .do_clear_c_from_ac         ( do_clear_c_from_ac_to_au          ),
    .do_not_a_from_ac           ( do_not_a_from_ac_to_au            ),
    .do_not_b_from_ac           ( do_not_b_from_ac_to_au            ),
    .do_sum_from_ac             ( do_sum_from_ac_to_au              ),
    .do_and_from_ac             ( do_and_from_ac_to_au              ),
    .do_set_c_30_from_ac        ( do_set_c_30_from_ac_to_au         ),
    .do_left_shift_b_from_ac    ( do_left_shift_b_from_ac_to_au     ),
    .do_left_shift_c_from_ac    ( do_left_shift_c_from_ac_to_au     ),
    .do_left_shift_c29_from_ac  ( do_left_shift_c29_from_ac_to_au   ),
    .do_right_shift_bc_from_ac  ( do_right_shift_bc_from_ac_to_au   ),
    .do_move_c_to_a_from_ac     ( do_move_c_to_a_from_ac_to_au      ),
    .do_move_c_to_b_from_ac     ( do_move_c_to_b_from_ac_to_au      ),
    .do_move_b_to_c_from_ac     ( do_move_b_to_c_from_ac_to_au      ),
    .input_data_from_io         ( input_data_from_io_to_au          ),
    .do_arr_c_from_pnl          ( do_arr_c_from_pnl_to_au           ),
    .arr_reg_c_value_from_pnl   ( arr_reg_c_value_from_pnl_to_au    ),
    .do_mem_to_c_from_ac        ( do_mem_to_c_from_ac_to_au         ),
    .read_data_from_mem         ( read_data_from_mem_to_au          ),

    .carry_out_to_ac            ( carry_out_from_au_to_ac             ),
    .reg_b0_to_ac               ( reg_b0_from_au_to_ac                ),
    .reg_c1_to_ac               ( reg_c1_from_au_to_ac                ),
    .reg_c30_to_ac              ( reg_c30_from_au_to_ac               ),
    .op_code_to_op              ( op_code_from_au_to_op               ),
    .addr1_value_to_sel         ( addr1_value_from_au_to_sel          ),
    .addr2_value_to_sel         ( addr2_value_from_au_to_sel          ),
    .output_data_to_io          ( output_data_from_au_to_io           ),
    .reg_c_value_to_pnl         ( reg_c_value_from_au_to_pnl          ),
    .write_data_to_mem          ( write_data_from_au_to_mem           )
);

arith_ctrl  u_arith_ctrl (
    .clk                      ( clk                       ),
    .resetn                   ( resetn                    ),
    .do_clear_a_from_pu       ( do_clear_a_from_pu_to_ac        ),
    .do_move_b_to_c_from_pu   ( do_move_b_to_c_from_pu_to_ac    ),
    .do_move_c_to_b_from_pu   ( do_move_c_to_b_from_pu_to_ac    ),
    .do_move_c_to_a_from_pu   ( do_move_c_to_a_from_pu_to_ac    ),
    .order_add_from_op        ( order_add_from_op_to_ac         ),
    .order_sub_from_op        ( order_sub_from_op_to_ac         ),
    .order_mul_from_op        ( order_mul_from_op_to_ac         ),
    .order_div_from_op        ( order_div_from_op_to_ac         ),
    .order_and_from_op        ( order_and_from_op_to_ac         ),
    .order_io_from_io         ( order_io_from_io_to_ac          ),
    .ctrl_abs_from_op         ( ctrl_abs_from_op_to_ac          ),
    .shift_3_bit_from_io      ( shift_3_bit_from_io_to_ac       ),
    .shift_4_bit_from_io      ( shift_4_bit_from_io_to_ac       ),
    .read_sign_from_mem       ( read_sign_from_mem_to_ac        ),
    .carry_out_from_au        ( carry_out_from_au_to_ac         ),
    .reg_c1_from_au           ( reg_c1_from_au_to_ac            ),
    .reg_c30_from_au          ( reg_c30_from_au_to_ac           ),
    .reg_b0_from_au           ( reg_b0_from_au_to_ac            ),
    .arr_reg_c_sign_from_pnl  ( arr_reg_c_sign_from_pnl_to_ac   ),
    .do_mem_to_c_from_pu      ( do_mem_to_c_from_pu_to_ac       ),
    .do_arr_c_from_pnl        ( do_arr_c_from_pnl_to_ac         ),

    .ac_answer_to_op          ( ac_answer_from_ac_to_op           ),
    .ac_answer_to_io          ( ac_answer_from_ac_to_io           ),
    .do_clear_a_to_au         ( do_clear_a_from_ac_to_au          ),
    .do_clear_b_to_au         ( do_clear_b_from_ac_to_au          ),
    .do_clear_c_to_au         ( do_clear_c_from_ac_to_au          ),
    .do_not_a_to_au           ( do_not_a_from_ac_to_au            ),
    .do_not_b_to_au           ( do_not_b_from_ac_to_au            ),
    .do_sum_to_au             ( do_sum_from_ac_to_au              ),
    .do_and_to_au             ( do_and_from_ac_to_au              ),
    .do_set_c_30_to_au        ( do_set_c_30_from_ac_to_au         ),
    .do_left_shift_b_to_au    ( do_left_shift_b_from_ac_to_au     ),
    .do_left_shift_c_to_au    ( do_left_shift_c_from_ac_to_au     ),
    .do_left_shift_c_to_io    ( do_left_shift_c_from_ac_to_io     ),
    .do_left_shift_c29_to_au  ( do_left_shift_c29_from_ac_to_au   ),
    .do_right_shift_bc_to_au  ( do_right_shift_bc_from_ac_to_au   ),
    .do_move_c_to_a_to_au     ( do_move_c_to_a_from_ac_to_au      ),
    .do_move_c_to_b_to_au     ( do_move_c_to_b_from_ac_to_au      ),
    .do_move_b_to_c_to_au     ( do_move_b_to_c_from_ac_to_au      ),
    .do_mem_to_c_to_au        ( do_mem_to_c_from_ac_to_au         ),
    
    .reg_a_sign_to_op         ( reg_a_sign_from_ac_to_op          ),
    .reg_b_sign_to_op         ( reg_b_sign_from_ac_to_op          ),
    // .reg_b_sign_to_pu         ( reg_b_sign_from_ac_to_pu          ),
    .reg_c_sign_to_pnl        ( reg_c_sign_from_ac_to_pnl         ),
    .write_sign_to_mem        ( write_sign_from_ac_to_mem         ),
    .output_sign_to_io        ( output_sign_from_ac_to_io         )
);

operator  u_operator (
    .clk                       ( clk                        ),
    .resetn                    ( resetn                     ),
    .do_code_to_op_from_pu     ( do_code_to_op_from_pu_to_op      ),
    .operate_pulse_from_pu     ( operate_pulse_from_pu_to_op      ),
    .do_move_b_to_c_from_pu    ( do_move_b_to_c_from_pu_to_op     ),
    .do_move_c_to_a_from_pu    ( do_move_c_to_a_from_pu_to_op     ),
    .mem_write_reply_from_mem  ( mem_write_reply_from_mem_to_op   ),
    .ac_answer_from_ac         ( ac_answer_from_ac_to_op          ),
    .reg_a_sign_from_ac        ( reg_a_sign_from_ac_to_op         ),
    .reg_b_sign_from_ac        ( reg_b_sign_from_ac_to_op         ),
    .op_code_from_au           ( op_code_from_au_to_op            ),

    .order_add_to_ac           ( order_add_from_op_to_ac            ),
    .order_sub_to_ac           ( order_sub_from_op_to_ac            ),
    .order_mul_to_ac           ( order_mul_from_op_to_ac            ),
    .order_div_to_ac           ( order_div_from_op_to_ac            ),
    .order_and_to_ac           ( order_and_from_op_to_ac            ),
    .order_input_to_io         ( order_input_from_op_to_io          ),
    .order_write_to_io         ( order_write_from_op_to_io          ),
    .order_output_to_io        ( order_output_from_op_to_io         ),
    .start_pulse_to_io         ( start_pulse_from_op_to_io          ),
    .ctrl_abs_to_ac            ( ctrl_abs_from_op_to_ac             ),
    .ctrl_bus_to_pu            ( ctrl_bus_from_op_to_pu             ),
    .op_code_to_pnl      ( op_code_from_op_to_pnl       )
);

start_reg  u_start_reg (
    .clk                     ( clk                      ),
    .resetn                  ( resetn                   ),
    .do_arr_strt_from_pnl    ( do_arr_strt_from_pnl_to_strt     ),
    .arr_strt_data_from_pnl  ( arr_strt_data_from_pnl_to_strt   ),
    .do_inc_strt_from_pu     ( do_inc_strt_from_pu_to_strt      ),
    .do_sel_to_strt_from_pu  ( do_sel_to_strt_from_pu_to_strt   ),
    .sel_value_from_sel      ( sel_value_from_sel_to_strt       ),

    .strt_value_to_sel       ( strt_value_from_strt_to_sel        ),
    .strt_value_to_pnl       ( strt_value_from_strt_to_pnl        )
);

select_reg  u_select_reg (
    .clk                      ( clk                       ),
    .resetn                   ( resetn                    ),
    .do_arr_sel_from_pnl      ( do_arr_sel_from_pnl_to_sel       ),
    .arr_sel_data_from_pnl    ( arr_sel_data_from_pnl_to_sel     ),
    .do_strt_to_sel_from_pu   ( do_strt_to_sel_from_pu_to_sel    ),
    .strt_value_from_strt     ( strt_value_from_strt_to_sel      ),
    .do_addr1_to_sel_from_pu  ( do_addr1_to_sel_from_pu_to_sel   ),
    .addr1_value_from_au      ( addr1_value_from_au_to_sel       ),
    .do_addr2_to_sel_from_pu  ( do_addr2_to_sel_from_pu_to_sel   ),
    .do_addr2_to_sel_from_io  ( do_addr2_to_sel_from_io_to_sel   ),
    .addr2_value_from_au      ( addr2_value_from_au_to_sel       ),

    .sel_value_to_strt        ( sel_value_from_sel_to_strt         ),
    .sel_value_to_mem         ( sel_value_from_sel_to_mem          ),
    .sel_value_to_pnl         ( sel_value_from_sel_to_pnl          )
);

pulse_unit  u_pulse_unit (
    .clk                      ( clk                             ),
    .resetn                   ( resetn                          ),
    .mem_read_reply_from_mem  ( mem_read_reply_from_mem_to_pu   ),
    .start_pulse_from_io      ( start_pulse_from_io_to_pu       ),
    .clear_pu_from_pnl        ( clear_pu_from_pnl_to_pu         ),
    .ctrl_bus_from_op         ( ctrl_bus_from_op_to_pu          ),

    .do_code_to_op_to_op      ( do_code_to_op_from_pu_to_op     ),
    .do_inc_strt_to_strt      ( do_inc_strt_from_pu_to_strt     ),
    .do_addr1_to_sel_to_sel   ( do_addr1_to_sel_from_pu_to_sel  ),
    .do_addr2_to_sel_to_sel   ( do_addr2_to_sel_from_pu_to_sel  ),
    .do_strt_to_sel_to_sel    ( do_strt_to_sel_from_pu_to_sel   ),
    .do_sel_to_strt_to_strt   ( do_sel_to_strt_from_pu_to_strt  ),
    .do_mem_to_c_to_ac        ( do_mem_to_c_from_pu_to_ac       ),
    .do_clear_a_to_ac         ( do_clear_a_from_pu_to_ac        ),
    .do_move_c_to_a_to_ac     ( do_move_c_to_a_from_pu_to_ac    ),
    .do_move_c_to_b_to_ac     ( do_move_c_to_b_from_pu_to_ac    ),
    .do_move_b_to_c_to_ac     ( do_move_b_to_c_from_pu_to_ac    ),
    .do_move_c_to_a_to_op     ( do_move_c_to_a_from_pu_to_op    ),
    .do_move_b_to_c_to_op     ( do_move_b_to_c_from_pu_to_op    ),
    .operate_pulse_to_op      ( operate_pulse_from_pu_to_op     ),
    .mem_read_to_mem          ( mem_read_from_pu_to_mem         ),
    .pu_state_to_pnl          ( pu_state_from_pu_to_pnl         )
);

memory  u_memory (
    .clk                     ( clk                     ),
    .resetn                  ( resetn                  ),
    .mem_write_from_io       ( mem_write_from_io_to_mem       ),
    .mem_read_from_pu        ( mem_read_from_pu_to_mem        ),
    .sel_value_from_sel      ( sel_value_from_sel_to_mem      ),
    .write_sign_from_ac      ( write_sign_from_ac_to_mem      ),
    .write_data_from_au      ( write_data_from_au_to_mem      ),

    .mem_read_reply_to_pu    ( mem_read_reply_from_mem_to_pu    ),
    .mem_write_reply_to_op   ( mem_write_reply_from_mem_to_op   ),
    .mem_write_reply_to_io   ( mem_write_reply_from_mem_to_io   ),
    .mem_reply_to_io         ( mem_reply_from_mem_to_io         ),
    .read_sign_to_ac         ( read_sign_from_mem_to_ac         ),
    .read_data_to_au         ( read_data_from_mem_to_au         )
);

io_unit  u_io_unit (
    .clk                          ( clk                           ),
    .resetn                       ( resetn                        ),
    .order_write_from_op          ( order_write_from_op_to_io           ),
    .order_input_from_op          ( order_input_from_op_to_io           ),
    .order_output_from_op         ( order_output_from_op_to_io          ),
    .start_pulse_from_op          ( start_pulse_from_op_to_io           ),
    .do_left_shift_c_from_ac      ( do_left_shift_c_from_ac_to_io       ),
    .ac_answer_from_ac            ( ac_answer_from_ac_to_io             ),
    .mem_write_reply_from_mem     ( mem_write_reply_from_mem_to_io      ),
    .mem_reply_from_mem           ( mem_reply_from_mem_to_io            ),
    .start_pulse_from_pnl         ( start_pulse_from_pnl_to_io ),
    .automatic_from_pnl           ( automatic_from_pnl_to_io ),
    .start_input_from_pnl         ( start_input_from_pnl_to_io ),
    .stop_input_from_pnl          ( stop_input_from_pnl_to_io ),
    .start_output_from_pnl        ( start_output_from_pnl_to_io ),
    .stop_output_from_pnl         ( stop_output_from_pnl_to_io ),
    .input_oct_from_pnl           ( input_oct_from_pnl_to_io            ),
    .input_dec_from_pnl           ( input_dec_from_pnl_to_io            ),
    .output_oct_from_pnl          ( output_oct_from_pnl_to_io           ),
    .output_dec_from_pnl          ( output_dec_from_pnl_to_io           ),
    .continuous_input_from_pnl    ( continuous_input_from_pnl_to_io     ),
    .stop_after_output_from_pnl   ( stop_after_output_from_pnl_to_io    ),
    .output_sign_from_ac          ( output_sign_from_ac_to_io           ),
    .output_data_from_au          ( output_data_from_au_to_io           ),
    .input_val_from_dev           ( input_val_from_dev_to_io            ),
    .input_data_from_dev          ( input_data_from_dev_to_io           ),
    .output_ack_from_dev          ( output_ack_from_dev_to_io           ),

    .shift_3_bit_to_ac            ( shift_3_bit_from_io_to_ac             ),
    .shift_4_bit_to_ac            ( shift_4_bit_from_io_to_ac             ),
    .order_io_to_ac               ( order_io_from_io_to_ac                ),
    .do_addr2_to_sel_to_sel       ( do_addr2_to_sel_from_io_to_sel        ),
    .mem_write_to_mem             ( mem_write_from_io_to_mem              ),
    .start_pulse_to_pu            ( start_pulse_from_io_to_pu             ),
    .input_data_to_au             ( input_data_from_io_to_au              ),
    .input_rdy_to_dev             ( input_rdy_from_io_to_dev              ),
    .output_rdy_to_dev            ( output_rdy_from_io_to_dev             ),
    .output_data_to_dev           ( output_data_from_io_to_dev            )
);

// dev
assign dev_input_rdy = input_rdy_from_io_to_dev;
assign input_val_from_dev_to_io = dev_input_val;

assign dev_output_rdy = output_rdy_from_io_to_dev;
assign output_ack_from_dev_to_io = dev_output_ack;

assign input_data_from_dev_to_io = dev_input_data;
assign dev_output_data = output_data_from_io_to_dev;

// pnl
assign start_pulse_from_pnl_to_io = pnl_start_pulse;
assign clear_pu_from_pnl_to_pu = pnl_clear_pu;
assign automatic_from_pnl_to_io = pnl_automatic;
assign start_input_from_pnl_to_io = pnl_start_input;
assign stop_input_from_pnl_to_io = pnl_stop_input;
assign start_output_from_pnl_to_io = pnl_start_output;
assign stop_output_from_pnl_to_io = pnl_stop_output;

assign input_oct_from_pnl_to_io  = !pnl_input_dec;
assign input_dec_from_pnl_to_io  =  pnl_input_dec;
assign output_oct_from_pnl_to_io = !pnl_output_dec;
assign output_dec_from_pnl_to_io =  pnl_output_dec;
assign continuous_input_from_pnl_to_io = pnl_continuous_input;
assign stop_after_output_from_pnl_to_io = pnl_stop_after_output;

assign do_arr_c_from_pnl_to_au = pnl_do_arr_c;
assign do_arr_c_from_pnl_to_ac = pnl_do_arr_c;
assign {arr_reg_c_sign_from_pnl_to_ac, arr_reg_c_value_from_pnl_to_au} = pnl_arr_reg_c_value;

assign do_arr_strt_from_pnl_to_strt = pnl_do_arr_strt;
assign arr_sel_data_from_pnl_to_sel = pnl_arr_strt_value;

assign do_arr_sel_from_pnl_to_sel = pnl_do_arr_sel;
assign arr_strt_data_from_pnl_to_strt = pnl_arr_sel_value;

assign pnl_op_code = op_code_from_op_to_pnl;
assign pnl_strt_value = strt_value_from_strt_to_pnl;
assign pnl_sel_value = sel_value_from_sel_to_pnl;
assign pnl_reg_c_value = {reg_c_sign_from_ac_to_pnl, reg_c_value_from_au_to_pnl};
assign pnl_pu_state = pu_state_from_pu_to_pnl;

endmodule
