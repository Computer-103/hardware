/**
 * ЗУ
 * запоминающее устройство
 * 存贮器
 * for ASIC
**/

module memory_fpga (
    input clk, 
    input resetn,

    input  mem_read_from_pu,
    input  mem_read_from_pnl,
    input  mem_write_from_io,
    input  mem_write_from_pnl,
    output mem_read_reply_to_pu,
    output mem_read_reply_to_ac,
    output mem_write_reply_to_op,
    output mem_write_reply_to_io,
    output mem_reply_to_io,

    input  [11:0] sel_value_from_sel,

    input  write_sign_from_ac,
    input  [29:0] write_data_from_au,
    output read_sign_to_ac,
    output [29:0] read_data_to_au
);

// ctrl
wire do_mem_read;
wire do_mem_write;

reg  write_finish_r;
reg  read_finish_r;
reg  reading;
reg  writing;

wire ram_write_enable;

// machine side
wire [11:0] addr;
wire [30:0] write_data;
wire [30:0] read_data;

// middleware
reg  [30:0] write_data_r;
reg  [30:0] read_data_r;

// ram side
wire [10:0] ram_addr;
wire [30:0] ram_read_word;
wire [30:0] ram_write_word;

// ram
Gowin_SP_31_2K ram (
    .dout(ram_read_word),
    .clk(clk),
    .oce(1'b0),
    .ce(1'b1),
    .reset(~resetn),
    .wre(ram_write_enable),
    .ad(ram_addr),
    .din(ram_write_word)
);

// ctrl
assign do_mem_read = 
    mem_read_from_pu || mem_read_from_pnl;
assign do_mem_write =
    mem_write_from_io || mem_write_from_pnl;

assign addr = sel_value_from_sel;
assign ram_addr = addr[10:0];
assign ram_write_enable = writing;

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
    end else if (do_mem_write) begin
        write_data_r <= write_data;
    end
end

// sequence control signals
always @(posedge clk) begin
    if (~resetn) begin
        reading <= 1'b0;
    end else if (do_mem_read) begin
        reading <= 1'b1;
    end else begin
        reading <= 1'b0;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        writing <= 1'b0;
    end else if (do_mem_write) begin
        writing <= 1'b1;
    end else begin
        writing <= 1'b0;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        write_finish_r <= 1'b0;
        read_finish_r <= 1'b0;
    end else begin
        write_finish_r <= writing;
        read_finish_r <= reading;
    end
end

// reply signals
assign mem_write_reply_to_io = write_finish_r;
assign mem_write_reply_to_op = write_finish_r;
assign mem_read_reply_to_pu = read_finish_r;
assign mem_read_reply_to_ac = read_finish_r;

assign mem_reply_to_io = write_finish_r || read_finish_r;

// concatenation of sign and data
assign write_data = {write_sign_from_ac, write_data_from_au};
assign {read_sign_to_ac, read_data_to_au} = read_data;

endmodule
