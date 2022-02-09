module hardware_top (
    input clk, 
    input resetn,

    output dev_input_rdy,               // handshake
    input  dev_input_val,               // handshake

    output dev_output_rdy,              // handshake
    input  dev_output_ack,              // handshake

    input  [ 4:0] dev_input_data,       // level
    output [ 4:0] dev_output_data,      // level

    input  btn_start_pulse,             // btn
    input  btn_clear_pu,                // btn

    input  btn_mem_read,                // btn
    input  btn_mem_write,               // btn

    input  btn_start_input,             // btn
    input  btn_stop_input,              // btn
    input  btn_start_output,            // btn
    input  btn_stop_output,             // btn

    input  sw_input_dec,                // switch
    input  sw_output_dec,               // switch

    input  sw_continuous_input,         // switch
    input  sw_stop_after_output,        // switch
    input  sw_automatic,                // switch
    input  sw_stop_at_cmp,              // switch
    input  sw_cmp_with_strt,            // switch

    input  sw_allow_arr,                // switch


    input  btn_do_arr_c,                // btn
    input  btn_do_arr_strt,             // btn
    input  btn_do_arr_sel,              // btn

    output [ 2:0] pnl_pu_state,         // level

    output serial_out_rclk,
    output serial_out_srclk,
    output serial_out_ser_0,
    output serial_out_ser_1,
    output serial_out_ser_2,
    output serial_out_ser_3,

    output serial_in_rclk,
    output serial_in_shldn,
    input  serial_in_ser_0,
    input  serial_in_ser_1,
    input  serial_in_ser_2,
    input  serial_in_ser_3,
    input  serial_in_ser_4,

    output pnl_input_active,            // level
    output pnl_output_active            // level
    
);

// pnl pulse
wire pnl_start_pulse;
wire pnl_clear_pu;
wire pnl_mem_read;
wire pnl_mem_write;
wire pnl_start_input;
wire pnl_stop_input; 
wire pnl_start_output;
wire pnl_stop_output;
wire pnl_do_arr_c;
wire pnl_do_arr_strt;
wire pnl_do_arr_sel;

// pnl level
wire pnl_input_dec;
wire pnl_output_dec;
wire pnl_continuous_input;
wire pnl_stop_after_output;
wire pnl_automatic;
wire pnl_stop_at_cmp;
wire pnl_cmp_with_strt;
wire pnl_allow_arr;

// pnl serial
wire [30:0] pnl_arr_reg_c_value;
wire [11:0] pnl_arr_strt_value;
wire [11:0] pnl_arr_sel_value;
wire [11:0] pnl_arr_cmp_value;

wire [30:0] ser_arr_reg_c_value;
wire [11:0] ser_arr_strt_value;
wire [11:0] ser_arr_sel_value;
wire [11:0] ser_arr_cmp_value;

wire [15:0] serial_in_0;
wire [15:0] serial_in_1;
wire [15:0] serial_in_2;
wire [15:0] serial_in_3;
wire [15:0] serial_in_4;

wire [30:0] pnl_reg_c_value;
wire [ 5:0] pnl_op_code;
wire [11:0] pnl_strt_value;
wire [11:0] pnl_sel_value;

wire [31:0] serial_out_0;
wire [31:0] serial_out_1;

core_top  u_core_top (
    .clk                     ( clk                      ),
    .resetn                  ( resetn                   ),
    .dev_input_val           ( dev_input_val            ),
    .dev_output_ack          ( dev_output_ack           ),
    .dev_input_data          ( dev_input_data           ),
    .pnl_start_pulse         ( pnl_start_pulse          ),
    .pnl_clear_pu            ( pnl_clear_pu             ),
    .pnl_automatic           ( pnl_automatic            ),
    .pnl_mem_read            ( pnl_mem_read             ),
    .pnl_mem_write           ( pnl_mem_write            ),
    .pnl_start_input         ( pnl_start_input          ),
    .pnl_stop_input          ( pnl_stop_input           ),
    .pnl_start_output        ( pnl_start_output         ),
    .pnl_stop_output         ( pnl_stop_output          ),
    .pnl_input_dec           ( pnl_input_dec            ),
    .pnl_output_dec          ( pnl_output_dec           ),
    .pnl_continuous_input    ( pnl_continuous_input     ),
    .pnl_stop_after_output   ( pnl_stop_after_output    ),
    .pnl_stop_at_cmp         ( pnl_stop_at_cmp          ),
    .pnl_cmp_with_strt       ( pnl_cmp_with_strt        ),
    .pnl_do_arr_c            ( pnl_do_arr_c             ),
    .pnl_arr_reg_c_value     ( pnl_arr_reg_c_value      ),
    .pnl_do_arr_strt         ( pnl_do_arr_strt          ),
    .pnl_arr_strt_value      ( pnl_arr_strt_value       ),
    .pnl_do_arr_sel          ( pnl_do_arr_sel           ),
    .pnl_arr_sel_value       ( pnl_arr_sel_value        ),
    .pnl_arr_cmp_value       ( pnl_arr_cmp_value        ),

    .dev_input_rdy           ( dev_input_rdy            ),
    .dev_output_rdy          ( dev_output_rdy           ),
    .dev_output_data         ( dev_output_data          ),
    .pnl_input_active        ( pnl_input_active         ),
    .pnl_output_active       ( pnl_output_active        ),
    .pnl_op_code             ( pnl_op_code              ),
    .pnl_strt_value          ( pnl_strt_value           ),
    .pnl_sel_value           ( pnl_sel_value            ),
    .pnl_reg_c_value         ( pnl_reg_c_value          ),
    .pnl_pu_state            ( pnl_pu_state             )
);

button_pulse  start_pulse_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_start_pulse                   ),
    .pulse  ( pnl_start_pulse                   )
);
button_pulse  clear_pu_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_clear_pu                      ),
    .pulse  ( pnl_clear_pu                      )
);
button_pulse  mem_read_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_mem_read                      ),
    .pulse  ( pnl_mem_read                      )
);
button_pulse  mem_write_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_mem_write                     ),
    .pulse  ( pnl_mem_write                     )
);
button_pulse  start_input_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_start_input                   ),
    .pulse  ( pnl_start_input                   )
);
button_pulse  stop_input_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_stop_input                    ),
    .pulse  ( pnl_stop_input                    )
);
button_pulse  start_output_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_start_output                  ),
    .pulse  ( pnl_start_output                  )
);
button_pulse  stop_output_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_stop_output                   ),
    .pulse  ( pnl_stop_output                   )
);
button_pulse  do_arr_c_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_do_arr_c                      ),
    .pulse  ( pnl_do_arr_c                      )
);
button_pulse  do_arr_strt_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_do_arr_strt                   ),
    .pulse  ( pnl_do_arr_strt                   )
);
button_pulse  do_arr_sel_button_pulse (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .btn    ( btn_do_arr_sel                    ),
    .pulse  ( pnl_do_arr_sel                    )
);

switch_level  input_dec_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_input_dec                      ),
    .level  ( pnl_input_dec                     )
);
switch_level  output_dec_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_output_dec                     ),
    .level  ( pnl_output_dec                    )
);
switch_level  continuous_input_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_continuous_input               ),
    .level  ( pnl_continuous_input              )
);
switch_level  stop_after_output_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_stop_after_output              ),
    .level  ( pnl_stop_after_output             )
);
switch_level  automatic_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_automatic                      ),
    .level  ( pnl_automatic                     )
);
switch_level  stop_at_cmp_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_stop_at_cmp                    ),
    .level  ( pnl_stop_at_cmp                   )
);
switch_level  cmp_with_strt_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_cmp_with_strt                  ),
    .level  ( pnl_cmp_with_strt                 )
);
switch_level  allow_arr_switch_level (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .sw     ( sw_allow_arr                      ),
    .level  ( pnl_allow_arr                     )
);

assign serial_out_0 = 
    { 1'b0, pnl_reg_c_value[30:0] };
assign serial_out_1 = 
    { 2'b0, pnl_op_code[5:0], pnl_strt_value[11:0], pnl_sel_value[11:0] };

driver_74lv595 u_driver_74lv595 (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .data_0 ( serial_out_0[15:0]),  .data_1 ( serial_out_0[31:16]),
    .data_2 ( serial_out_1[15:0]),  .data_3 ( serial_out_1[31:16]),
    .RCLK   ( serial_out_rclk   ),  .SRCLK  ( serial_out_srclk  ),
    .SER_0  ( serial_out_ser_0  ),  .SER_1  ( serial_out_ser_1  ),
    .SER_2  ( serial_out_ser_2  ),  .SER_3  ( serial_out_ser_3  )
);

driver_74lv165 u_driver_74lv165 (
    .clk    ( clk       ),  .resetn ( resetn    ),
    .data_0 ( serial_in_0       ),  .data_1 ( serial_in_1       ),
    .data_2 ( serial_in_2       ),  .data_3 ( serial_in_3       ),
    .data_4 ( serial_in_4       ),
    .RCLK   ( serial_in_rclk    ),  .SH_LDn ( serial_in_shldn   ),
    .QH_0   ( serial_in_ser_0   ),  .QH_1   ( serial_in_ser_1   ),
    .QH_2   ( serial_in_ser_2   ),  .QH_3   ( serial_in_ser_3   ),
    .QH_4   ( serial_in_ser_4   )
);

assign ser_arr_reg_c_value =
    {serial_in_1[14:0], serial_in_0};
assign {ser_arr_strt_value, ser_arr_sel_value} =
    {serial_in_3[7:0], serial_in_2};
assign ser_arr_cmp_value =
    {serial_in_4[11:0]};

assign pnl_arr_reg_c_value =
    {31{pnl_allow_arr}} & ser_arr_reg_c_value;
assign pnl_arr_strt_value =
    {12{pnl_allow_arr}} & ser_arr_strt_value;
assign pnl_arr_sel_value =
    {12{pnl_allow_arr}} & ser_arr_sel_value;
assign pnl_arr_cmp_value =
    {12{pnl_allow_arr}} & ser_arr_cmp_value;

endmodule
