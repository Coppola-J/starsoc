// ----------------------------------------
// ----------------------------------------
// Test the display timing for StarSoC game design
// hdmi_timing_tb.sv
// Justin Coppola
// 04/22/2025
// ----------------------------------------
// ----------------------------------------

module hdmi_timing_tb(
    input clk,
    input reset,
    output [9:0] x,y,            // Current pixel
    output hsync, vsync,         // New line, frame
    output video_on,             // Indicate when in visible area
    output p_clock             // Sync game logic to display 
);

endmodule