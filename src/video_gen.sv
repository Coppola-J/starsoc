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
    input         pixel_clk,           // Pixel clock 25MHz
    input         reset,

    input [9:0]   pixel_x,             // Current pixel pixel_x
    input [9:0]   pixel_y,             // Current pixel pixel_y
    input  [9:0]  next_pixel_x,        // Next pixel pixel_x (for video_gen)
    input  [9:0]  next_pixel_y,        // Next pixel pixel_y (for video_gen)
    input         hsync,               // New line
    input         vsync,               // New frame
    input         video_on,            // Indicate when in visible area
    input         next_video_on,       // Indicate when in visible area
    output [11:0] rgb_out,             // Current pixel color

    output [23:0]  tdata,
    output         tvalid,
    output         tuser,
    output         tlast,
    input          tready               // From AXI4S-to-Video-Out
);

// Registers
logic [11:0] rgb_reg;


// Expand RGB444 (4 bits per channel) to RGB888 (8 bits per channel)
wire [7:0] r = {rgb_out[11:8], rgb_out[11:8]};
wire [7:0] g = {rgb_out[7:4],  rgb_out[7:4]};
wire [7:0] b = {rgb_out[3:0],  rgb_out[3:0]};


always_ff @(posedge pixel_clk, posedge reset) begin
        if(reset) begin
            rgb_reg = COLOR_RED;
        end else begin
            if (((pixel_x >= player_x - 10) && (pixel_x < player_x + 10)) && 
            ((pixel_y >= player_y - 20) && (pixel_y < player_y + 20))) begin
                rgb_reg = COLOR_CYAN;
            end else if (pixel_x == 330) begin
                rgb_reg = COLOR_RED;
            end else begin
                rgb_reg = COLOR_BLUE;
            end
        end 
    end 


assign rgb_out = rgb_reg;

assign tdata  = {r, g, b} && (reset == 0);                                                                  // 24-bit packed RGB
assign tvalid = tready;//video_on && (reset == 0);                                                              // Only valid in visible area
assign tuser  = (pixel_x == visible_origin_x && pixel_y == visible_origin_y) && (reset == 0); //;     // First visible pixel of first line
assign tlast  = (pixel_x == h_visible-1) && (reset == 0);                                              // Last visible pixel in a row

endmodule