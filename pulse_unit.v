module pulse_unit (
    input clk,
    input resetn,
    
    output do_c_to_operator,
    output do_addr1_to_select,
    output do_addr2_to_select,
    output do_start_to_select,
    output do_mem_to_c,
    output do_start_inc,
    output do_move_c_to_a,
    output do_move_c_to_b,

    output mem_read_pulse,
    output mem_write_pulse,
    input  mem_reply,
    
    output operate_pulse,
    input  operate_reply,

    input  start_pulse
);

reg [ 2:0] cur_pulse;
reg [ 2:0] next_pulse;

wire [7:0] do_pulse;
wire [7:0] at_pulse;
wire [7:0] entering_pulse;

wire outer_do_pulse;
reg  outer_do_pulse_delay;

// state machine of pulse

always @(posedge clk) begin
    if (~resetn) begin
        cur_pulse <= 3'o0;
    end else begin
        cur_pulse <= next_pulse;
    end
end

always @ (*) begin
    if (|do_pulse) begin
        next_pulse = cur_pulse + 3'o1;
    end else begin
        next_pulse = cur_pulse;
    end
end

assign at_pulse[0] = cur_pulse == 3'o0;
assign at_pulse[1] = cur_pulse == 3'o1;
assign at_pulse[2] = cur_pulse == 3'o2;
assign at_pulse[3] = cur_pulse == 3'o3;
assign at_pulse[4] = cur_pulse == 3'o4;
assign at_pulse[5] = cur_pulse == 3'o5;
assign at_pulse[6] = cur_pulse == 3'o6;
assign at_pulse[7] = cur_pulse == 3'o7;

assign entering_pulse[1] = do_pulse[0];
assign entering_pulse[2] = do_pulse[1];
assign entering_pulse[3] = do_pulse[2];
assign entering_pulse[4] = do_pulse[3];
assign entering_pulse[5] = do_pulse[4];
assign entering_pulse[6] = do_pulse[5];
assign entering_pulse[7] = do_pulse[6];
assign entering_pulse[0] = do_pulse[7];

assign do_pulse[0] = at_pulse[0] && outer_do_pulse_delay;
assign do_pulse[1] = at_pulse[1];
assign do_pulse[2] = at_pulse[2] && outer_do_pulse_delay;
assign do_pulse[3] = at_pulse[3];
assign do_pulse[4] = at_pulse[4] && outer_do_pulse_delay;
assign do_pulse[5] = at_pulse[5];
assign do_pulse[6] = at_pulse[6] && outer_do_pulse_delay;
assign do_pulse[7] = at_pulse[7];

// outer pulse delay
assign outer_do_pulse = mem_reply || operate_reply || start_pulse;
always @(posedge clk) begin
    if (~resetn) begin
        outer_do_pulse_delay <= 1'b0;
    end else if (outer_do_pulse_delay) begin
        outer_do_pulse_delay <= 1'b0;
    end else begin
        outer_do_pulse_delay <= outer_do_pulse;
    end
end

// output control signals 
// TODO: need to change output according to input from operator (instruction decoder)

assign do_start_inc         = entering_pulse[3];
assign do_addr1_to_select   = entering_pulse[3];
assign do_addr2_to_select   = at_pulse[4] && mem_reply;
assign do_start_to_select   = entering_pulse[1];
assign do_move_c_to_a       = entering_pulse[5];
assign do_move_c_to_b       = entering_pulse[7];
assign do_mem_to_c          = 
    (at_pulse[2] && mem_reply) || 
    (at_pulse[4] && mem_reply) || 
    (at_pulse[6] && mem_reply);
assign do_c_to_operator     = entering_pulse[3];
assign mem_read_pulse       = 
    at_pulse[1] ||
    at_pulse[3] || 
    at_pulse[5];
assign mem_write_pulse      = 1'b0;
assign operate_pulse        = at_pulse[7];

endmodule