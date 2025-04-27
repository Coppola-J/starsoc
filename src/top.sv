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
    input    clk_100mhz,
    input    reset,

    // HDMI output
    output        vid_io_out_0_active_video,
    output [23:0] vid_io_out_0_data,
    output        vid_io_out_0_field,
    output        vid_io_out_0_hblank,
    output        vid_io_out_0_hsync,
    output        vid_io_out_0_vblank,
    output        vid_io_out_0_vsync,

    // Debug
    output hsync_tb,
    output vsync_tb,
    output [11:0] rgb_out_tb,
    output [9:0] pixel_x_tb, pixel_y_tb,              // Using for tb only as of right now
    output video_on_tb,                               // Indicate when in visible area
    output pixel_clk_tb
);

    // --------------------------------------------------
    // Interconnects
    // --------------------------------------------------
    wire aresetn;          // Combined reset using locked && ~reset
    wire aclken;
    wire pixel_clk;        // From hdmi_bd_wrapper (clk_wiz)
    wire clk_locked;

    wire [9:0] pixel_x;    // From hdmi_timing to video_gen and axi_stream_wrapper
    wire [9:0] pixel_y;    // From hdmi_timing to video_gen and axi_stream_wrapper
    wire [9:0] next_pixel_x;    // From hdmi_timing to video_gen and axi_stream_wrapper
    wire [9:0] next_pixel_y;    // From hdmi_timing to video_gen and axi_stream_wrapper
    wire hsync;            // From hdmi_timing to video_gen and axi_stream_wrapper
    wire vsync;            // From hdmi_timing to video_gen and axi_stream_wrapper
    wire hblank;           // From hdmi_timing to video_gen and axi_stream_wrapper
    wire vblank;           // From hdmi_timing to video_gen and axi_stream_wrapper
    wire video_on;         // From hdmi_timing to video_gen and axi_stream_wrapper
    wire next_video_on;         // From hdmi_timing to video_gen and axi_stream_wrapper

    wire [11:0] rgb_out;   // From video_gen to axi_stream_wrapper

    wire [23:0] tdata;     // From axi_stream_wrapper to hdmi_bd_wrapper
    wire        tvalid;    // From axi_stream_wrapper to hdmi_bd_wrapper
    wire        tuser;     // From axi_stream_wrapper to hdmi_bd_wrapper
    wire        tlast;     // From axi_stream_wrapper to hdmi_bd_wrapper
    wire        tready;    // From hdmi_bd_wrapper to axi_stream_wrapper
    wire        vtg_ce;    // From hdmi_bd_wrapper to axi_stream_wrapper


    // --------------------------------------------------
    // Assignments
    // --------------------------------------------------
    assign aresetn = ~reset && clk_locked; //areset n goes high when clk is ready and reset is not on (active_low)
    assign aclken = clk_locked;


    // --------------------------------------------------
    // HDMI and Video Gen
    // --------------------------------------------------
    hdmi_timing hdmi_timing (
        .pixel_clk(clk_100mhz),    
        .reset(~aresetn),
        .vtg_ce(vtg_ce),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .next_pixel_x(next_pixel_x),
        .next_pixel_y(next_pixel_y),
        .hsync(hsync),
        .vsync(vsync),
        .hblank(hblank),
        .vblank(vblank),
        .video_on(video_on),
        .next_video_on(next_video_on)
    );

    video_gen video_gen (
        .pixel_clk(pixel_clk),    
        .reset(~aresetn),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .next_pixel_x(next_pixel_x),
        .next_pixel_y(next_pixel_y),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .next_video_on(next_video_on),
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
        .aresetn_0 (aresetn),                       //Active low reset
        .aclken_0 (aclken),                         //Active high clk enable
        .clk_100MHz(clk_100mhz),                    // From top-level clock input
        .locked_0(clk_locked),
        .pixel_clk_0(pixel_clk),                    // Goes to hdmi_timing and video_gen
        .reset_0(reset),

        // Timing signals from hdmi_timing (Outputs)
        .vtiming_in_0_active_video(video_on),
        .vtiming_in_0_field(1'b0),                  // Always progressive video, no interlacing
        .vtiming_in_0_hblank(hblank),
        .vtiming_in_0_hsync(hsync),
        .vtiming_in_0_vblank(vblank),
        .vtiming_in_0_vsync(vsync),

        // AXI-Stream video data in from logic (Inputs)
        .video_in_0_tdata(tdata),
        .video_in_0_tvalid(tvalid),
        .video_in_0_tuser(tuser),
        .video_in_0_tlast(tlast),

       // AXI-Stream video data in from logic (Outputs)
        .video_in_0_tready(tready),
        .vtg_ce_0(vtg_ce),

        // Output to HDMI pins
        .vid_io_out_0_active_video(vid_io_out_0_active_video),
        .vid_io_out_0_data(vid_io_out_0_data),
        .vid_io_out_0_field(vid_io_out_0_field),
        .vid_io_out_0_hblank(vid_io_out_0_hblank),
        .vid_io_out_0_hsync(vid_io_out_0_hsync),
        .vid_io_out_0_vblank(vid_io_out_0_vblank),
        .vid_io_out_0_vsync(vid_io_out_0_vsync)
    );

    /*hdmi_bd_wrapper u_hdmi_bd (
        .clk_100MHz    (clk_100mhz),
        .reset_0       (reset),
        .pixel_clk_0   (pixel_clk),
        .locked_0      (clk_locked)
    );*/


    // Pack RGB444 into RGB888 by shifting left (you can adjust if using RGB888 internally)
    //assign vid_io_out_0_data            = {rgb_out[11:8], rgb_out[7:4], rgb_out[3:0], 4'b0000}; // 4-bit to 8-bit expansion
    //assign vid_io_out_0_active_video    = video_on;
    //assign vid_io_out_0_hsync           = hsync;
    //assign vid_io_out_0_vsync           = vsync;
    //assign vid_io_out_0_hblank          = hblank;
    //assign vid_io_out_0_vblank          = vblank;
    //assign vid_io_out_0_field           = 1'b0; // progressive video

    // Debug
    assign hsync_tb = hsync;
    assign vsync_tb = vsync;
    assign rgb_out_tb = rgb_out;
    assign pixel_x_tb = pixel_x;
    assign pixel_y_tb = pixel_y;
    assign video_on_tb = video_on;                               
    assign pixel_clk_tb = pixel_clk;

endmodule