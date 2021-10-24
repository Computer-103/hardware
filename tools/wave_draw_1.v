module wave_draw_1 ();

reg clk;
initial begin
    clk = 1'b0;
end
always #5 clk=~clk;

reg do_pulse;
reg [ 2:0] pulse;
reg do_start_inc;
reg [11:0] reg_start;
reg do_addr1_to_select;
reg do_addr2_to_select;
reg do_start_to_select;
reg [11:0] reg_select;
reg do_move_c_to_a;
reg [30:0] reg_a;
reg do_move_c_to_b;
reg [30:0] reg_b;
reg do_mem_to_c;
reg [30:0] reg_c;
reg do_c_to_operator;
reg [ 5:0] operator;

reg mem_read_pulse;
reg mem_write_pulse;
reg mem_reply;

reg operate_pulse;
reg operate_reply;

initial begin
    do_pulse <= 1'b0;
    pulse <= 3'o0;
    do_start_inc <= 1'b0;
    reg_start <= 12'o0001;
    do_addr1_to_select <= 1'b0;
    do_addr2_to_select <= 1'b0;
    do_start_to_select <= 1'b0;
    reg_select <= 12'o0000;
    do_move_c_to_a <= 1'b0;
    reg_a <= 31'o0_00_0000_0000;
    do_move_c_to_b <= 1'b0;
    reg_b <= 31'o0_00_0000_0000;
    do_mem_to_c <= 1'b0;
    reg_c <= 31'o0_00_0000_0000;
    do_c_to_operator <= 1'b0;
    operator <= 6'o77;
    mem_read_pulse <= 1'b0;
    mem_write_pulse <= 1'b0;
    mem_reply <= 1'b0;
    operate_pulse <= 1'b0;
    operate_reply <= 1'b0;

    #5;

    do_pulse <= 1'b1;
    do_start_to_select <= 1'b1;

    #10;

    pulse <= 3'o1;
    do_pulse <= 1'b1;
    reg_select <= reg_start;
    do_start_to_select <= 1'b0;
    mem_read_pulse <= 1'b1;

    #10;

    pulse <= 3'o2;
    do_pulse <= 1'b0;
    mem_read_pulse <= 1'b0;

    #20;

    mem_reply <= 1'b1;
    do_mem_to_c <= 1'b1;

    #10;

    mem_reply <= 1'b0;
    reg_c <= 31'o0_00_1111_2222;
    do_mem_to_c <= 1'b0;
    do_pulse <= 1'b1;
    do_addr1_to_select <= 1'b1;
    do_start_inc <= 1'b1;
    do_c_to_operator <= 1'b1;

    #10;

    pulse <= 3'o3;
    do_pulse <= 1'b1;
    reg_select <= reg_c[23:12];
    do_addr1_to_select <= 1'b0;
    reg_start <= reg_start + 1;
    do_start_inc <= 1'b0;
    operator <= reg_c[29:24];
    do_c_to_operator <= 1'b0;
    mem_read_pulse <= 1'b1;

    #10;

    pulse <= 3'o4;
    do_pulse <= 1'b0;
    mem_read_pulse <= 1'b0;

    #20;

    mem_reply <= 1'b1;
    do_addr2_to_select <= 1'b1;
    do_mem_to_c <= 1'b1;

    #10;

    mem_reply <= 1'b0;
    reg_select <= reg_c[11:0];
    do_addr2_to_select <= 1'b0;
    reg_c <= 31'o0_33_3333_3333;
    do_mem_to_c <= 1'b0;
    do_pulse <= 1'b1;
    do_move_c_to_a <= 1'b1;

    #10;

    pulse <= 3'o5;
    do_pulse <= 1'b1;
    reg_a <= reg_c;
    do_move_c_to_a <= 1'b0;
    mem_read_pulse <= 1'b1;

    #10;

    pulse <= 3'o6;
    do_pulse <= 1'b0;
    mem_read_pulse <= 1'b0;

    #20;

    mem_reply <= 1'b1;
    do_mem_to_c <= 1'b1;

    #10;

    mem_reply <= 1'b0;
    reg_c <= 31'o0_44_4444_4444;
    do_mem_to_c <= 1'b0;
    do_pulse <= 1'b1;
    do_move_c_to_b <= 1'b1;

    #10;
    pulse <= 3'o7;
    do_pulse <= 1'b1;
    reg_b <= reg_c;
    do_move_c_to_b <= 1'b0;
    operate_pulse <= 1'b1;

    #10;
    pulse <= 3'o0;
    do_pulse <= 1'b0;
    operate_pulse <= 1'b0;

    #20;

    operate_reply <= 1'b1;

    #10;

    operate_reply <= 1'b0;
    do_pulse <= 1'b1;
    do_start_to_select <= 1'b1;

    #10;

    pulse <= 3'o1;
    do_pulse <= 1'b1;
    reg_select <= reg_start;
    do_start_to_select <= 1'b0;
    mem_read_pulse <= 1'b1;

    #10;
    
    $finish;


end

endmodule