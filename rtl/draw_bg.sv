/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


 `timescale 1 ns / 1 ps
 
 module draw_bg (
     input  logic clk,
     input  logic rst,
     vga_if.in vga_in,    // Wejście interfejsu vga_if
     vga_if.out vga_out   // Wyjście interfejsu vga_if
 );
 import vga_pkg::*;
 
 
 
 /**
  * Local variables and signals
  */
 
 logic [11:0] rgb_nxt;
 localparam LETTER_COLOR = 12'hf_0_0;
 
 /**
  * Internal logic
  */
 
 always_ff @(posedge clk) begin : bg_ff_blk
     if (rst) begin
         vga_out.vcount <= '0;
         vga_out.vsync  <= '0;
         vga_out.vblnk  <= '0;
         vga_out.hcount <= '0;
         vga_out.hsync  <= '0;
         vga_out.hblnk  <= '0;
         vga_out.rgb    <= '0;
     end else begin
         vga_out.vcount <= vga_in.vcount;
         vga_out.vsync  <= vga_in.vsync;
         vga_out.vblnk  <= vga_in.vblnk;
         vga_out.hcount <= vga_in.hcount;
         vga_out.hsync  <= vga_in.hsync;
         vga_out.hblnk  <= vga_in.hblnk;
         vga_out.rgb    <= rgb_nxt;
     end
 end
 
 always_comb begin : bg_comb_blk
     if (vga_in.vblnk || vga_in.hblnk) begin             // Blanking region:
         rgb_nxt = 12'h0_0_0;                    // - make it it black.
     end else begin                              // Active region:
         if (vga_in.vcount == 0)                     // - top edge:
             rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
         else if (vga_in.vcount == VER_PIXELS - 1)   // - bottom edge:
             rgb_nxt = 12'hf_0_0;                // - - make a red line.
         else if (vga_in.hcount == 0)                // - left edge:
             rgb_nxt = 12'h0_f_0;                // - - make a green line.
         else if (vga_in.hcount == HOR_PIXELS - 1)   // - right edge:
             rgb_nxt = 12'h0_0_f;                // - - make a blue line.
 
         // Add your code here.
             //Litera O
         else if ((vga_in.hcount >= 450 & vga_in.hcount <= 700 & vga_in.vcount >= 100 & vga_in.vcount <= 225) & ((vga_in.hcount - 575)*(vga_in.hcount - 575))+((vga_in.vcount - 225)*(vga_in.vcount - 225)) <= 15625 & ((vga_in.hcount - 575)*(vga_in.hcount - 575))+((vga_in.vcount - 225)*(vga_in.vcount - 225)) >= 5625)
             rgb_nxt = LETTER_COLOR;
         else if ((vga_in.hcount >= 450 & vga_in.hcount <= 700 & vga_in.vcount >= 375 & vga_in.vcount <= 500) & ((vga_in.hcount - 575)*(vga_in.hcount - 575))+((vga_in.vcount - 375)*(vga_in.vcount - 375)) <= 15625 & ((vga_in.hcount - 575)*(vga_in.hcount - 575))+((vga_in.vcount - 375)*(vga_in.vcount - 375)) >= 5625)
             rgb_nxt = LETTER_COLOR;
         else if ((vga_in.hcount >= 450 & vga_in.hcount <= 500 & vga_in.vcount >= 225 & vga_in.vcount <= 375))
             rgb_nxt = LETTER_COLOR;
         else if ((vga_in.hcount >= 650 & vga_in.hcount <= 700 & vga_in.vcount >= 225 & vga_in.vcount <= 375))
             rgb_nxt = LETTER_COLOR;
             // Litera T
         else if ((vga_in.hcount >= 100 & vga_in.hcount <= 350 & vga_in.vcount >= 100 & vga_in.vcount <= 150))
             rgb_nxt = LETTER_COLOR;
         else if ((vga_in.hcount >= 200 & vga_in.hcount <= 250 & vga_in.vcount >= 150 & vga_in.vcount <= 500))
             rgb_nxt = LETTER_COLOR;
         
         
          
         else                                    // The rest of active display pixels:
             rgb_nxt = 12'h8_8_8;                // - fill with gray.
     end
 end
 
 endmodule