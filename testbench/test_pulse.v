module test_pulse();

reg clk;
reg resetn;

initial begin
    clk = 1'b0;
    resetn = 1'b0;
    #20;
    resetn = 1'b1;
end
always #5 clk=~clk;

wire mem_read_pulse;
wire mem_write_pulse;
wire operate_pulse;

reg mem_reply;
reg operate_reply;
reg start_pulse;

pulse t_pulse(
    .clk (clk),
    .resetn (resetn),

    .mem_read_pulse (mem_read_pulse),
    .mem_write_pulse (mem_write_pulse),
    .mem_reply (mem_reply),

    .operate_pulse (operate_pulse),
    .operate_reply (operate_reply),

    .start_pulse (start_pulse)
);

initial begin
    mem_reply <= 1'b0;
    operate_reply <= 1'b0;
    start_pulse <= 1'b0;

    #55;
    start_pulse <= 1'b1;
    #10;
    start_pulse <= 1'b0;
end

always @(posedge clk) begin
    if (mem_reply) begin
        mem_reply <= 1'b0;
    end else if (mem_read_pulse || mem_write_pulse) begin
        #20 mem_reply <= 1'b1;
    end
end

always @(posedge clk) begin
    if (operate_reply) begin
        operate_reply <= 1'b0;
    end else if (operate_pulse) begin
        #20 operate_reply <= 1'b1;
    end
end

endmodule