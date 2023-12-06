module tic_tac_toe (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, clk, reset);
	// port declarations
	input logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input logic clk, reset;
	
	logic start, button, drawing, player, holding, gameover, valid, done, line_drawer_done;
	logic [9:0] metaSW;
	logic [1:0] gamestate_next [9:0];
	logic [1:0] gamestate [9:0];
	
	assign start = ~KEY[3];
	
	
	input_handler in_h(
		clk, 
		reset, 
		SW, 
		button, 
		drawing, 
		player, 
		metaSW, 
		holding, 
		gameover,
		valid,
		line_drawer_done
	);
		
	player_handler pl_h(
		HEX0, 
		HEX1, 
		HEX2, 
		HEX3, 
		HEX4, 
		HEX5, 
		player, 
		clk,
		valid
	);
		
	screen_handler scr_h(
		.clock(clk), 
		.reset(KEY[0]), 
		.gamestate_next(gamestate_next), 
		.valid(valid), 
		.player(player), 
		.done(done),
		.start(start),
		.line_drawer_done(line_drawer_done)
	);
		
	set_move sm (
		.metaSW(metaSW), 
		.gamestate(gamestate), 
		.valid(valid), 
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