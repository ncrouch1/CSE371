/* 
Noah Crouch 2078812
Henri Lower   2276644
EE/CSE 371
Lab 6 Report
12/08/2023

Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	logic reset, button, drawing, valid, drawing_done;
    logic player, enable_validation, enable_setting, enable_ram, update_state, lock_input;
    logic enable_drawing;
    logic set;
    logic [87:0] data;
    
    logic start, holding, gameover, done;
	logic [9:0] metaSW;
	logic [1:0] gamestate_next [9:0];
	logic [1:0] gamestate [9:0];
	logic [10:0] x, y;
	
	// Divided clock so output is visible
	logic clk, clk_input, clk_player, clk_screen;
	logic [6:0] divided_clocks = 0;
	always_ff @(posedge CLOCK_50) begin
		divided_clocks <= divided_clocks + 7'd1;
	end
	
	assign clk = divided_clocks[5];
	assign start = ~KEY[3];
	assign reset = ~KEY[0];
	assign HEX1 = 7'b0001100;
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(reset), 
		.x					(x), 
		.y					(y),
		.pixel_color	(done ? 1'b0 : 1'b1), 
		.pixel_write	(1'b1),
		.VGA_R			(VGA_R), 
		.VGA_G			(VGA_G), 
		.VGA_B			(VGA_B), 
		.VGA_CLK		(VGA_CLK), 
		.VGA_HS			(VGA_HS), 
		.VGA_VS			(VGA_VS),
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N)
		);
				
    always_ff @(posedge clk) begin
        clk_input <= clk;
        clk_player <= clk;
        clk_screen <= clk; 
    end

	
	input_controller in_c (
	    .clock(clk_input),
	    .reset(reset),
	    .button(start),
	    .drawing(drawing),
	    .valid(valid),
	    .drawing_done(drawing_done),
	    .enable_validation(enable_validation),
	    .enable_setting(enable_setting),
	    .enable_ram(enable_ram),
	    .enable_drawing(enable_drawing),
	    .lock_input(lock_input),
	    .player(player),
	    .update_state(update_state)
	);
	
	input_datapath in_d(
	    .clock(clk),
	    .player(player),
	    .enable_validation(enable_validation),
	    .enable_setting(enable_setting),
	    .enable_ram(enable_ram),
	    .update_state(update_state),
	    .lock_input(lock_input),
	    .valid(valid),
	    .set(set),
	    .SW(SW),
	    .data(data)
	);
		
	screen_handler scr_h(
		.clk(clk_screen), 
		.reset(reset), 
		.player(player), 
		.done(done),
		.start(start),
		.drawing_done(drawing_done),
		.x(x),
		.y(y),
		.data(data),
		.drawing(drawing)
	);
	
	always_ff @(posedge clk) begin
        HEX0 = (player) ? 7'b1111100 : 7'b1000000;
        LEDR[0] = start;
        LEDR[1] = drawing;
        LEDR[2] = valid;
        LEDR[3] = drawing_done;
        LEDR[4] = player;
        LEDR[5] = enable_validation;
        LEDR[6] = enable_setting;
        LEDR[7] = enable_ram;
        LEDR[8] = update_state;
        LEDR[9] = lock_input;
    end

endmodule  // DE1_SoC

module DE1_SoC_tb;

    // Inputs
    reg [3:0] KEY;
    reg [9:0] SW;
    reg CLOCK_50;

    // Outputs
    reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    reg [9:0] LEDR;
    reg [7:0] VGA_R, VGA_G, VGA_B;
    reg VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS;

    // Instantiate the module under test
    DE1_SoC dut (
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
        .LEDR(LEDR), .KEY(KEY), .SW(SW), .CLOCK_50(CLOCK_50),
        .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
        .VGA_BLANK_N(VGA_BLANK_N), .VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS),
        .VGA_SYNC_N(VGA_SYNC_N), .VGA_VS(VGA_VS)
    );

    // Clock generation
    always #5 CLOCK_50 = ~CLOCK_50;

    // Initial stimulus
    initial begin
        // Initialize inputs
        KEY = 4'b0000;
        SW = 10'b0000000000;
        CLOCK_50 = 0;

        // Apply stimulus
        #10 KEY = 4'b0011;  // Assuming KEY[3] controls "start"
        #100 KEY = 4'b0000;
        #100 SW = 10'b1010101010;  // Update switches

        // Run for some time
        #10000 $finish;
    end

    // Monitor outputs
    always_ff @(posedge CLOCK_50) begin
        $display("VGA_R = %h, VGA_G = %h, VGA_B = %h", VGA_R, VGA_G, VGA_B);
        // Add other signals as needed
    end

endmodule

