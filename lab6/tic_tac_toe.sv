module tic_tac_toe (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, clk, reset,
                    VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	// port declarations
	input logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input logic clk, reset;

	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	logic start, button, drawing, player, holding, gameover, valid, done, line_draw_done;
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
		.reset(KEY[0]), 
		.gamestate_next(gamestate_next),  
		.player(player), 
		.done(done),
		.start(start),
		.line_draw_done(line_draw_done),
		.VGA_R			(VGA_R), 
		.VGA_G			(VGA_G), 
		.VGA_B			(VGA_B), 
		.VGA_CLK		(VGA_CLK), 
		.VGA_HS			(VGA_HS), 
		.VGA_VS			(VGA_VS),
		.VGA_BLANK_N	(VGA_BLANK_N), 
		.VGA_SYNC_N		(VGA_SYNC_N)
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
	
endmodule 