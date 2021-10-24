module wave_draw_0 ();

reg clk;
initial begin
    clk = 1'b0;
end
always #5 clk=~clk;

reg [ 2:0] pulse;
reg [11:0] reg_start;
reg [11:0] reg_select;
reg [30:0] reg_a;
reg [30:0] reg_b;
reg [30:0] reg_c;
reg [ 5:0] operator;

reg mem_read_pulse;
reg mem_write_pulse;
reg mem_reply;

reg operate_pulse;
reg operate_reply;

initial begin
    pulse <= 3'o0;
    reg_start <= 12'o0001;
    reg_select <= 12'o0000;
    reg_a <= 31'o0_00_0000_0000;
    reg_b <= 31'o0_00_0000_0000;
    reg_c <= 31'o0_00_0000_0000;
    operator <= 6'o77;
    mem_read_pulse <= 1'b0;
    mem_write_pulse <= 1'b0;
    mem_reply <= 1'b0;
    operate_pulse <= 1'b0;
    operate_reply <= 1'b0;

    #5;

    pulse <= 3'o1;
    reg_select <= reg_start;
    mem_read_pulse <= 1'b1;

    #20;

    mem_reply <= 1'b1;

    #10;

    pulse <= 3'o2;
    mem_read_pulse <= 1'b0;
    mem_reply <= 1'b0;
    reg_c <= 31'o0_00_1111_2222;

    #30;

    pulse <= 3'o3;
    operator <= reg_c[29:24];
    reg_select <= reg_c[23:12];
    reg_start <= reg_start + 1;
    mem_read_pulse <= 1'b1;

    #20;

    mem_reply <= 1'b1;

    #10;

    pulse <= 3'o4;
    mem_read_pulse <= 1'b0;
    mem_reply <= 1'b0;
    reg_select <= reg_c[11:0];
    reg_c <= 31'o0_33_3333_3333;

    #30;

    pulse <= 3'o5;
    reg_a <= reg_c;
    mem_read_pulse <= 1'b1;

    #20;

    mem_reply <= 1'b1;

    #10;

    pulse <= 3'o6;
    mem_read_pulse <= 1'b0;
    mem_reply <= 1'b0;
    reg_c <= 31'o0_44_4444_4444;

    #30;

    pulse <= 3'o7;
    reg_b <= reg_c;
    operate_pulse <= 1'b1;

    #20;

    operate_reply <= 1'b1;

    #10;

    pulse <= 3'o0;
    operate_pulse <= 1'b0;
    operate_reply <= 1'b0;
    mem_write_pulse <= 1'b1;

    #20;

    mem_reply <= 1'b1;

    #10;

    pulse <= 3'o1;
    mem_write_pulse <= 1'b0;
    mem_reply <= 1'b0;


end

endmodule