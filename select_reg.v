/**
 * СР
 * селекционного регистра
 * 选择寄存器
**/

module select_reg (
    input  clk,
    input  resetn,

    input  do_arr_sel_from_pnl,
    input  [11:0] arr_sel_data_from_pnl,

    input  do_strt_to_sel_from_pu,
    input  [11:0] strt_value_from_strt,

    input  do_addr1_to_sel_from_pu,
    input  [11:0] addr1_value_from_au,

    input  do_addr2_to_sel_from_pu,
    input  do_addr2_to_sel_from_io,
    input  [11:0] addr2_value_from_au,

    output [11:0] sel_value_to_strt,
    output [11:0] sel_value_to_mem,
    output [11:0] sel_value_to_pnl
);

reg [11:0] reg_select;

always @(posedge clk) begin
    if (~resetn) begin
        reg_select <= 12'o0000;
    end else if (do_arr_sel_from_pnl) begin
        reg_select <= arr_sel_data_from_pnl;
    end else if (do_strt_to_sel_from_pu) begin
        reg_select <= strt_value_from_strt;
    end else if (do_addr1_to_sel_from_pu) begin
        reg_select <= addr1_value_from_au;
    end else if (do_addr2_to_sel_from_pu || do_addr2_to_sel_from_io) begin
        reg_select <= addr2_value_from_au;
    end
end

assign sel_value_to_strt = reg_select;
assign sel_value_to_mem = reg_select;
assign sel_value_to_pnl = reg_select;

endmodule
