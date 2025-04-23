// ----------------------------------------
// ----------------------------------------
// Game parameters for starsoc
// starsoc_params.sv
// Justin Coppola
// 04/23/2025
// ----------------------------------------
// ----------------------------------------

package starsoc_params;

    // --------------------------------------------------
    // Parameters based on VGA standards for 640x480 @60hz display
    // --------------------------------------------------

    // Horizontal parameters
    parameter h_visible = 640;
    parameter h_fp = 16;
    parameter h_sync_zone = 96;
    parameter h_bp = 48;
    parameter h_max = (h_visible + h_fp + h_sync_zone + h_bp)-1;

    // Vertical parameters
    parameter v_visible = 480;
    parameter v_fp = 10;
    parameter v_sync_zone = 2;
    parameter v_bp = 33;
    parameter v_max = (v_visible + v_fp + v_sync_zone + v_bp)-1;

    // Useful visible parameters
    parameter int visible_origin_x = ((h_visible/2) + h_fp)-1;
    parameter int visible_origin_y = ((v_visible/2) + v_fp)-1;


    // --------------------------------------------------
    // Color constants (4-bit R/G/B → 12-bit RGB)
    // --------------------------------------------------
    parameter logic [11:0] COLOR_BLACK = 12'h000;
    parameter logic [11:0] COLOR_WHITE = 12'hFFF;
    parameter logic [11:0] COLOR_RED   = 12'hF00;
    parameter logic [11:0] COLOR_GREEN = 12'h0F0;
    parameter logic [11:0] COLOR_BLUE  = 12'h00F;
    parameter logic [11:0] COLOR_YELLOW = 12'hFF0;
    parameter logic [11:0] COLOR_CYAN   = 12'h0FF;
    parameter logic [11:0] COLOR_MAGENTA = 12'hF0F;


endpackage