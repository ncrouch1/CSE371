/*
Henri Lower 2276644
Noah Crouch 
*/

/* Top level module for bit counter

Inputs:
	input_a: 8-bit user input
	s: start signal
	clock: 50 MHz clock
	reset: synchronous reset

Outputs:
	result: count of 1's found from the input
	done: signal that operation is complete

*/

module bitcounter (input_a, s, clock, reset, result, done, enable);

	// port declarations
	input logic [7:0] input_a;
	input logic s, clock, reset, enable;
	output logic [3:0] result;
	output logic done;
	
	// logic for other modules
	logic [7:0] A;
	logic clear, r_shift, incr, load_a;

	// Instantiate other modules
	bitcounter_controller task1_controller (
					.A(A), 
					.s(s), 
					.clock(clock), 
					.reset(reset), 
					.clear(clear), 
					.r_shift(r_shift), 
					.incr(incr), 
					.load_a(load_a), 
					.done(done),
					.enable(enable)
					);
	bitcounter_datapath   task1_datapath   (.*);
	
endmodule // bitcounter

// Testbench for bitcounter
module bitcounter_tb();
	
	// port declarations
	logic [7:0] input_a;
	logic s, clock, reset, done, enable;
	logic [3:0] result;
	
	// simulated clock
	parameter T = 100; // 50 MHz when divided by 2
	initial begin
		clock <= 0;
		forever #(T/2) clock <= ~clock;
	end 
	
	// instantiate module
	bitcounter dut (.*);
	
	initial begin 
		// Toggle reset
		enable <= 1;
		reset <= 1; @(posedge clock);
		reset <= 0; @(posedge clock);
		
		// Set user input
		input_a <= 8'b01010101;
		
		// Test all states
		s 		<= 0; @(posedge clock); // Load input
		s		<= 1; @(posedge clock); // s_idle to s_1	
		$stop;
	end
endmodule // bitcounter_tb