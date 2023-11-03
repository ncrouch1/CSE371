/*
Henri Lower 2276644
Noah Crouch
*/

/* Bit counter controller module

Inputs:
	A: value from datapath
	s: start signal
	clock: 50 MHz clock
	reset: synchronous reset
	
Outputs:
	clear: Clears the data
	r_shift: Right shift of A
	incr: Increment the data
	load_a: Loads the data
	done: signal that operation is complete
	
*/

module bitcounter_controller(A, s, clock, reset, clear, r_shift, incr, load_a, done);
	input logic [7:0] A;
	input logic s, clock, reset;
	output logic clear, r_shift, incr, load_a, done;
	
	// States and definitions 
	enum {s_idle, s_1, s_2} ps, ns;
	
	// Control signals
	assign clear 	= (ps == s_idle);
	assign r_shift = (ps == s_1);
	assign done 	= (ps == s_2);
	assign load_a 	= (ps == s_idle) & (s == 0);
	assign incr 	= (ps == s_1) 	  & (A != 8'b0) & (A[0] == 1'b1);
			
	// next state logic
	always_comb
		case(ps)
			s_idle:  ns = s ? s_1 : s_idle;
			s_1:     ns = (A == 8'b0) ? s_2 : s_1;
			s_2:     ns = s ? s_2 : s_idle;
			default: ns = s_idle;
		endcase
		
	// Clock and reset
	always_ff @(posedge clock)
		if (reset)
			ps <= s_idle;
		else 
			ps <= ns;
	
endmodule
	
module bitcounter_controller_tb();
	// port definitions
	logic [7:0] A;
	logic s, clock, reset;
	logic clear, r_shift, incr, load_a, done;
	
	// simulated clock
	parameter T = 100; // 50 MHz when divided by 2
	initial begin
		clock <= 0;
		forever #(T/2) clock <= ~clock;
	end 
	
	bitcounter_controller dut (.*);
	
	initial begin
		#2 reset <= 1; @(posedge clock);
		#2 reset <= 0; @(posedge clock);
		
		A <= 8'b01010101;
		s <= 0; @(posedge clock); // s_idle to s_idle
		s <= 1; @(posedge clock); // s_idle to s_1
		#2; 							  // s_1 	to s_1
		
		A <= 8'b0;
		#2								  // s_1		to s_2
		#2								  // s_2		to s_2
		s <= 0; @(posedge clock); // s_2		to s_idle
		
		$stop; // end the simulation
	end
endmodule 