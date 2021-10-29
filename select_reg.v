module select_reg (
    input  clk,
    input  resetn,

    input  do_arr_reg_select,
    input  [11:0] arr_reg_select_data,

    input  start_to_select_enable,
    input  [11:0] reg_start_value,

    input  addr1_to_select_enable,
    input  [11:0] addr1_value,

    input  addr2_to_select_enable,
    input  [11:0] addr2_value,

    output [11:0] reg_select_value
);

reg [11:0] reg_select;

always @(posedge clk) begin
    if (~resetn) begin
        reg_select <= 12'o0000;
    end else if (do_arr_reg_select) begin
        reg_select <= arr_reg_select_data;
    end else if (start_to_select_enable) begin
        reg_select <= reg_start_value;
    end else if (addr1_to_select_enable) begin
        reg_select <= addr1_value;
    end else if (addr2_to_select_enable) begin
        reg_select <= addr2_value;
    end
end

assign reg_select_value = reg_select;


endmodule