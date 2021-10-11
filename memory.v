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

reg  [30:0] read_data_r;
wire [30:0] read_data_sel;

wire [127:0] ram_read_data;
wire [127:0] ram_write_data;
wire [127:0] ram_write_bit;

reg finish_r;

// ram_0

wire ram_0_enable;
wire ram_0_write_enable;
wire [127:0] ram_0_read_data;
wire [127:0] ram_0_write_data;
wire [127:0] ram_0_write_bit;
wire [  5:0] ram_0_addr;

S011HD1P_X32Y2D128_BW ram_0 (
    .Q      (ram_0_read_data),
    .CLK    (clk),
    .CEN    (ram_0_enable),
    .WEN    (ram_0_write_enable),
    .BWEN   (ram_0_write_bit),
    .A      (ram_0_addr),
    .D      (ram_0_write_data)
);

// ram_1

wire ram_1_enable;
wire ram_1_write_enable;
wire [127:0] ram_1_read_data;
wire [127:0] ram_1_write_data;
wire [127:0] ram_1_write_bit;
wire [  5:0] ram_1_addr;

S011HD1P_X32Y2D128_BW ram_1 (
    .Q      (ram_1_read_data),
    .CLK    (clk),
    .CEN    (ram_1_enable),
    .WEN    (ram_1_write_enable),
    .BWEN   (ram_1_write_bit),
    .A      (ram_1_addr),
    .D      (ram_1_write_data)
);

// ram_2

wire ram_2_enable;
wire ram_2_write_enable;
wire [127:0] ram_2_read_data;
wire [127:0] ram_2_write_data;
wire [127:0] ram_2_write_bit;
wire [  5:0] ram_2_addr;

S011HD1P_X32Y2D128_BW ram_2 (
    .Q      (ram_2_read_data),
    .CLK    (clk),
    .CEN    (ram_2_enable),
    .WEN    (ram_2_write_enable),
    .BWEN   (ram_2_write_bit),
    .A      (ram_2_addr),
    .D      (ram_2_write_data)
);

// ram_3

wire ram_3_enable;
wire ram_3_write_enable;
wire [127:0] ram_3_read_data;
wire [127:0] ram_3_write_data;
wire [127:0] ram_3_write_bit;
wire [  5:0] ram_3_addr;

S011HD1P_X32Y2D128_BW ram_3 (
    .Q      (ram_3_read_data),
    .CLK    (clk),
    .CEN    (ram_3_enable),
    .WEN    (ram_3_write_enable),
    .BWEN   (ram_3_write_bit),
    .A      (ram_3_addr),
    .D      (ram_3_write_data)
);

// ram_4

wire ram_4_enable;
wire ram_4_write_enable;
wire [127:0] ram_4_read_data;
wire [127:0] ram_4_write_data;
wire [127:0] ram_4_write_bit;
wire [  5:0] ram_4_addr;

S011HD1P_X32Y2D128_BW ram_4 (
    .Q      (ram_4_read_data),
    .CLK    (clk),
    .CEN    (ram_4_enable),
    .WEN    (ram_4_write_enable),
    .BWEN   (ram_4_write_bit),
    .A      (ram_4_addr),
    .D      (ram_4_write_data)
);

// ram_5

wire ram_5_enable;
wire ram_5_write_enable;
wire [127:0] ram_5_read_data;
wire [127:0] ram_5_write_data;
wire [127:0] ram_5_write_bit;
wire [  5:0] ram_5_addr;

S011HD1P_X32Y2D128_BW ram_5 (
    .Q      (ram_5_read_data),
    .CLK    (clk),
    .CEN    (ram_5_enable),
    .WEN    (ram_5_write_enable),
    .BWEN   (ram_5_write_bit),
    .A      (ram_5_addr),
    .D      (ram_5_write_data)
);

// ram_6

wire ram_6_enable;
wire ram_6_write_enable;
wire [127:0] ram_6_read_data;
wire [127:0] ram_6_write_data;
wire [127:0] ram_6_write_bit;
wire [  5:0] ram_6_addr;

S011HD1P_X32Y2D128_BW ram_6 (
    .Q      (ram_6_read_data),
    .CLK    (clk),
    .CEN    (ram_6_enable),
    .WEN    (ram_6_write_enable),
    .BWEN   (ram_6_write_bit),
    .A      (ram_6_addr),
    .D      (ram_6_write_data)
);

// ram_7

wire ram_7_enable;
wire ram_7_write_enable;
wire [127:0] ram_7_read_data;
wire [127:0] ram_7_write_data;
wire [127:0] ram_7_write_bit;
wire [  5:0] ram_7_addr;

S011HD1P_X32Y2D128_BW ram_7 (
    .Q      (ram_7_read_data),
    .CLK    (clk),
    .CEN    (ram_7_enable),
    .WEN    (ram_7_write_enable),
    .BWEN   (ram_7_write_bit),
    .A      (ram_7_addr),
    .D      (ram_7_write_data)
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

assign ram_read_data = 
    ({128{~ram_0_enable}} & ram_0_read_data) |
    ({128{~ram_1_enable}} & ram_1_read_data) |
    ({128{~ram_2_enable}} & ram_2_read_data) |
    ({128{~ram_3_enable}} & ram_3_read_data) |
    ({128{~ram_4_enable}} & ram_4_read_data) |
    ({128{~ram_5_enable}} & ram_5_read_data) |
    ({128{~ram_6_enable}} & ram_6_read_data) |
    ({128{~ram_7_enable}} & ram_7_read_data);

assign read_data_sel = 
    ({31{addr[1:0] == 2'o0}} & ram_read_data[ 30: 0]) | 
    ({31{addr[1:0] == 2'o1}} & ram_read_data[ 62:32]) | 
    ({31{addr[1:0] == 2'o2}} & ram_read_data[ 94:64]) | 
    ({31{addr[1:0] == 2'o3}} & ram_read_data[126:96]);

// assign read_data = read_data_r;
assign read_data = read_data_sel;

assign ram_write_data = {4{1'b0, write_data}};

assign ram_0_write_data = ram_write_data;
assign ram_1_write_data = ram_write_data;
assign ram_2_write_data = ram_write_data;
assign ram_3_write_data = ram_write_data;
assign ram_4_write_data = ram_write_data;
assign ram_5_write_data = ram_write_data;
assign ram_6_write_data = ram_write_data;
assign ram_7_write_data = ram_write_data;

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

assign ram_0_write_enable = ~(write_enable && ~finish);
assign ram_1_write_enable = ~(write_enable && ~finish);
assign ram_2_write_enable = ~(write_enable && ~finish);
assign ram_3_write_enable = ~(write_enable && ~finish);
assign ram_4_write_enable = ~(write_enable && ~finish);
assign ram_5_write_enable = ~(write_enable && ~finish);
assign ram_6_write_enable = ~(write_enable && ~finish);
assign ram_7_write_enable = ~(write_enable && ~finish);

always @(posedge clk) begin
    if (~resetn) begin
        finish_r <= 1'b0;
    end else if (!finish_r && (write_enable || read_enable)) begin
        finish_r <= 1'b1;
    end else begin
        finish_r <= 1'b0;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        read_data_r <= 31'b0;
    end else if (finish_r) begin
        read_data_r <= read_data_sel;
    end
end

assign finish = finish_r;


endmodule