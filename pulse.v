module pulse (
    input clk,
    input resetn,

    input  do_start,

    output write_enable,
    output read_enable,
    output start_operation,
    output c_to_operator_enable,
    output addr1_to_select_enable,
    output addr2_to_select_enable,
    output start_to_select_enable,
    output mem_to_c_enable,
    output do_start_inc,
    output do_move_c_to_a,
    output do_move_c_to_b,

    input  mem_finish,
    input  operation_finish,

    input  read_addr2,
    input  write_addr2
);

wire pulse0_finish;
wire pulse1_finish;
wire pulse2_finish;
wire pulse3_finish;
wire pulse4_finish;
wire pulse5_finish;
wire pulse6_finish;
wire pulse7_finish;

reg [2:0] cur_pulse;
reg [2:0] next_pulse;

always @(posedge clk) begin
    if (~resetn) begin
        cur_pulse <= 3'o0;
    end else begin
        cur_pulse <= next_pulse;
    end
end

always @(*) begin
    if (cur_pulse == 3'o0) begin
        if (pulse0_finish) begin
            next_pulse = 3'o1;
        end else begin
            next_pulse = 3'o0;
        end
    end else if (cur_pulse == 3'o1) begin
        if (pulse1_finish) begin
            next_pulse = 3'o2;
        end else begin
            next_pulse = 3'o1;
        end
    end else if (cur_pulse == 3'o2) begin
        if (pulse2_finish) begin
            next_pulse = 3'o3;
        end else begin
            next_pulse = 3'o2;
        end
    end else if (cur_pulse == 3'o3) begin
        if (pulse3_finish) begin
            next_pulse = 3'o4;
        end else begin
            next_pulse = 3'o3;
        end
    end else if (cur_pulse == 3'o4) begin
        if (pulse4_finish) begin
            next_pulse = 3'o5;
        end else begin
            next_pulse = 3'o4;
        end
    end else if (cur_pulse == 3'o5) begin
        if (pulse5_finish) begin
            next_pulse = 3'o6;
        end else begin
            next_pulse = 3'o5;
        end
    end else if (cur_pulse == 3'o6) begin
        if (pulse6_finish) begin
            next_pulse = 3'o7;
        end else begin
            next_pulse = 3'o6;
        end
    end else if (cur_pulse == 3'o7) begin
        if (pulse7_finish) begin
            next_pulse = 3'o0;
        end else begin
            next_pulse = 3'o7;
        end
    end else begin
        next_pulse = 3'o0;
    end
end

assign pulse0_finish = do_start || (write_addr2 && mem_finish);
assign pulse1_finish = mem_finish;
assign pulse2_finish = 1;
assign pulse3_finish = mem_finish;
assign pulse4_finish = 1;
assign pulse5_finish = !read_addr2 || (read_addr2 && mem_finish);
assign pulse6_finish = 1;
assign pulse7_finish = operation_finish;

assign write_enable = 
    (cur_pulse == 1'o0) && write_addr2;
assign read_enable = 
    (cur_pulse == 1'o1) ||
    (cur_pulse == 1'o3) ||
    (cur_pulse == 1'o5 && read_addr2);

assign start_operation =
    (cur_pulse == 1'o7);

assign c_to_operator_enable =
    (next_pulse == 1'o3);
assign addr1_to_select_enable = 
    (next_pulse == 1'o2);
assign addr2_to_select_enable = 
    (next_pulse == 1'o4);
assign start_to_select_enable = 
    (next_pulse == 1'o1);
assign mem_to_c_enable = 
    (next_pulse == 1'o2) ||
    (next_pulse == 1'o4) ||
    (next_pulse == 1'o6 && read_addr2);
assign do_start_inc = 
    (next_pulse == 1'o3);
assign do_move_c_to_a = 
    (next_pulse == 1'o5);
assign do_move_c_to_b = 
    (next_pulse == 1'o7 && read_addr2);

endmodule