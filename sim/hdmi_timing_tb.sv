// ----------------------------------------
// ----------------------------------------
// Test the display timing for StarSoC game design
// hdmi_timing_tb.sv
// Justin Coppola
// 04/22/2025
// ----------------------------------------
// ----------------------------------------

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
    repeat (50000) begin
        @(posedge p_clock_tb); // Wait for clock edge
        $display("%4t | %3d %3d   %b     %b       %b        %b", 
                 $time, x_tb, y_tb, hsync_tb, vsync_tb, video_on_tb, p_clock_tb);
    end

    $display("Simulation complete.");
    $finish;
end


// SVAS
always @(posedge clk_tb) begin

    // Make sure pixel x and coordinate never exceed 799 and 524 respectively
    assert (x_tb <= 799) else $error("x_tb exceeded 799 at time %0t", $time);
    assert (y_tb <= 524) else $error("y_tb exceeded 524 at time %0t", $time);

    // Make sure h and v sync go high in sync zones
    if (x_tb >= 703 && x_tb <= 799) begin
        assert (hsync_tb == 1) else $error("h_sync_tb was LOW during x_tb = %0d at time %0t", x_tb, $time);
    end
    if (y_tb >= 522 && y_tb <= 524) begin
        assert (vsync_tb == 1) else $error("y_sync_tb was LOW during y_tb = %0d at time %0t", y_tb, $time);
    end

    // Make sure video_on is on when pixel is in actve video area

end

endmodule

