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
    input         pixel_clk,           //pixel clock 25MHz
    input         reset,

    input [9:0]   pixel_x,             // Current pixel pixel_x
    input [9:0]   pixel_y,             // Current pixel pixel_y
    input         hsync,               // New line
    input         vsync,               // New frame
    input         video_on,            // Indicate when in visible area
    output [11:0] rgb_out,             // Current pixel color

    output [23:0]  tdata,
    output         tvalid,
    output         tuser,
    output         tlast,
    input          tready               // From AXI4S-to-Video-Out
);

// Registers
reg [11:0] rbg_reg;

reg [23:0] tdata_reg = 0;
reg tvalid_reg = 0;
reg tuser_reg = 0;
reg tlast_reg = 0;

// Expand RGB444 (4 bits per channel) to RGB888 (8 bits per channel)
wire [7:0] r = {rgb_out[11:8], rgb_out[11:8]};
wire [7:0] g = {rgb_out[7:4],  rgb_out[7:4]};
wire [7:0] b = {rgb_out[3:0],  rgb_out[3:0]};


always@ (posedge pixel_clk, posedge reset)
    begin
        if(reset) begin
            rbg_reg = COLOR_RED;
        end else begin
            if (((pixel_x >= player_x - 10) && (pixel_x < player_x + 10)) && 
            ((pixel_y >= player_y - 20) && (pixel_y < player_y + 20))) begin
                rbg_reg = COLOR_CYAN;
            end else begin
                rbg_reg = COLOR_RED;
            end
        end 
    end 

always @(posedge pixel_clk, posedge reset) begin
    if (reset) begin
        tvalid_reg  = 0;
        tdata_reg   = 0;
        tuser_reg   = 0;
        tlast_reg   = 0;
    end else if (video_on) begin
        tvalid_reg = 1;
        if (tready) begin  // Only update when ready to consume
            tdata_reg = {r, g, b}; // 24-bit RGB
            tuser_reg = (pixel_x == visible_origin_x && pixel_y == visible_origin_y);    // Start of frame
            tlast_reg = (pixel_x == h_visible-1);        // End of line
        end
    end else begin
        tvalid_reg = 0;
        tuser_reg = 0;
        tdata_reg = 0;
        tlast_reg = 0;       
    end
end


assign rgb_out = rbg_reg;

assign tdata  = tdata_reg;                                     // 24-bit packed RGB
assign tvalid = tvalid_reg;                                    // Only valid in visible area
assign tuser  = tuser_reg;                                     // First visible pixel of first line
assign tlast  = tlast_reg;                                     // Last visible pixel in a row

endmodule