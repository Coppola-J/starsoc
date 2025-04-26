// ----------------------------------------
// ----------------------------------------
// Display timing for StarSoC game design
// hdmi_timing.sv
// Justin Coppola
// 04/22/2025
// ----------------------------------------
// ----------------------------------------
import starsoc_params::*;

module hdmi_timing
(
    input           pixel_clk,            //pixel clock 25MHz
    input           reset,
    input           vtg_ce,

    output  [9:0]   pixel_x,             // Current pixel pixel_x
    output  [9:0]   pixel_y,             // Current pixel pixel_y
    output          hsync,               // New line
    output          vsync,               // New frame
    output          hblank,              // Blank line
    output          vblank,              // Blank frame
    output          video_on             // Indicate when in visible area
);

    // Registers (two each to account for buffering)
    reg [9:0] h_count, h_count_next;
    reg [9:0] v_count, v_count_next;

    reg hsync_reg, hsync_next;
    reg vsync_reg, vsync_next;

    wire vtg_clk = 0;
    assign vtg_clk = pixel_clk && vtg_ce;


    // Next value and reset logic running on main clock (trying pixel_clk for now) 
    always@ (posedge vtg_clk, posedge reset) begin
        if (reset) begin
            h_count = 0;
            v_count = 0;
            hsync_reg = 1'b0;
            vsync_reg = 1'b0;
        end else begin
            h_count <= h_count_next;
            v_count <= v_count_next;
            hsync_reg <= hsync_next;
            vsync_reg <= vsync_next;
        end 
    end

    // Count Logic
    always@ (posedge vtg_clk, posedge reset) begin
        if (reset) begin                                     // If reset is high
            h_count_next = 0;
            v_count_next = 0;
        end else begin
            if (h_count < h_max-1) begin // If h is within bounds
                h_count_next = h_count_next + 1;
            end else begin                                       // If h is out of bounds
                if (v_count_next < v_max) begin                  // If h is out of bounds and v is in bounds
                    h_count_next = 0;
                    v_count_next = v_count_next + 1;
                end else begin                                   // if h and v are out of bounds
                    h_count_next = 0;
                    v_count_next = 0;
                end
            end
        end
    end 

    //assign hsync_next = (h_count >= ((h_max-1) - h_sync_zone)) && h_count < h_max);
    assign hsync_next = (h_count >= ((h_max - h_bp) - h_sync_zone) && h_count <= h_max - h_bp);
    assign vsync_next = (v_count >= ((v_max - v_bp) - v_sync_zone) && v_count <= v_max - v_bp);
    assign video_on = ((h_count >= visible_origin_x) && (h_count < h_visible)) && ((v_count >= visible_origin_y) && (v_count < v_visible));

    assign pixel_x = h_count;
    assign pixel_y = v_count;
    assign hsync = hsync_reg;
    assign vsync = vsync_reg;

    assign hblank = (h_count >= h_visible && h_count < h_max);
    assign vblank = (v_count >= v_visible && v_count < v_max);

endmodule