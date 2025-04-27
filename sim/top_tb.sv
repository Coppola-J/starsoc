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

module top_tb;

    logic           clk_tb;
    logic           pixel_clk_tb;
    logic           reset_tb;
    logic           video_on_tb;
    logic           hsync_tb, vsync_tb;
    logic [9:0]     x_tb, y_tb;
    logic [11:0]    rgb_tb;
    int             error_count = 0;
    logic           last_pixel_clk;
    int             pixel_clk_toggle_count = 0;
    logic [23:0]    tdata_tb;
    logic           tvalid_tb, tuser_tb, tlast_tb, tready_tb;

// Instantiate top for tb
top dut (
    .clk_100mhz(clk_tb),
    .reset(reset_tb),           
    .hsync_tb(hsync_tb), 
    .vsync_tb(vsync_tb),
    .rgb_out_tb(rgb_tb),
    .pixel_x_tb(x_tb),
    .pixel_y_tb(y_tb),
    .pixel_clk_tb(pixel_clk_tb),
    .video_on_tb(video_on_tb)
);

    // AXI stream assignments
    assign tdata_tb  = dut.tdata;
    assign tvalid_tb = dut.tvalid;
    assign tuser_tb  = dut.tuser;
    assign tlast_tb  = dut.tlast;
    assign tready_tb = dut.tready;


    // Clock generator (10ns period (wait 5ns then toggle) = 100 MHz)
    initial clk_tb = 0;
    always #5 clk_tb = ~clk_tb;


initial begin
    $display("Starting TOP simulation...");
    $display("Time | x   y   hsync vsync rgb_value");

    // Initial reset
    reset_tb = 1;
    #20;
    reset_tb = 0;

    // Simulate a few thousand cycles (~1 frame at 640x480 @ 60Hz)
    repeat (1000000) begin
        @(posedge pixel_clk_tb); // Wait for clock edge
        $display("%4t | %3d %3d   %b         %b       %b", 
                 $time, x_tb, y_tb, hsync_tb, vsync_tb, rgb_tb);
    end

    $display("--------------------------------------------------");
    $display("Simulation finished with %0d assertion error(s).", error_count);
    $display("--------------------------------------------------");

    $finish;
end

// Track pixel clock toggles to ensure clk_wiz is generating a signal
always @(posedge clk_tb) begin
    if (pixel_clk_tb !== last_pixel_clk) begin
        pixel_clk_toggle_count++;
        last_pixel_clk = pixel_clk_tb;
    end
end

// Ensure pixel clock toggled at least twice during the simulation
final begin
    assert (pixel_clk_toggle_count > 2) else begin
        $fatal(1, "pixel_clk_tb did not toggle enough times during simulation.");
        error_count++;
    end
end

// SVAS
always @(posedge pixel_clk_tb) begin

    // Ensure x_tb and y_tb stay within horizontal and vertical timing bounds
    assert(x_tb <= 799) else begin 
        $error("x_tb exceeded 799 with a value of %0d at time %0t", x_tb, $time);
        error_count++;
    end 
    assert (y_tb <= 524) else begin
        $error("y_tb exceeded 524 with a value of %0d at time %0t", y_tb, $time);
        error_count++;
    end

    // Make sure h and v sync go high in sync zones
    if (x_tb >= (h_visible + h_fp) && x_tb <= h_max - h_bp) begin
        assert (hsync_tb == 1) else begin
            $fatal("h_sync_tb was LOW during x_tb = %0d at time %0t", x_tb, $time);
            error_count++;
        end
    end
    if (y_tb >= (v_visible + v_fp) && y_tb <= v_max - v_bp) begin
        assert (vsync_tb == 1) else begin
            $fatal("y_sync_tb was LOW during y_tb = %0d at time %0t", y_tb, $time);
            error_count++;
        end
    end

    // Make sure video_on is on when pixel is in actve video area
    if ((y_tb >= visible_origin_y && y_tb < v_visible) && (x_tb >= visible_origin_x && x_tb < h_visible)) begin
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

    // Check that tuser (start of frame) only asserts at the top-left pixel (0,0)
    if ((x_tb == visible_origin_x) && (y_tb == visible_origin_y)) begin
        assert (tuser_tb == 1) else begin
            $error(1, "tuser asserted at x=%0d, y=%0d instead of (0,0) at %0t, or tuser not asserted with value tuser = ", x_tb, y_tb, $time, tuser_tb);
            error_count++;
        end
    end

    // Check that tlast (end of line) only asserts at the last pixel of a row (x == 639)
    if (x_tb == h_visible-1) begin
        assert (tlast_tb == 1) else begin
            $error(1, "tlast asserted at x=%0d instead of 639 at %0t", x_tb, $time);
            error_count++;
        end
    end

    // Ensure tvalid is not asserted without tready (detect streaming stalls)
    assert (!(tvalid_tb && !tready_tb)) else begin
        $error(1, "tvalid high but tready not asserted (stall) at %0t", $time);
        error_count++;
    end

    // Ensure RGB is never unknown (X) during visible display area
    assert (!(video_on_tb && (rgb_tb === 12'bx))) else begin
        $fatal(1, "RGB output is undefined (X) during visible area at %0t", $time);
        error_count++;
    end

end

endmodule

