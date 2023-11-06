/*
Henri Lower 2276644
Noah Crouch 2078812
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
	bitcounter_datapath   task1_datapath   (
        .A(A), 
        .clock(clock), 
        .result(result), 
        .input_a(input_a), 
        .clear(clear), 
        .r_shift(r_shift), 
        .incr(incr), 
        .load_a(load_a)
    );
	
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
		
		// Set user input
		input_a <= 8'b11111111; s <= 0; @(posedge clock); // Load
		
		reset <= 1; @(posedge clock);
		reset <= 0; @(posedge clock);
				
		// Test all states
		s		<= 1; @(posedge clock); // s_idle to s_1
		while (~done) begin
			@(posedge clock);
		end
		$stop;
	end
endmodule // bitcounter_tb