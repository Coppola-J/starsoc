// ----------------------------------------
// AXI Stream wrapper for HDMI pipeline
// Converts RGB and sync signals to AXI4S
// Justin Coppola
// 04/2025
// ----------------------------------------

module axi_stream_wrapper #(
    parameter H_RES = 640,
    parameter V_RES = 480
)(
    input  logic         clk,
    input  logic         reset,

    input  logic         video_on,
    input  logic [9:0]   pixel_x,
    input  logic [9:0]   pixel_y,
    input  logic         hsync,
    input  logic         vsync,
    input  logic [11:0]  rgb_in,   // From video_gen

    output logic [23:0]  tdata,
    output logic         tvalid,
    output logic         tuser,
    output logic         tlast,
    input  logic         tready    // From AXI4S-to-Video-Out
);

    // Expand RGB444 (4 bits per channel) to RGB888 (8 bits per channel)
    logic [7:0] r = {rgb_in[11:8], rgb_in[11:8]};
    logic [7:0] g = {rgb_in[7:4],  rgb_in[7:4]};
    logic [7:0] b = {rgb_in[3:0],  rgb_in[3:0]};

    assign tdata  = {r, g, b};
    assign tvalid = video_on;

    // Set tuser high only at the first pixel of the first line
    assign tuser  = (pixel_x == 0 && pixel_y == 0);

    // Set tlast high on last pixel of each scanline
    assign tlast  = (pixel_x == H_RES - 1);

endmodule
