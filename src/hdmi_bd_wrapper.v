//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Thu Apr 24 19:13:13 2025
//Host        : DESKTOP-ODQGI7J running 64-bit major release  (build 9200)
//Command     : generate_target hdmi_bd_wrapper.bd
//Design      : hdmi_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module hdmi_bd_wrapper
   (aclken_0,
    aresetn_0,
    clk_100MHz,
    locked_0,
    pixel_clk_0,
    reset_0,
    vid_io_out_0_active_video,
    vid_io_out_0_data,
    vid_io_out_0_field,
    vid_io_out_0_hblank,
    vid_io_out_0_hsync,
    vid_io_out_0_vblank,
    vid_io_out_0_vsync,
    video_in_0_tdata,
    video_in_0_tlast,
    video_in_0_tready,
    video_in_0_tuser,
    video_in_0_tvalid,
    vtg_ce_0,
    vtiming_in_0_active_video,
    vtiming_in_0_field,
    vtiming_in_0_hblank,
    vtiming_in_0_hsync,
    vtiming_in_0_vblank,
    vtiming_in_0_vsync);
  input aclken_0;
  input aresetn_0;
  input clk_100MHz;
  output locked_0;
  output pixel_clk_0;
  input reset_0;
  output vid_io_out_0_active_video;
  output [23:0]vid_io_out_0_data;
  output vid_io_out_0_field;
  output vid_io_out_0_hblank;
  output vid_io_out_0_hsync;
  output vid_io_out_0_vblank;
  output vid_io_out_0_vsync;
  input [23:0]video_in_0_tdata;
  input video_in_0_tlast;
  output video_in_0_tready;
  input video_in_0_tuser;
  input video_in_0_tvalid;
  output vtg_ce_0;
  input vtiming_in_0_active_video;
  input vtiming_in_0_field;
  input vtiming_in_0_hblank;
  input vtiming_in_0_hsync;
  input vtiming_in_0_vblank;
  input vtiming_in_0_vsync;

  wire aclken_0;
  wire aresetn_0;
  wire clk_100MHz;
  wire locked_0;
  wire pixel_clk_0;
  wire reset_0;
  wire vid_io_out_0_active_video;
  wire [23:0]vid_io_out_0_data;
  wire vid_io_out_0_field;
  wire vid_io_out_0_hblank;
  wire vid_io_out_0_hsync;
  wire vid_io_out_0_vblank;
  wire vid_io_out_0_vsync;
  wire [23:0]video_in_0_tdata;
  wire video_in_0_tlast;
  wire video_in_0_tready;
  wire video_in_0_tuser;
  wire video_in_0_tvalid;
  wire vtg_ce_0;
  wire vtiming_in_0_active_video;
  wire vtiming_in_0_field;
  wire vtiming_in_0_hblank;
  wire vtiming_in_0_hsync;
  wire vtiming_in_0_vblank;
  wire vtiming_in_0_vsync;

  hdmi_bd hdmi_bd_i
       (.aclken_0(aclken_0),
        .aresetn_0(aresetn_0),
        .clk_100MHz(clk_100MHz),
        .locked_0(locked_0),
        .pixel_clk_0(pixel_clk_0),
        .reset_0(reset_0),
        .vid_io_out_0_active_video(vid_io_out_0_active_video),
        .vid_io_out_0_data(vid_io_out_0_data),
        .vid_io_out_0_field(vid_io_out_0_field),
        .vid_io_out_0_hblank(vid_io_out_0_hblank),
        .vid_io_out_0_hsync(vid_io_out_0_hsync),
        .vid_io_out_0_vblank(vid_io_out_0_vblank),
        .vid_io_out_0_vsync(vid_io_out_0_vsync),
        .video_in_0_tdata(video_in_0_tdata),
        .video_in_0_tlast(video_in_0_tlast),
        .video_in_0_tready(video_in_0_tready),
        .video_in_0_tuser(video_in_0_tuser),
        .video_in_0_tvalid(video_in_0_tvalid),
        .vtg_ce_0(vtg_ce_0),
        .vtiming_in_0_active_video(vtiming_in_0_active_video),
        .vtiming_in_0_field(vtiming_in_0_field),
        .vtiming_in_0_hblank(vtiming_in_0_hblank),
        .vtiming_in_0_hsync(vtiming_in_0_hsync),
        .vtiming_in_0_vblank(vtiming_in_0_vblank),
        .vtiming_in_0_vsync(vtiming_in_0_vsync));
endmodule
