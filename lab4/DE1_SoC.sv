// Module to implement lab 4

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR);
	// port declarations
	input  logic CLOCK_50;  // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;  // active low
	input  logic [3:0] KEY;
	input  logic [9:0] SW;
	output logic [9:0] LEDR;
	
	// logic for task 1
	logic reset, start, s, done;
	logic [7:0] A; // 8-bit input
	assign A = SW[7:0]; // A is controlled by switches 0-7
	
	// Synchronous reset, using two DFF's to handle metastability
	always_ff @(posedge CLOCK_50) begin
		reset <= ~KEY[0];
		s <= ~KEY[3];
		start <= s;
	end 

	// bit counter logic
	logic [3:0] result; 
	
	bitcounter task1 (
		.input_a(A), 
		.s(s), 
		.clock(CLOCK_50), 
		.reset(reset), 
		.result(result), 
		.done(done)
		);
		
endmodule 