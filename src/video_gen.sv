// ----------------------------------------
// ----------------------------------------
// Generates pixel colors and display from pixel 
// location given my hdmi_timing
// video_gen.sv
// Justin Coppola
// 04/23/2025
// ----------------------------------------
// ----------------------------------------
import starsoc_params::*;

module video_gen
(
    input  logic         pixel_clk,           //pixel clock 25MHz
    input  logic         reset,

    input  logic [9:0]   pixel_x,             // Current pixel pixel_x
    input  logic [9:0]   pixel_y,             // Current pixel pixel_y
    input  logic         hsync,               // New line
    input  logic         vsync,               // New frame
    input  logic         video_on,            // Indicate when in visible area
    output logic [11:0]  rgb_out,              // Current pixel color

    output logic [23:0]  tdata,
    output logic         tvalid,
    output logic         tuser,
    output logic         tlast,
    input  logic         tready               // From AXI4S-to-Video-Out
);

reg [11:0] rbg_reg;

always@ (posedge pixel_clk, posedge reset)
    begin
        if(reset) begin
            rbg_reg = COLOR_RED;
        end else begin
            if (((pixel_x >= visible_origin_x - 10) && (pixel_x < visible_origin_x + 10)) && 
            ((pixel_y >= visible_origin_y - 20) && (pixel_y < visible_origin_y + 20))) begin
                rbg_reg = COLOR_CYAN;
            end else begin
                rbg_reg = COLOR_RED;
            end
        end 
    end 

assign rgb_out = rbg_reg;

// Expand RGB444 (4 bits per channel) to RGB888 (8 bits per channel)
wire [7:0] r = {rgb_out[11:8], rgb_out[11:8]};
wire [7:0] g = {rgb_out[7:4],  rgb_out[7:4]};
wire [7:0] b = {rgb_out[3:0],  rgb_out[3:0]};

assign tdata  = {r, g, b};                                     // 24-bit packed RGB
assign tvalid = video_on;                                      // Only valid in visible area
assign tuser  = (pixel_x == h_fp) && (pixel_y == v_fp);        // First visible pixel of first line
assign tlast  = (pixel_x == h_fp + h_visible - 1);             // Last visible pixel in a row

endmodule