module arithmetic_unit  (
    input  clk,
    input  resetn,

    input  do_clear_a,
    input  do_clear_b,
    input  do_clear_c,
    input  do_not_a,
    input  do_not_b,
    input  do_sum,
    input  do_and,
    input  do_set_c_30,
    input  do_left_shift_b,
    input  do_left_shift_c,
    input  do_left_shift_c29,
    input  do_right_shift_bc,
    input  do_move_c_to_a,
    input  do_move_c_to_b,
    input  do_move_b_to_c,

    output reg_d_0,
    output reg_b_0,
    output reg_c_30,

    input  do_arr_c,
    input  [29:0] arr_reg_c_value,
    output [29:0] reg_c_value,

    input  io_input_data,
    output [ 3:0] io_output_data,

    output [ 5:0] op_code_value,
    output [11:0] addr1_value,
    output [11:0] addr2_value,
    
    input  do_read_mem,
    input  [29:0] mem_read_data,
    output [29:0] mem_write_data
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
    end else if (do_clear_a) begin
        val_reg_a[1:30] <= 30'b0;
    end else if (do_not_a) begin
        val_reg_a[1:30] <= val_not_a[1:30];
    end else if (do_move_c_to_a) begin
        val_reg_a[1:30] <= val_reg_c[1:30];
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        val_reg_b[0:30] <= 30'b0;
    end else if (do_clear_b) begin
        val_reg_b[0:30] <= 30'b0;
    end else if (do_not_b) begin
        val_reg_b[0:30] <= {1'b0, val_not_b[1:30]};
    end else if (do_move_c_to_b) begin
        val_reg_b[0:30] <= {1'b0, val_reg_c[1:30]};
    end else if (do_left_shift_b) begin
        val_reg_b[0:30] <= {val_reg_b[1:30], 1'b0};
    end else if (do_right_shift_bc) begin
        val_reg_b[0:30] <= {1'b0, val_reg_b[0:29]};
    end else if (do_sum) begin
        val_reg_b[0:30] <= val_sum[0:30];
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        val_reg_c[1:30] <= 30'b0;
    end else if (do_clear_c) begin
        val_reg_c[1:30] <= 30'b0;
    end else if (do_move_b_to_c) begin
        val_reg_c[1:30] <= val_reg_b[1:30];
    end else if (do_left_shift_c) begin
        val_reg_c[1:27] <= val_reg_b[2:28];
        val_reg_c[28] <= do_left_shift_c29 ? val_reg_c[29] : io_input_data;
        val_reg_c[29] <= val_reg_c[30];
        val_reg_c[30] <= io_input_data;
    end else if (do_right_shift_bc) begin
        val_reg_c[1:30] <= {1'b0, val_reg_c[1:29]};
    end else if (do_and) begin
        val_reg_c[1:30] <= val_and[1:30];
    end else if (do_set_c_30) begin
        val_reg_c[1:30] <= {val_reg_c[1:29], 1'b1};
    end else if (do_read_mem) begin
        val_reg_c[1:30] <= mem_read_data[29:0];
    end else if (do_arr_c) begin
        val_reg_c[1:30] <= arr_reg_c_value[29:0];
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        carry_in <= 1'b0;
    end else if (do_not_a || do_not_b) begin
        carry_in <= 1'b1;
    end else if (do_clear_b || do_move_c_to_a) begin
        carry_in <= 1'b0;
    end
end

assign reg_c_value[29:0]    = val_reg_c[ 1:30];
assign mem_write_data[29:0] = val_reg_c[ 1:30];
assign op_code_value[5:0]   = val_reg_c[ 1: 6];
assign addr1_value[11:0]    = val_reg_c[ 7:18];
assign addr2_value[11:0]    = val_reg_c[19:30];
assign io_output_data[3:0]  = val_reg_c[ 1: 4];

assign reg_d_0  = val_sum[0];
assign reg_b_0  = val_reg_b[0];
assign reg_c_30 = val_reg_c[30];

endmodule