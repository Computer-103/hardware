module test_memory ();

reg clk;
reg resetn;

initial begin
    clk = 1'b0;
    resetn = 1'b0;
    #2000;
    resetn = 1'b1;
end
always #5 clk=~clk;

reg t_write_enable;
reg t_read_enable;
wire t_finish;
wire [11:0] t_addr;
wire [30:0] t_write_data;
wire [30:0] t_read_data;

memory t_memory (
    .clk            (clk),
    .resetn         (resetn),
    .write_enable   (t_write_enable),
    .read_enable    (t_read_enable),
    .finish         (t_finish),
    .addr           (t_addr),
    .write_data     (t_write_data),
    .read_data      (t_read_data)
);

reg testing;
always @(posedge clk) begin
    if (!resetn) begin
        testing <= 0;
    end else if (!t_write_enable && !t_read_enable && !t_finish) begin
        testing <= 1;
    end else if (t_finish) begin
        testing <= 0;
    end
end

reg [11:0] ref_addr;
reg [30:0] ref_data;
reg ref_write_enable;
reg ref_read_enable;

initial begin
    ref_addr = 0;
    ref_data = 0;
    ref_write_enable = 0;
    ref_read_enable = 0;
end

integer trace_ref;
initial begin
    trace_ref = $fopen("C:\\Users\\ceba_\\Documents\\working\\Project103\\core\\testbench\\mem_ref.txt", "r");
end

always @(posedge testing) begin
    #1;
    if (!($feof(trace_ref))) begin
        $fscanf(trace_ref, "%o %o %o %o", ref_addr, ref_data, ref_write_enable, ref_read_enable);
        if (ref_write_enable) begin
            $display("         writing: %04o, %011o", ref_addr, ref_data);
        end else if (ref_read_enable) begin
            $display("         reding:  %04o, %011o", ref_addr, ref_data);            
        end
    end else begin
        $display("==============================================================");
        $display("Test end!");
        $display("----PASS!!!");
        $display("==============================================================");
        $finish;
    end
end

always @(negedge testing) begin
    #1;
    if (ref_read_enable && ref_data !== t_read_data) begin
        $display("--------------------------------------------------------------");
        $display("ERROR!!! reding %04o expected %011o but got %011o", ref_addr, ref_data, t_read_data);
        $display("--------------------------------------------------------------");
        $finish;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        t_write_enable <= 0;
    end else if (t_finish) begin
        t_write_enable <= 0;
    end else if (testing && ref_write_enable) begin
        t_write_enable <= 1;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        t_read_enable <= 0;
    end else if (t_finish) begin
        t_read_enable <= 0;
    end else if (testing && ref_read_enable) begin
        t_read_enable <= 1;
    end
end

assign t_addr = ref_addr;
assign t_write_data = ref_data;

endmodule