/* Top-level module for LandsLand hardware connections to implement the parking lot system.*/

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);

	input  logic		 CLOCK_50;	// 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	inout  logic [35:0] V_GPIO;	// expansion header 0 (LabsLand board)
	logic Enter, Exit;
	
	photoSensor psensor (.Clk(~V_GPIO[0]), .Rst(~V_GPIO[3]), .Sensor(V_GPIO[6:5]), .Enter(Enter), .Exit(Exit), .HEX0(HEX0), .HEX1(HEX1));
	
	assign LEDR[9] = Enter;
	assign LEDR[7] = Exit;
	
	assign LEDR[0] = ~V_GPIO[0];
	assign LEDR[1] = ~V_GPIO[3];
	assign LEDR[6:2] = 0;
	assign LEDR[8] = 0;
	
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	
endmodule  // DE1_SoC
