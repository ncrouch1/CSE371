module enter_exit_handler_tb();

	// define signals
	logic clk, reset;
	logic [4:0] counterstate;
	logic [6:0] HEX0, HEX1;
	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	enter_exit_handler dut (.clk(clk), .reset(reset), .counterstate(counterstate), .HEX0(HEX0), .HEX1(HEX1));
	
	// define simulated clock
	initial begin
		clk <= 0;
		forever	#(T/2)	clk <= ~clk;
	end  // initial clock
	
	initial begin
		reset <= 1;  						@(posedge clk);
		counterstate <= 0; 	
		reset <= 0;  						@(posedge clk);
		for (int i = 0; i < 15; i++) begin
			counterstate++;				@(posedge clk);
		end
		$stop;
	end
	
endmodule  // enter_exit_handler_tb
