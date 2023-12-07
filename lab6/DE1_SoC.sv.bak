/* Top level module of the FPGA that takes the onboard resources 
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
	
	logic [10:0] x0, y0, x1, y1, x, y;
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(reset), 
		.x, 
		.y,
		.pixel_color	(done ? 1'b0 : 1'b1), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N)
		);
				
	logic done;
	
	// Divided clock so output is visible
	logic clk;
	logic [6:0] divided_clocks = 0;
	always_ff @(posedge CLOCK_50) begin
		divided_clocks <= divided_clocks + 7'd1;
	end
	assign clk = divided_clocks[5];

	logic start, button, drawing, player, holding, gameover, valid, line_draw_done;
	logic [9:0] metaSW;
	logic [1:0] gamestate_next [9:0];
	logic [1:0] gamestate [9:0];
	
	assign start = ~KEY[3];
	
    always_ff @(posedge clk) begin
        clk_input <= clk;
        clk_player <= clk;
        clk_screen <= clk; 
    end

	
	input_handler in_h(
		.clk(clk_input), 
		.reset(reset), 
		.SW(SW), 
		.button(button), 
		.drawing(drawing), 
		.player(player), 
		.metaSW(metaSW), 
		.holding(holding), 
		.gameover(gameover),
		.valid(valid),
		.line_draw_done(line_draw_done)
	);
		
	player_handler pl_h(
		.HEX0(HEX0), 
		.HEX1(HEX1), 
		.HEX2(HEX2), 
		.HEX3(HEX3), 
		.HEX4(HEX4), 
		.HEX5(HEX5), 
		.player(player), 
		.clk(clk_player)
	);
		
	screen_handler scr_h(
		.clk(clk_screen), 
		.reset(reset), 
		.gamestate_next(gamestate_next),  
		.player(player), 
		.done(done),
		.start(start),
		.line_draw_done(line_draw_done),
		.x,
		.y
	);
		
	set_move sm (
		.metaSW(metaSW), 
		.gamestate(gamestate), 
		.player(player), 
		.enable(enable),
		.gamestate_next(gamestate_next)
	);
		
	validate_move vm (
		metaSW, 
		gamestate, 
		valid
	);

endmodule  // DE1_SoC
