/**
 * АУ
 * арифметический узел
 * 运算器
**/

module arith_unit  (
    input  clk,
    input  resetn,

    input  do_clear_a_from_ac,
    input  do_clear_b_from_ac,
    input  do_clear_c_from_ac,
    input  do_not_a_from_ac,
    input  do_not_b_from_ac,
    input  do_sum_from_ac,
    input  do_and_from_ac,
    input  do_set_c_30_from_ac,
    input  do_left_shift_b_from_ac,
    input  do_left_shift_c_from_ac,
    input  do_left_shift_c29_from_ac,
    input  do_right_shift_bc_from_ac,
    input  do_move_c_to_a_from_ac,
    input  do_move_c_to_b_from_ac,
    input  do_move_b_to_c_from_ac,

    output carry_out_to_ac,
    output reg_b0_to_ac,
    output reg_c1_to_ac,
    output reg_c30_to_ac,

    output [ 5:0] op_code_to_op,
    output [11:0] addr1_value_to_sel,
    output [11:0] addr2_value_to_sel,

    input  [ 4:0] input_data_from_io,
    output [ 3:0] output_data_to_io,

    input  do_arr_c,
    input  [29:0] arr_reg_c_value,
    output [29:0] reg_c_value,
    
    input  do_read_mem,
    input  [29:0] read_data_from_mem,
    output [29:0] write_data_to_mem
);

reg  [1:30] val_reg_a;
reg  [0:30] val_reg_b;
reg  [1:30] val_reg_c;

reg  carry_in;
wire [0:30] val_sum;
wire [1:30] val_not_a;
wire [1:30] val_not_b;
wire [1:30] val_and;

assign val_sum[0:30] = {1'b0, val_reg_a[1:30]} + val_reg_b[0:30] + {30'b0, carry_in};
assign val_not_a[1:30] = ~val_reg_a[1:30];
assign val_not_b[1:30] = ~val_reg_b[1:30];
assign val_and[1:30] = val_reg_a[1:30] & val_reg_c[1:30];

always @(posedge clk) begin
    if (~resetn) begin
        val_reg_a[1:30] <= 30'b0;
    end else if (do_clear_a_from_ac) begin
        val_reg_a[1:30] <= 30'b0;
    end else if (do_not_a_from_ac) begin
        val_reg_a[1:30] <= val_not_a[1:30];
    end else if (do_move_c_to_a_from_ac) begin
        val_reg_a[1:30] <= val_reg_c[1:30];
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        val_reg_b[0:30] <= 31'b0;
    end else if (do_clear_b_from_ac) begin
        val_reg_b[0:30] <= 31'b0;
    end else if (do_not_b_from_ac) begin
        val_reg_b[0:30] <= {1'b0, val_not_b[1:30]};
    end else if (do_move_c_to_b_from_ac) begin
        val_reg_b[0:30] <= {1'b0, val_reg_c[1:30]};
    end else if (do_left_shift_b_from_ac) begin
        val_reg_b[0:30] <= {val_reg_b[1:30], 1'b0};
    end else if (do_right_shift_bc_from_ac) begin
        val_reg_b[0:30] <= {1'b0, val_reg_b[0:29]};
    end else if (do_sum_from_ac) begin
        val_reg_b[0:30] <= val_sum[0:30];
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        val_reg_c[1:30] <= 30'b0;
    end else if (do_clear_c_from_ac) begin
        val_reg_c[1:30] <= 30'b0;
    end else if (do_move_b_to_c_from_ac) begin
        val_reg_c[1:30] <= val_reg_b[1:30];
    end else if (do_left_shift_c_from_ac) begin
        val_reg_c[1:27] <= val_reg_b[2:28];
        val_reg_c[28] <= do_left_shift_c29_from_ac ? val_reg_c[29] : input_data_from_io[3];
        val_reg_c[29] <= val_reg_c[30];
        val_reg_c[30] <= input_data_from_io[2];
    end else if (do_right_shift_bc_from_ac) begin
        val_reg_c[1:30] <= {1'b0, val_reg_c[1:29]};
    end else if (do_and_from_ac) begin
        val_reg_c[1:30] <= val_and[1:30];
    end else if (do_set_c_30_from_ac) begin
        val_reg_c[1:30] <= {val_reg_c[1:29], 1'b1};
    end else if (do_read_mem) begin
        val_reg_c[1:30] <= read_data_from_mem[29:0];
    end else if (do_arr_c) begin
        val_reg_c[1:30] <= arr_reg_c_value[29:0];
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        carry_in <= 1'b0;
    end else if (do_not_a_from_ac || do_not_b_from_ac) begin
        carry_in <= 1'b1;
    end else if (do_clear_a_from_ac || do_clear_b_from_ac || do_move_c_to_a_from_ac || do_move_c_to_b_from_ac) begin
        carry_in <= 1'b0;
    end
end

assign reg_c_value[29:0]    = val_reg_c[ 1:30];
assign write_data_to_mem[29:0] = val_reg_c[ 1:30];
assign op_code_to_op[5:0]   = val_reg_c[ 1: 6];
assign addr1_value_to_sel[11:0]    = val_reg_c[ 7:18];
assign addr2_value_to_sel[11:0]    = val_reg_c[19:30];
assign output_data_to_io[3:0]  = val_reg_c[ 1: 4];

assign carry_out_to_ac  = val_sum[0];
assign reg_b0_to_ac  = val_reg_b[0];
assign reg_c1_to_ac  = val_reg_c[1];
assign reg_c30_to_ac = val_reg_c[30];

endmodule