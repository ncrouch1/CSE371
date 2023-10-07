/* Top-level module for LandsLand hardware connections to implement the parking lot system.*/

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);

	input  logic		 CLOCK_50;	// 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	inout  logic [35:0] V_GPIO;	// expansion header 0 (LabsLand board)
	logic Enter, Exit;
	
	photoSensor psensor (.Clk(~V_GPIO[3]), .Rst(~V_GPIO[0]), .Sensor(V_GPIO[6:5]), .Enter(Enter), .Exit(Exit), .HEX0(HEX0), .HEX1(HEX1)
	, .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
	
	assign LEDR[9] = Enter;
	assign LEDR[8] = Exit;
	
	assign LEDR[7:0] = 0;

endmodule

module DE1_SoC_tb();

	// define signals
	logic	clk;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [35:0] V_GPIO
	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	DE1_SoC dut (.clk, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, .V_GPIO);
	
	// define simulated clock
	initial begin
		clk <= 0;
		forever	#(T/2)	clk <= ~clk;
	end  // initial clock
	
	initial begin
		SW[9] <= 1; reset <= 1; 	@(posedge clk);
		SW[9] <= 0; reset <= 0;	@(posedge clk);
		for (int i = 0; i < 20; i++) begin
			SW[1:0] 	<=  2'b10; @(posedge clk);
			SW[1:0] 	<=  2'b11; @(posedge clk);
			SW[1:0] 	<=  2'b01; @(posedge clk);
			SW[1:0]  <=  2'b00; @(posedge clk);
		end
		for (int i = 0; i < 20; i++) begin
			SW[1:0] 	<=  2'b01; @(posedge clk);
			SW[1:0] 	<=  2'b11; @(posedge clk);
			SW[1:0] 	<=  2'b10; @(posedge clk);
			SW[1:0] 	<=  2'b00; @(posedge clk);
		end

		$stop;
	end
endmodule  // DE1_SoC_tb
