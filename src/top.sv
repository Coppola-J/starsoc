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
    output logic [11:0] rgb_top_out
);

    // Interconnect signals from hdmi_timing
    logic [9:0] pixel_x, pixel_y;
    logic video_on;
    logic p_tick;

    // Interconnect signals from video_gen
    logic [11:0] rgb_top;

    hdmi_timing hdmi_timing (
        .clk(clk),
        .reset(reset),
        .x(pixel_x),
        .y(pixel_y),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .p_clock(p_tick)
    );

    video_gen video_gen (
    .clk(clk),
    .reset(reset),
    .x(pixel_x),
    .y(pixel_y),
    .hsync(hsync),
    .vsync(vsync),
    .video_on(video_on),
    .p_clock(p_tick),
    .rgb_out(rgb_gen_out)
    );


endmodule