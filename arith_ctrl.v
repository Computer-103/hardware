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

    input  overflow_from_au,        // level, from au

    output au_answer_op,            // pulse, to op

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
    output reg_c_sign_to_io,        // level, to io
);

endmodule