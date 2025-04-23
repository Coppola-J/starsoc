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

module video_gen(
    input clk,
    input reset,
    input [9:0] x,y,            // Current pixel
    input hsync, vsync,         // New line, frame
    input video_on,             // Indicate when in visible area
    input p_clock,             // Sync game logic to display 
    output [11:0] rgb_out      // Current pixel color
);

reg [11:0] rbg_reg;

always@ (posedge p_clock, posedge reset)
    begin
        if(reset) begin
            rbg_reg = COLOR_BLACK;
        end else begin

            if (((x >= visible_origin_x - 10) && (x < visible_origin_x + 10)) && 
                ((y >= visible_origin_y - 20) && (y < visible_origin_y + 20))) begin
                rbg_reg = COLOR_CYAN;
            end

        end 
    end 

assign rgb_out = rbg_reg;

endmodule