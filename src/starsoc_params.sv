// ----------------------------------------
// ----------------------------------------
// Game parameters for starsoc
// starsoc_params.sv
// Justin Coppola
// 04/23/2025
// ----------------------------------------
// ----------------------------------------

package starsoc_params;

    // -----------------------------------------------------------
    // Parameters based on VGA standards for 640x480 @60hz display
    // -----------------------------------------------------------

    // Horizontal parameters
    parameter h_visible = 640;                                      // 0,0 to 639,479
    parameter h_fp = 16;                                            // 640,480 to 655,489
    parameter h_sync_zone = 96;                                     // 656,490 to 751,491
    parameter h_bp = 48;                                            // 752,492 to 799,524
    parameter h_max = (h_visible + h_fp + h_sync_zone + h_bp)-1;    // 799

    // Vertical parameters
    parameter v_visible = 480;
    parameter v_fp = 10;
    parameter v_sync_zone = 2;
    parameter v_bp = 33;
    parameter v_max = (v_visible + v_fp + v_sync_zone + v_bp)-1;    // 524

    // Useful visible parameters
    parameter int visible_origin_x = 0;
    parameter int visible_origin_y = 0;

    parameter int player_x = 320;
    parameter int player_y = 240;


    // ----------------------------------------
    // Color constants (4-bit R/G/B → 12-bit RGB)
    // ----------------------------------------
    parameter logic [11:0] COLOR_BLACK = 12'h000;
    parameter logic [11:0] COLOR_WHITE = 12'hFFF;
    parameter logic [11:0] COLOR_RED   = 12'hF00;
    parameter logic [11:0] COLOR_GREEN = 12'h0F0;
    parameter logic [11:0] COLOR_BLUE  = 12'h00F;
    parameter logic [11:0] COLOR_YELLOW = 12'hFF0;
    parameter logic [11:0] COLOR_CYAN   = 12'h0FF;
    parameter logic [11:0] COLOR_MAGENTA = 12'hF0F;


endpackage