/* Top-level module for LandsLand hardware connections to implement the parking lot system.*/

module DE1_SoC (CLOCK_50, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);

	input  logic		 CLOCK_50;	// 50MHz clock
	input  logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	inout  logic [35:0] V_GPIO;	// expansion header 0 (LabsLand board)
	
	parkingLotOccupancy lab1 (.clk(CLOCK_50), .reset(GPIO_0[]), .sensors(GPIO_0[]), 
										.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));

endmodule  // DE1_SoC
