// ----------------------------------------
// ----------------------------------------
// Top module for StarSoC game design
// top.sv
// Justin Coppola
// 04/22/2025
// ----------------------------------------
// ----------------------------------------

module top (
    input  logic clk,
    input  logic reset,
    output logic hsync,
    output logic vsync,
    output logic [11:0] rgb_top_out,
    output logic [9:0] pixel_x, pixel_y,             // Using for tb only as of right now
    output video_on,                                 // Indicate when in visible area
    output logic p_clock
);

    hdmi_timing hdmi_timing (
        .clk(clk),
        .reset(reset),
        .x(pixel_x),
        .y(pixel_y),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .p_clock(p_clock)
    );

    video_gen video_gen (
    .clk(clk),
    .reset(reset),
    .x(pixel_x),
    .y(pixel_y),
    .hsync(hsync),
    .vsync(vsync),
    .video_on(video_on),
    .p_clock(p_clock),
    .rgb_out(rgb_top_out)
    );

endmodule