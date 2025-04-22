// ----------------------------------------
// ----------------------------------------
// Display timing for StarSoC game design
// hdmi_timing.sv
// Justin Coppola
// 04/22/2025
// ----------------------------------------
// ----------------------------------------

module hdmi_timing(
    input clk;
    input reset;
    output [9:0] x,y;            // Current pixel
    output hsync, vsync;        // New line, frame
    output video_on;            // Indicate when in visible area
    output p_clock;             // Sync game logic to display 
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

// Clock generation
reg [1:0] p_clock_reg;
wire p_clock_wire;

always @posedge(clk or reset)
    if (reset)
        p_clock_reg <= 0;
    else
        p_clock_reg <= p_clock_reg + 1;

assign p_clock_wire <= p_clock_reg[0];


// Registers (two each to account for buffering)
reg [9:0] h_count, h_count_next;
reg [9:0] v_count, v_count_next;

reg hsync_reg, hsync_next;
reg vsync_reg, vsync_next;


// Next value and reset logic running on main clock
always @posedge(clk or reset)
    if (reset) begin
        h_count = 0;
        v_count = 0;
        hsync_reg = 0;
        vsync_reg = 0;
    end else begin
        h_count <= h_count_next;
        v_count <= v_count_next;
        hsync_reg <= hsync_next;
        vsync_reg <= vsync_next;
    end


always @posedge(clk or reset)
    if (reset) begin                          // If reset is high
        h_count = 0;
        v_count = 0;
    end else if (h_count < h_max)           // If h is within bounds
        h_count = h_count + 1;
    else begin                               // If h is out of bounds
        if (v_count < v_max)            // If h is out of bounds and v is in bounds
            h_count = 0;
            v_count = v_count + 1;
        else                            // if h and v are out of bounds
            h_count = 0;
            v_count = 0;
    end

