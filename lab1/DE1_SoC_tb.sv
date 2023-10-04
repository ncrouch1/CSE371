module DE1_SoC_tb();

	// define signals
	logic	CLOCK_50;
	logic SW[1:0];
	logic incr;
	logic decr;
	logic [35:0] V_GPIO;
	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	DE1_SoC dut (.CLOCK_50(CLOCK_50), .SW(SW), .V_GPIO(V_GPIO), .incr(incr), .decr(decr));
	
	// define simulated clock
	initial begin
		CLOCK_50 <= 0;
		forever	#(T/2)	CLOCK_50 <= ~CLOCK_50;
	end  // initial clock
	
	initial begin
		SW[1:0] = 2'b00; #10;
		SW[1:0] = 2'b01; #10;
		SW[1:0] = 2'b11; #10;
		SW[1:0] = 2'b00; #10;
		SW[1:0] = 2'b10; #10;
		SW[1:0] = 2'b11; #10;
	end
	
endmodule  // DE1_SoC_tb