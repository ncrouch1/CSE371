/* Top-level module for LandsLand hardware connections to implement the parking lot system.*/

module DE1_SoC (CLOCK_50, SW, incr, decr);

	input  logic		 CLOCK_50;	// 50MHz clock
	input  logic [1:0] SW;
	output logic incr, decr;
	
	logic [1:0] flags;
	
	/*
		State progressions should be combinational logic
		since we don't really care if the states change 
		synchronously.
		
		But the exit and enter signals need to be high 
		for one clock cycle when triggered
	*/
	always_latch 
		begin
			case (SW)
				2'b00: flags = 2'b00;
				2'b01: begin
					if (flags == 2'b00) begin
						flags = 2'b01;
					end
				end
				2'b10: begin
					if (flags == 2'b00) begin
						flags = 2'b10;
					end
				end
				2'b11: ;			
			endcase
		end
		
	always_ff @(posedge CLOCK_50) begin
		if (flags == 2'b10 && SW[1:0] == 2'b11 && ~incr) begin
			incr <= 1;
		end
		else if (flags == 2'b01 && SW[1:0] == 2'b11 && ~decr) begin
			decr <= 1;
		end
		else begin
			incr <= 0;
			decr <= 0;
		end
	end
	

	

endmodule  // DE1_SoC

module DE1_SoC_tb();

	// define signals
	logic	CLOCK_50;
	logic SW[1:0];
	logic incr;
	logic decr;
	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	DE1_SoC dut (.CLOCK_50(CLOCK_50), .SW(SW), .incr(incr), .decr(decr));
	
	// define simulated clock
	initial begin
		CLOCK_50 <= 0;
		forever	#(T/2)	CLOCK_50 <= ~CLOCK_50;
	end  // initial clock
	
	initial begin
		SW[1:0] <= 2'b00; #10;
		SW[1:0] <= 2'b01; #10;
		SW[1:0] <= 2'b11; #10;
		SW[1:0] <= 2'b00; #10;
		SW[1:0] <= 2'b10; #10;
		SW[1:0] <= 2'b11; #10;
	end
	
endmodule  // DE1_SoC_tb
