// FSM for 0 - 9 digit counter with clock and reset.
// inputs: incr and decr tick counter up and down respectivley
// outputs: carryout sends 2bit signal to next decimal value to incr or decr
// 			count is the current decimal value of this counter

module counter(clk, reset, incr, decr, carryOut, count);
	input  logic  clk, reset;
	input  logic  incr, decr; 	  // Use previous digit's carryOut 
	output logic [1:0] carryOut; // [neg, pos]
	output logic [3:0] count;
	
	// State Variables
	enum { s0, s1, s2, s3, s4, s5, s6 ,s7 ,s8, s9 } ps, ns;
	
	// Next State Logic
	always_comb begin
		case (ps)
			s0: begin
				if 		(incr)		ns = s1;
				else if 	(decr)		ns = s9;
				else						ns = s0;
			end
			
			s1: begin
				if 		(incr)		ns = s2;
				else if 	(decr)		ns = s0;
				else						ns = s1;
			end
			
			s2: begin
				if 		(incr)		ns = s3;
				else if 	(decr)		ns = s1;
				else						ns = s2;
			end
			
			s3: begin
				if 		(incr)		ns = s4;
				else if 	(decr)		ns = s2;
				else						ns = s3;
			end
			
			s4: begin
				if 		(incr)		ns = s5;
				else if 	(decr)		ns = s3;
				else						ns = s4;
			end
			
			s5: begin
				if 		(incr)		ns = s6;
				else if 	(decr)		ns = s4;
				else						ns = s5;
			end
			
			s6: begin
				if 		(incr)		ns = s7;
				else if 	(decr)		ns = s5;
				else						ns = s6;
			end
			
			s7: begin
				if 		(incr)		ns = s8;
				else if 	(decr)		ns = s6;
				else						ns = s7;
			end
			
			s8: begin
				if 		(incr)		ns = s9;
				else if 	(decr)		ns = s7;
				else						ns = s8;
			end
			
			s9: begin
				if 		(incr)		ns = s0;
				else if 	(decr)		ns = s8;
				else						ns = s9;
			end
			
			default:						ns = s0;
		endcase
	end // always_comb
	
	// Sequential Logic
	always_ff @(posedge clk) begin
		if (reset)
			ps <= s0;
		else
			ps <= ns;
	end // always_ff
	
	// Output Logic
	always_comb begin
		carryOut[0] = ((incr) & (ps == s9)); // signal for next digit to cycle up
		carryOut[1] = ((decr) & (ps == s0)); // signal for next digit to cylce down
		
		// Hex Display depending on state
		if 	  (ps == s0) 		count = s0;
		else if (ps == s1) 		count = s1;
		else if (ps == s2) 		count = s2;
		else if (ps == s3) 		count = s3;
		else if (ps == s4) 		count = s4;
		else if (ps == s5) 		count = s5;
		else if (ps == s6) 		count = s6;
		else if (ps == s7) 		count = s7;
		else if (ps == s8) 		count = s8;
		else 	  				 		count = s9;
		
	end // always_comb
endmodule // counter

module counter_tb();

	// define signals
	logic clk, reset;
	logic incr, decr;
	logic [1:0] carryOut;
	logic [3:0] count;
	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	counter dut (.clk(clk), .reset(reset), .incr(incr), .decr(decr), .carryOut(carryOut), .count(count));
	
	// define simulated clock
	initial begin
		clk <= 0;
		forever	#(T/2)	clk <= ~clk;
	end  // initial clock
	
	initial begin
		reset <= 1; incr = 0; decr = 0;		@(posedge clk);
		reset <= 0;  								@(posedge clk);
		
		// Loop through incr
		for (int i = 0; i < 16; i++) begin
			incr <= 1;								@(posedge clk);
			incr <= 0;								@(posedge clk);
		end
		
		// Loop through decr
		for (int i = 0; i < 16; i++) begin
			decr <= 1;								@(posedge clk);
			decr <= 0;								@(posedge clk);
		end
		
		// Mid Count Reset
		incr  <= 1;					repeat(5)	@(posedge clk);
		reset <= 1; incr <= 1;					@(posedge clk);
		reset <= 0;
		
		// Alternate incr and decr
		incr  <= 1;					repeat(5)	@(posedge clk);
		incr  <= 0; decr <= 1;	repeat(5)	@(posedge clk);
	$stop;
	end
	
endmodule  // counter_tb
	
		
		
		
	
	
	