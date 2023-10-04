/* testbench for the DE1_SoC */
module PhotoSensor_tb();

	// define signals
	logic	clk, reset;
	logic [9:0] SW;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	//logic [35:0] V_GPIO;
	logic 		Enter, Exit;

	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	photoSensor dut (.clk(clk), .Rst(reset), .Sensor(SW[1:0]), .Enter(Enter), .Exit(Exit));
	
	// define simulated clock
	initial begin
		clk <= 0;
		forever	#(T/2)	clk <= ~clk;
	end  // initial clock
	
	initial begin
		SW[9] 	<= 1; 		repeat(10)	@(posedge clk);
		SW[9] 	<=0;
		SW[1:0] 	<=  2'b01; 	repeat(10)	@(posedge clk);
		SW[1:0] 	<=  2'b11; 	repeat(10)	@(posedge clk);
		SW[1:0] 	<=  2'b10; 	repeat(10)	@(posedge clk);
		SW[1:0] 	<=  2'b00; 	repeat(10)	@(posedge clk);
		SW[1:0] 	<=  2'b10;	repeat(10)	@(posedge clk);
		SW[1:0] 	<=  2'b11; 	repeat(10)	@(posedge clk);
		SW[1:0] 	<=  2'b01; 	repeat(10)	@(posedge clk);
		$stop;
	end
	
endmodule  // DE1_SoC_tb
