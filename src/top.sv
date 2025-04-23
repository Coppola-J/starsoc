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
    // HDMI outputs — depends on how you're driving HDMI from rgb_out
    output logic hsync,
    output logic vsync,
    output logic [11:0] rgb
);

    // Internal signals from hdmi_timing
    logic [9:0] pixel_x, pixel_y;
    logic video_on;
    logic p_tick;


    hdmi_timing timing_unit (
        .clk(clk),
        .reset(reset),
        .x(pixel_x),
        .y(pixel_y),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .p_clock(p_tick)
    );


endmodule