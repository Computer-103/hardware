/**
 * ПР
 * пускового регистра
 * 启动寄存器
**/

module start_reg (
    input  clk,
    input  resetn,

    input  do_arr_strt_from_pnl,
    input  [11:0] arr_strt_data_from_pnl,

    input  do_inc_strt_from_pu,

    input  do_sel_to_strt_from_pu,
    input  [11:0] sel_value_from_sel,

    input  [11:0] cmp_value_from_pnl,
    output cmp_match_to_io,

    output [11:0] strt_value_to_sel,
    output [11:0] strt_value_to_pnl
);

reg [11:0] reg_start;

always @(posedge clk) begin
    if (~resetn) begin
        reg_start <= 0;
    end else if (do_arr_strt_from_pnl) begin
        reg_start <= arr_strt_data_from_pnl;
    end else if (do_inc_strt_from_pu) begin
        reg_start <= reg_start + 12'o1;
    end else if (do_sel_to_strt_from_pu) begin
        reg_start <= sel_value_from_sel;
    end
end

assign strt_value_to_sel = reg_start;
assign strt_value_to_pnl = reg_start;

assign cmp_match_to_io = 
    reg_start == cmp_value_from_pnl;

endmodule
