// ----------------------------------------
// ----------------------------------------
// Display timing for StarSoC game design
// hdmi_timing.sv
// Justin Coppola
// 04/22/2025
// ----------------------------------------
// ----------------------------------------

module hdmi_timing(
    input clk,
    input reset,
    output [9:0] x,y,            // Current pixel
    output hsync, vsync,         // New line, frame
    output video_on,             // Indicate when in visible area
    output p_clock               // Sync game logic to display 
);

    // Parameters based on VGA standards for 640x480 @60hz display
    // Horizontal Parameters
    parameter h_max = 800;
    parameter h_visible = 640;
    parameter h_fp = 16;
    parameter h_sync_zone = 96;
    parameter h_bp = 48;

    // Vertical Parameters
    parameter v_max = 525;
    parameter v_visible = 480;
    parameter v_fp = 10;
    parameter v_sync_zone = 2;
    parameter v_bp = 33;

    // New clock generation
    reg [1:0] p_clock_reg;
    wire p_clock_wire;                                       // Display logic will run off this clock

    always@ (posedge clk, posedge reset) begin
        if (reset)
            p_clock_reg <= 0;
        else
            p_clock_reg <= p_clock_reg + 1;
    end

    assign p_clock_wire = p_clock_reg[1];                    //Slow clock to 1/4 original speed (if 100Mhz)


    // Registers (two each to account for buffering)
    reg [9:0] h_count, h_count_next;
    reg [9:0] v_count, v_count_next;

    reg hsync_reg, hsync_next;
    reg vsync_reg, vsync_next;


    // Next value and reset logic running on main clock
    always@ (posedge clk, posedge reset) begin
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
    always@ (posedge p_clock_wire, posedge reset) begin
        if (reset) begin                                     // If reset is high
            h_count_next = 0;
            v_count_next = 0;
        end else if (h_count < h_max-1) begin                  // If h is within bounds
            h_count_next = h_count_next + 1;
        end else begin                                       // If h is out of bounds
            if (v_count_next < v_max-1) begin                  // If h is out of bounds and v is in bounds
                h_count_next = 0;
                v_count_next = v_count_next + 1;
            end else begin                                   // if h and v are out of bounds
                h_count_next = 0;
                v_count_next = 0;
            end
        end
    end 

    //assign hsync_next = (h_count >= ((h_max-1) - h_sync_zone)) && h_count < h_max);
    assign hsync_next = (h_count >= ((h_max-1) - h_sync_zone) && h_count <= h_max-1);
    assign vsync_next = (v_count >= ((v_max-1) - v_sync_zone) && v_count <= v_max-1);
    assign video_on = (h_count >= h_fp && h_count < (h_max - (h_sync_zone + h_bp)) && (v_count >= v_fp) && (v_count < (v_max - (v_sync_zone + v_bp))));

    assign x = h_count;
    assign y = v_count;
    assign hsync = hsync_reg;
    assign vsync = vsync_reg;
    assign p_clock = p_clock_wire;


endmodule