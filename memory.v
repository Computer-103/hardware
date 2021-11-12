module memory (
    input clk, 
    input resetn,

    input write_enable,
    input read_enable,
    output finish,

    input  [11:0] addr,
    input  [30:0] write_data,
    output [30:0] read_data
);

wire [30:0] ram_read_word;
wire [30:0] ram_write_word;

wire [127:0] ram_read_line;
wire [127:0] ram_write_line;
wire [127:0] ram_write_bit;

reg  [11:0] write_addr_r;
reg  [30:0] write_data_r;
reg  [30:0] read_data_r;

reg  finish_r;
reg  reading;
reg  writing;

// ram_0

wire ram_0_enable;
wire ram_0_write_enable;
wire [127:0] ram_0_read_line;
wire [127:0] ram_0_write_line;
wire [127:0] ram_0_write_bit;
wire [  5:0] ram_0_addr;

S011HD1P_X32Y2D128_BW ram_0 (
    .Q      (ram_0_read_line),
    .CLK    (clk),
    .CEN    (ram_0_enable),
    .WEN    (ram_0_write_enable),
    .BWEN   (ram_0_write_bit),
    .A      (ram_0_addr),
    .D      (ram_0_write_line)
);

// ram_1

wire ram_1_enable;
wire ram_1_write_enable;
wire [127:0] ram_1_read_line;
wire [127:0] ram_1_write_line;
wire [127:0] ram_1_write_bit;
wire [  5:0] ram_1_addr;

S011HD1P_X32Y2D128_BW ram_1 (
    .Q      (ram_1_read_line),
    .CLK    (clk),
    .CEN    (ram_1_enable),
    .WEN    (ram_1_write_enable),
    .BWEN   (ram_1_write_bit),
    .A      (ram_1_addr),
    .D      (ram_1_write_line)
);

// ram_2

wire ram_2_enable;
wire ram_2_write_enable;
wire [127:0] ram_2_read_line;
wire [127:0] ram_2_write_line;
wire [127:0] ram_2_write_bit;
wire [  5:0] ram_2_addr;

S011HD1P_X32Y2D128_BW ram_2 (
    .Q      (ram_2_read_line),
    .CLK    (clk),
    .CEN    (ram_2_enable),
    .WEN    (ram_2_write_enable),
    .BWEN   (ram_2_write_bit),
    .A      (ram_2_addr),
    .D      (ram_2_write_line)
);

// ram_3

wire ram_3_enable;
wire ram_3_write_enable;
wire [127:0] ram_3_read_line;
wire [127:0] ram_3_write_line;
wire [127:0] ram_3_write_bit;
wire [  5:0] ram_3_addr;

S011HD1P_X32Y2D128_BW ram_3 (
    .Q      (ram_3_read_line),
    .CLK    (clk),
    .CEN    (ram_3_enable),
    .WEN    (ram_3_write_enable),
    .BWEN   (ram_3_write_bit),
    .A      (ram_3_addr),
    .D      (ram_3_write_line)
);

// ram_4

wire ram_4_enable;
wire ram_4_write_enable;
wire [127:0] ram_4_read_line;
wire [127:0] ram_4_write_line;
wire [127:0] ram_4_write_bit;
wire [  5:0] ram_4_addr;

S011HD1P_X32Y2D128_BW ram_4 (
    .Q      (ram_4_read_line),
    .CLK    (clk),
    .CEN    (ram_4_enable),
    .WEN    (ram_4_write_enable),
    .BWEN   (ram_4_write_bit),
    .A      (ram_4_addr),
    .D      (ram_4_write_line)
);

// ram_5

wire ram_5_enable;
wire ram_5_write_enable;
wire [127:0] ram_5_read_line;
wire [127:0] ram_5_write_line;
wire [127:0] ram_5_write_bit;
wire [  5:0] ram_5_addr;

S011HD1P_X32Y2D128_BW ram_5 (
    .Q      (ram_5_read_line),
    .CLK    (clk),
    .CEN    (ram_5_enable),
    .WEN    (ram_5_write_enable),
    .BWEN   (ram_5_write_bit),
    .A      (ram_5_addr),
    .D      (ram_5_write_line)
);

// ram_6

wire ram_6_enable;
wire ram_6_write_enable;
wire [127:0] ram_6_read_line;
wire [127:0] ram_6_write_line;
wire [127:0] ram_6_write_bit;
wire [  5:0] ram_6_addr;

S011HD1P_X32Y2D128_BW ram_6 (
    .Q      (ram_6_read_line),
    .CLK    (clk),
    .CEN    (ram_6_enable),
    .WEN    (ram_6_write_enable),
    .BWEN   (ram_6_write_bit),
    .A      (ram_6_addr),
    .D      (ram_6_write_line)
);

// ram_7

wire ram_7_enable;
wire ram_7_write_enable;
wire [127:0] ram_7_read_line;
wire [127:0] ram_7_write_line;
wire [127:0] ram_7_write_bit;
wire [  5:0] ram_7_addr;

S011HD1P_X32Y2D128_BW ram_7 (
    .Q      (ram_7_read_line),
    .CLK    (clk),
    .CEN    (ram_7_enable),
    .WEN    (ram_7_write_enable),
    .BWEN   (ram_7_write_bit),
    .A      (ram_7_addr),
    .D      (ram_7_write_line)
);

// select
assign ram_0_enable = ~(addr[11:8] == 4'o0);
assign ram_1_enable = ~(addr[11:8] == 4'o1);
assign ram_2_enable = ~(addr[11:8] == 4'o2);
assign ram_3_enable = ~(addr[11:8] == 4'o3);
assign ram_4_enable = ~(addr[11:8] == 4'o4);
assign ram_5_enable = ~(addr[11:8] == 4'o5);
assign ram_6_enable = ~(addr[11:8] == 4'o6);
assign ram_7_enable = ~(addr[11:8] == 4'o7);

assign ram_0_addr = addr[7:2];
assign ram_1_addr = addr[7:2];
assign ram_2_addr = addr[7:2];
assign ram_3_addr = addr[7:2];
assign ram_4_addr = addr[7:2];
assign ram_5_addr = addr[7:2];
assign ram_6_addr = addr[7:2];
assign ram_7_addr = addr[7:2];

assign ram_read_line = 
    ({128{~ram_0_enable}} & ram_0_read_line) |
    ({128{~ram_1_enable}} & ram_1_read_line) |
    ({128{~ram_2_enable}} & ram_2_read_line) |
    ({128{~ram_3_enable}} & ram_3_read_line) |
    ({128{~ram_4_enable}} & ram_4_read_line) |
    ({128{~ram_5_enable}} & ram_5_read_line) |
    ({128{~ram_6_enable}} & ram_6_read_line) |
    ({128{~ram_7_enable}} & ram_7_read_line);

assign ram_read_word = 
    ({31{addr[1:0] == 2'o0}} & ram_read_line[ 30: 0]) | 
    ({31{addr[1:0] == 2'o1}} & ram_read_line[ 62:32]) | 
    ({31{addr[1:0] == 2'o2}} & ram_read_line[ 94:64]) | 
    ({31{addr[1:0] == 2'o3}} & ram_read_line[126:96]);

assign ram_write_line = {4{1'b0, ram_write_word}};

assign ram_0_write_line = ram_write_line;
assign ram_1_write_line = ram_write_line;
assign ram_2_write_line = ram_write_line;
assign ram_3_write_line = ram_write_line;
assign ram_4_write_line = ram_write_line;
assign ram_5_write_line = ram_write_line;
assign ram_6_write_line = ram_write_line;
assign ram_7_write_line = ram_write_line;

assign ram_write_bit = 
    ({128{addr[1:0] == 2'o0}} & (128'h_7fff_ffff <<  0)) | 
    ({128{addr[1:0] == 2'o1}} & (128'h_7fff_ffff << 32)) | 
    ({128{addr[1:0] == 2'o2}} & (128'h_7fff_ffff << 64)) | 
    ({128{addr[1:0] == 2'o3}} & (128'h_7fff_ffff << 96));

assign ram_0_write_bit = ~ram_write_bit;
assign ram_1_write_bit = ~ram_write_bit;
assign ram_2_write_bit = ~ram_write_bit;
assign ram_3_write_bit = ~ram_write_bit;
assign ram_4_write_bit = ~ram_write_bit;
assign ram_5_write_bit = ~ram_write_bit;
assign ram_6_write_bit = ~ram_write_bit;
assign ram_7_write_bit = ~ram_write_bit;

assign ram_0_write_enable = ~(writing);
assign ram_1_write_enable = ~(writing);
assign ram_2_write_enable = ~(writing);
assign ram_3_write_enable = ~(writing);
assign ram_4_write_enable = ~(writing);
assign ram_5_write_enable = ~(writing);
assign ram_6_write_enable = ~(writing);
assign ram_7_write_enable = ~(writing);

// buffer registers
// read_data <- read_data_r <- ram_read_word
assign read_data = read_data_r;
always @(posedge clk) begin
    if (~resetn) begin
        read_data_r <= 31'b0;
    end else if (reading) begin
        read_data_r <= ram_read_word;
    end
end

// write_data -> write_data_r -> ram_write_word
assign ram_write_word = write_data_r;
always @(posedge clk) begin
    if (~resetn) begin
        write_data_r <= 31'b0;
    end else if (write_enable) begin
        write_data_r <= write_data;
    end
end

// sequence control signals

always @(posedge clk) begin
    if (~resetn) begin
        reading <= 1'b0;
    end else if (read_enable) begin
        reading <= 1'b1;
    end else begin
        reading <= 1'b0;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        writing <= 1'b0;
    end else if (write_enable) begin
        writing <= 1'b1;
    end else begin
        writing <= 1'b0;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        finish_r <= 1'b0;
    end else if (reading || writing) begin
        finish_r <= 1'b1;
    end else begin
        finish_r <= 1'b0;
    end
end

assign finish = finish_r;


endmodule