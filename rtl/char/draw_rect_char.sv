`timescale 1 ns / 1 ps

module draw_rect_char (
    input  logic clk,
    input  logic rst,
    input  logic [7:0] char_pixels,
    output logic [7:0] char_xy,
    output logic [3:0] char_line,
    vga_if.in vga_in,
    vga_if.out vga_out
);

import vga_pkg::*;

/**
 * Local variables and signals
 */

vga_if intern();
vga_if intern2();

logic [11:0] rgb_nxt;
logic [10:0] char_xy_buff;
logic [10:0] char_line_buff;

/**
 * Internal logic
 */

always_ff @(posedge clk) begin
    if (rst) begin
        intern.vcount <= '0;
        intern.vsync  <= '0;
        intern.vblnk  <= '0;
        intern.hcount <= '0;
        intern.hsync  <= '0;
        intern.hblnk  <= '0;
        intern.rgb    <= '0;
    end else begin
        intern.vcount <= vga_in.vcount;
        intern.vsync  <= vga_in.vsync;
        intern.vblnk  <= vga_in.vblnk;
        intern.hcount <= vga_in.hcount;
        intern.hsync  <= vga_in.hsync;
        intern.hblnk  <= vga_in.hblnk;
        intern.rgb    <= vga_in.rgb;
    end
end

delay #(
    .WIDTH(38),
    .CLK_DEL(2)
) u_delay(
    .clk(clk),
    .rst(rst),
    .din({vga_in.vcount, vga_in.vsync, vga_in.vblnk, vga_in.hcount, vga_in.hsync, vga_in.hblnk, vga_in.rgb}),
    .dout({intern2.vcount, intern2.vsync, intern2.vblnk, intern2.hcount, intern2.hsync, intern2.hblnk, intern2.rgb})
);

always_ff @(posedge clk) begin
    vga_out.vcount <= intern2.vcount;
    vga_out.vsync  <= intern2.vsync;
    vga_out.vblnk  <= intern2.vblnk;
    vga_out.hcount <= intern2.hcount;
    vga_out.hsync  <= intern2.hsync;
    vga_out.hblnk  <= intern2.hblnk;
    vga_out.rgb    <= rgb_nxt;
end

always_comb begin
    char_xy_buff = vga_in.hcount - charx;
    char_line_buff = vga_in.vcount - chary;
    char_xy = char_xy_buff[9:3] + char_line_buff[9:4] * 16;
    //char_xy = 1;
    char_line = intern.vcount[3:0] - chary[3:0];
end

always_comb begin
    if(((intern2.hcount >= charx) & (intern2.hcount < charx + charl) & (intern2.vcount >= chary) & (intern2.vcount <= chary + charh)))
        if(char_pixels[7 - (intern2.hcount - charx) % 8] == 0)
            rgb_nxt = 12'hf_0_0;
        else
            rgb_nxt = 12'h0_0_f;
    else 
        rgb_nxt = intern2.rgb;
end

endmodule