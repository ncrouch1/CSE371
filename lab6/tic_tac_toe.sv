module tic_tac_toe (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, clk, reset);
	// port declarations
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic clk, reset;
	
	logic button, drawing, player, holding, gameover;
	logic [9:0] metaSW;
	logic [9:0] gamestate_next [1:0];
	
	
	input_handler(clk, reset, SW, button, drawing, player, metaSW, holding, gameover);
	RAM_module();
	player_handler(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, player);
	screen_handler(gamestate_next, player, valid);
	set_move(metaSW, gamestate, valid, player, gamestate_next);
	validate_move(metaSW, gamestate, valid);
	
endmodule 