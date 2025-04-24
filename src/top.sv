// ----------------------------------------
// ----------------------------------------
// Top module for StarSoC game design
// top.sv
// Justin Coppola
// 04/22/2025
// ----------------------------------------
// ----------------------------------------
import starsoc_params::*;

module top 
(
    input  logic    clk_100mhz,
    input  logic    reset,

    // HDMI output to external pins (ADV7511 HDMI TX)
    output logic        vid_io_out_0_active_video,
    output logic [23:0] vid_io_out_0_data,
    output logic        vid_io_out_0_field,
    output logic        vid_io_out_0_hblank,
    output logic        vid_io_out_0_hsync,
    output logic        vid_io_out_0_vblank,
    output logic        vid_io_out_0_vsync,

    // Debug
    output logic hsync_tb,
    output logic vsync_tb,
    output logic [11:0] rgb_out_tb,
    output logic [9:0] pixel_x_tb, pixel_y_tb,              // Using for tb only as of right now
    output logic video_on_tb,                               // Indicate when in visible area
    output logic pixel_clk_tb
);

    // --------------------------------------------------
    // Interconnects
    // --------------------------------------------------
    logic pixel_clk;        // From hdmi_bd_wrapper (clk_wiz)

    logic [9:0] pixel_x;    // From hdmi_timing to video_gen and axi_stream_wrapper
    logic [9:0] pixel_y;    // From hdmi_timing to video_gen and axi_stream_wrapper
    logic hsync;            // From hdmi_timing to video_gen and axi_stream_wrapper
    logic vsync;            // From hdmi_timing to video_gen and axi_stream_wrapper
    logic hblank;            // From hdmi_timing to video_gen and axi_stream_wrapper
    logic vblank;            // From hdmi_timing to video_gen and axi_stream_wrapper
    logic video_on;         // From hdmi_timing to video_gen and axi_stream_wrapper

    logic [11:0] rgb_out;   // From video_gen to axi_stream_wrapper

    logic [23:0] tdata;     // From axi_stream_wrapper to hdmi_bd_wrapper
    logic        tvalid;    // From axi_stream_wrapper to hdmi_bd_wrapper
    logic        tuser;     // From axi_stream_wrapper to hdmi_bd_wrapper
    logic        tlast;     // From axi_stream_wrapper to hdmi_bd_wrapper
    logic        tready;    // From hdmi_bd_wrapper to axi_stream_wrapper

    // logic locked;        // From clk_wiz (not exposed in wrapper now, but useful for gated reset)
    // logic aresetn;       // Combined reset using locked && ~reset

    // --------------------------------------------------
    // HDMI and Video Gen
    // --------------------------------------------------
    hdmi_timing hdmi_timing (
        .clk_100mhz(clk_100mhz),
        .pixel_clk(pixel_clk),    
        .reset(reset),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .hsync(hsync),
        .vsync(vsync),
        .hblank(hblank),
        .vblank(vblank),
        .video_on(video_on)
    );

    video_gen video_gen (
        .pixel_clk(pixel_clk),    
        .reset(reset),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .rgb_out(rgb_out),
        .tdata(tdata),
        .tvalid(tvalid),
        .tuser(tuser),
        .tlast(tlast),
        .tready(tready)
    );

    // --------------------------------------------------
    // HDMI Block Design Wrapper
    // --------------------------------------------------
    hdmi_bd_wrapper hdmi_bd_inst (
        .clk_100MHz(clk_100mhz),                    // From top-level clock input
        .pixel_clk_0(pixel_clk),                    // Goes to hdmi_timing and video_gen
        .reset_0(reset),
        .vid_io_out_reset_0(1'b0),

        // AXI-Stream video data in from logic
        .video_in_0_tdata(tdata),
        .video_in_0_tvalid(tvalid),
        .video_in_0_tuser(tuser),
        .video_in_0_tlast(tlast),
        .video_in_0_tready(tready),

        // Timing signals from hdmi_timing
        .vtiming_in_0_active_video(video_on),
        .vtiming_in_0_field(1'b0),                  // Always progressive video, no interlacing
        .vtiming_in_0_hblank(hblank),
        .vtiming_in_0_hsync(hsync),
        .vtiming_in_0_vblank(vblank),
        .vtiming_in_0_vsync(vsync),

        // Output to HDMI pins
        .vid_io_out_0_active_video(vid_io_out_0_active_video),
        .vid_io_out_0_data(vid_io_out_0_data),
        .vid_io_out_0_field(vid_io_out_0_field),
        .vid_io_out_0_hblank(vid_io_out_0_hblank),
        .vid_io_out_0_hsync(vid_io_out_0_hsync),
        .vid_io_out_0_vblank(vid_io_out_0_vblank),
        .vid_io_out_0_vsync(vid_io_out_0_vsync)
    );

    // Debug
    assign hsync_tb = hsync;
    assign vsync_tb = vsync;
    assign rgb_out_tb = rgb_out;
    assign pixel_x_tb = pixel_x;
    assign pixel_y_tb = pixel_y;
    assign video_on_tb = video_on;                               
    assign pixel_clk_tb = pixel_clk;

endmodule