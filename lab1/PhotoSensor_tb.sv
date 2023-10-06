module PhotoSensor_tb();

	// define signals
	logic	clk, reset;
	logic [9:0] SW;
	logic [6:0] HEX0, HEX1;
	logic 		Enter, Exit;

	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	photoSensor dut (.Clk(clk), .Rst(reset), .Sensor(SW[1:0]), .Enter(Enter), .Exit(Exit), .HEX0(HEX0), .HEX1(HEX1));
	
	// define simulated clock
	initial begin
		clk <= 0;
		forever #(T/2) clk <= ~clk;
	end  // initial clock
	
	initial begin
		SW[9] <= 1; reset <= 1; 	@(posedge clk);
		SW[9] <= 0; reset <= 0;	@(posedge clk);
		for (int i = 0; i < 10; i++) begin
			SW[1:0] 	<=  2'b01; @(posedge clk);
			SW[1:0] 	<=  2'b11; @(posedge clk);
			SW[1:0] 	<=  2'b10; @(posedge clk);
			SW[1:0] 	<=  2'b00; @(posedge clk);
			SW[1:0] 	<=  2'b10; @(posedge clk);
			SW[1:0] 	<=  2'b11; @(posedge clk);
			SW[1:0] 	<=  2'b01; @(posedge clk);
			SW[1:0]  <=  2'b00; @(posedge clk);
		end
		$stop;
	end
	
endmodule  // DE1_SoC_tb