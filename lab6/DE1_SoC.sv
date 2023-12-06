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
 *   
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	
	// Divided clock so output is visible
	logic clk;
	logic [6:0] divided_clocks = 0;
	always_ff @(posedge CLOCK_50) begin
		divided_clocks <= divided_clocks + 7'd1;
	end
	assign clk = divided_clocks[5];
	
	logic done, reset, rreset;
	
	tic_tac_toe game (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, clk, reset);
	
	always_ff @(posedge CLOCK_50) begin
		rreset <= ~KEY[0];
		reset  <= rreset;
	end
    
endmodule  // DE1_SoC