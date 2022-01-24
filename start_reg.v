/**
 * ПР
 * пускового регистра
 * 启动寄存器
**/

module start_reg (
    input  clk,
    input  resetn,

    input  do_arr_reg_start,
    input  [11:0] arr_reg_start_data,

    input  do_reg_start_inc,

    input  do_mod_reg_start,
    input  [11:0] mod_reg_start_data,

    output [11:0] reg_start_value
);

reg [11:0] reg_start;

always @(posedge clk) begin
    if (~resetn) begin
        reg_start <= 0;
    end else if (do_arr_reg_start) begin
        reg_start <= arr_reg_start_data;
    end else if (do_reg_start_inc) begin
        reg_start <= reg_start + 12'o1;
    end else if (do_mod_reg_start) begin
        reg_start <= mod_reg_start_data;
    end
end

assign reg_start_value = reg_start;

endmodule
