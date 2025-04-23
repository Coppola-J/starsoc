// ----------------------------------------
// ----------------------------------------
// Test the display timing for StarSoC game design
// hdmi_timing_tb.sv
// Justin Coppola
// 04/22/2025
// ----------------------------------------
// ----------------------------------------

import starsoc_params::*;
`timescale 1ns/1ps

module hdmi_timing_tb;

    logic clk_tb;
    logic reset_tb;
    logic [9:0] x_tb, y_tb;            // Current pixel
    logic hsync_tb, vsync_tb;          // New line, frame
    logic video_on_tb;                 // Indicate when in visible area
    logic p_clock_tb;                  // Sync game logic to display 

// Instantiate hdmi_timing for tb
hdmi_timing dut (
    .clk(clk_tb),
    .reset(reset_tb),
    .x(x_tb),
    .y(y_tb),             
    .hsync(hsync_tb), 
    .vsync(vsync_tb),
    .video_on(video_on_tb),             // Indicate when in visible area
    .p_clock(p_clock_tb)            // Sync game logic to display 
);

    // Used as error tally for end of sim
    int error_count = 0;

    // Clock generator (10ns period (wait 5ns then toggle) = 100 MHz)
    initial clk_tb = 0;
    always #5 clk_tb = ~clk_tb;

initial begin
    $display("Starting HDMI_TIMING simulation...");
    $display("Time | x   y   hsync vsync video_on p_clock");

    // Initial reset
    reset_tb = 1;
    #20;
    reset_tb = 0;

    // Simulate a few thousand cycles (~1 frame at 640x480 @ 60Hz)
    repeat (500000) begin
        @(posedge p_clock_tb); // Wait for clock edge
        $display("%4t | %3d %3d   %b     %b       %b        %b", 
                 $time, x_tb, y_tb, hsync_tb, vsync_tb, video_on_tb, p_clock_tb);
    end

    $display("--------------------------------------------------");
    $display("Simulation finished with %0d assertion error(s).", error_count);
    $display("--------------------------------------------------");

    $finish;
end


// SVAS
always @(posedge p_clock_tb) begin

    // Make sure pixel x and coordinate never exceed 799 and 524 respectively
    assert(x_tb <= 799) else begin 
        $error("x_tb exceeded 799 with a value of %0d at time %0t", x_tb, $time);
        error_count++;
    end 
    assert (y_tb <= 524) else begin
        $error("y_tb exceeded 524 with a value of %0d at time %0t", y_tb, $time);
        error_count++;
    end

    // Make sure h and v sync go high in sync zones
    if (x_tb >= 703 && x_tb <= 799) begin
        assert (hsync_tb == 1) else begin
            $fatal("h_sync_tb was LOW during x_tb = %0d at time %0t", x_tb, $time);
            error_count++;
        end
    end
    if (y_tb >= 522 && y_tb <= 524) begin
        assert (vsync_tb == 1) else begin
            $fatal("y_sync_tb was LOW during y_tb = %0d at time %0t", y_tb, $time);
            error_count++;
        end
    end

    // Make sure video_on is on when pixel is in actve video area
    if ((y_tb > 9 && y_tb < 490) && (x_tb > 15 && x_tb < 656)) begin
        assert (video_on_tb == 1) else begin
            $fatal("Video_on not high during visible screen x_tb = %0d, y_tb = %0d at time %0t", x_tb, y_tb, $time);
            error_count++;
        end 
    end else begin 
        assert (video_on_tb == 0) else begin
            $fatal("Video_on high during non-visible screen x_tb = %0d, y_tb = %0d at time %0t", x_tb, y_tb, $time);
            error_count++;
        end
    end 

end

endmodule

