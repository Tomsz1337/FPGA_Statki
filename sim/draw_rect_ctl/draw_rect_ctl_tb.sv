`timescale 1ns/1ps

module draw_rect_ctl_tb;
    
logic clk_div, mouse_left, rst;
logic [11:0] mouse_xpos, mouse_ypos, xpos, ypos;


initial begin 
    clk_div = 'b1;
    forever #1_000_000 clk_div = ~clk_div;
end


draw_rect_ctl dut(
    .clk_div,
    .rst,
    .mouse_xpos,
    .mouse_ypos,
    .mouse_left,
    .xpos,
    .ypos
);


initial begin
    rst = 1;
    repeat(2) @(posedge clk_div);
    rst = 0;

    mouse_xpos = 100;
    mouse_ypos = 100;
    @(posedge clk_div);

    mouse_left = 1;
    @(posedge clk_div);
    mouse_left = 0;
    repeat(1000) @(posedge clk_div);

    mouse_left = 1;
    @(posedge clk_div);
    mouse_left = 0;
    repeat(100) @(posedge clk_div);

    $finish;
end

endmodule