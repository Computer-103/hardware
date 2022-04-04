module driver_74lv595 (
    input  clk,
    input  resetn,

    input  [31:0] data_0,
    input  [31:0] data_1,

    output RCLK,            // storage register clock
    output SRCLK,           // shift register clock

    output SER_0,           // serial output
    output SER_1            // serial output
);

reg serial_clk;
reg shift_clk;
reg store_clk;

reg [ 5:0] cnt;

reg [31:0] data_0_r;
reg [31:0] data_1_r;

always @(posedge clk) begin
    if (~resetn) begin
        serial_clk <= 1'b0;
    end else begin
        serial_clk <= ~serial_clk;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        cnt <= 6'd0;
    end else if (!serial_clk) begin
        if (cnt == 6'd32) begin
            cnt <= 6'd0;
        end else begin
            cnt <= cnt + 6'd1;
        end
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        shift_clk <= 1'b0;
    end else if (serial_clk) begin
        shift_clk <= 1'b0;
    end else begin
        if (cnt == 6'd32) begin
            shift_clk <= 1'b0;
        end else begin
            shift_clk <= 1'b1;
        end
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        store_clk <= 1'b0;
    end else if (serial_clk) begin
        store_clk <= 1'b0;
    end else begin
        if (cnt == 6'd32) begin
            store_clk <= 1'b1;
        end else begin
            store_clk <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        data_0_r <= 32'd0;
        data_1_r <= 32'd0;
    end else if (serial_clk) begin
        if (cnt == 6'd0) begin
            data_0_r <= data_0;
            data_1_r <= data_1;
        end else begin
            data_0_r <= {data_0_r[30:0], 1'b0};
            data_1_r <= {data_1_r[30:0], 1'b0};
        end
    end
end

assign RCLK = store_clk;
assign SRCLK = shift_clk;
assign SER_0 = data_0_r[31];
assign SER_1 = data_1_r[31];

endmodule
