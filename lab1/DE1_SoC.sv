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
	wire [35:0] V_GPIO;
	logic [35:0] V_GPIO_in, V_GPIO_dir;

	initial begin
		V_GPIO_dir[6] = 1'b1;
		V_GPIO_dir[5] = 1'b1;
		V_GPIO_dir[0] = 1'b1;
	end
	
	genvar i;
	generate
		for (i = 0; i < 36; i++) begin : gpio
			assign V_GPIO[i] = V_GPIO_dir[i] ? V_GPIO_in[i] : 1'bZ;
		end
	endgenerate
	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	DE1_SoC dut (.CLOCK_50(clk), .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, .V_GPIO);
	
	// define simulated clock
	initial begin
		clk <= 0;
		forever	#(T/2)	clk <= ~clk;
	end  // initial clock
	
	initial begin
		V_GPIO_in[0] <= 1; @(posedge clk);
		@(posedge clk); repeat(5);
		V_GPIO_in[0] <= 0; @(posedge clk);
		for (int i = 0; i < 20; i++) begin
			V_GPIO_in[6:5] 	<=  2'b10; @(posedge clk);
			V_GPIO_in[6:5] 	<=  2'b11; @(posedge clk);
			V_GPIO_in[6:5] 	<=  2'b01; @(posedge clk);
			V_GPIO_in[6:5]  <=  2'b00; @(posedge clk);
		end
		for (int i = 0; i < 20; i++) begin
			V_GPIO_in[6:5] 	<=  2'b01; @(posedge clk);
			V_GPIO_in[6:5] 	<=  2'b11; @(posedge clk);
			V_GPIO_in[6:5] 	<=  2'b10; @(posedge clk);
			V_GPIO_in[6:5] 	<=  2'b00; @(posedge clk);
		end

		$stop;
	end
endmodule  // DE1_SoC_tb
