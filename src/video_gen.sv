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
    output logic [11:0]  rgb_out              // Current pixel color
);

reg [11:0] rbg_reg;

always@ (posedge pixel_clk, posedge reset)
    begin
        if(reset) begin
            rbg_reg = COLOR_BLACK;
        end else begin
            if (((pixel_x >= visible_origin_x - 10) && (pixel_x < visible_origin_x + 10)) && 
            ((pixel_y >= visible_origin_y - 20) && (pixel_y < visible_origin_y + 20))) begin
                rbg_reg = COLOR_CYAN;
            end else begin
                rbg_reg = COLOR_BLACK;
            end
        end 
    end 

assign rgb_out = rbg_reg;

endmodule