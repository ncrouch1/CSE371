module parkingLotOccupancy(clk, reset, sensors, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input  logic 		 clk, reset;
	input  logic [1:0] sensors;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
			 logic 	  	 enter, exit;
			 logic [4:0] count;
	
	carDetection outerInner (.clk(clk), .reset(reset), .sensors(sensors), .enter(enter), .exit(exit));
	carCounter zeroSixteen (.clk(clk), .reset(reset), .incr(enter), .decr(exit), .count(count));
	
	always_ff @(posedge clk) begin
		if (count == 5'b00000) begin 	// HEX[5:1] = "CLEAR0"
			HEX0 <= 7'b0000000;
			HEX1 <= 7'b1001110;
			HEX2 <= 7'b0001110;
			HEX3 <= 7'b1111110;
			HEX4 <= 7'b1011011;
			HEX5 <= 7'b1001111;
		end
		
		else if (count == 5'b10000) begin // HEX[5:2] = "FULL"
			HEX0 <= '0;
			HEX1 <= '0;
			HEX2 <= 7'b1000111;
			HEX3 <= 7'b0111110;
			HEX4 <= 7'b0001110;
			HEX5 <= 7'b0001110;
		end
		
		else begin	// HEX[5:3] blank and [1:0] display 1-15 count
			HEX2 <= 7'b0000000;
			HEX3 <= 7'b0000000;
			HEX4 <= 7'b0000000;
			HEX5 <= 7'b0000000;
			
			if (count == 5'b00001) begin
				HEX0 <= 7'b0000000;
				HEX1 <= 7'b1001111;
			end
			
			else if (count == 5'b00010) begin
				HEX0 <= 7'b0000000;
				HEX1 <= 7'b0010010;
			end
			
			else if (count == 5'b00011) begin
				HEX0 <= 7'b0000000;
				HEX1 <= 7'b0000110;
			end
			
			else if (count == 5'b00100) begin
				HEX0 <= 7'b000000;
				HEX1 <= 7'b1001100;
			end
			
			else if (count == 5'b00101) begin
				HEX0 <= 7'b0000000;
				HEX1 <= 7'b0100100;
			end
			
			else if (count == 5'b00110) begin
				HEX0 <= 7'b0000000;
				HEX1 <= 7'b0100000;
			end
			
			else if (count == 5'b00111) begin
				HEX0 <= 7'b0000000;
				HEX1 <= 7'b0001111;
			end
			
			else if (count == 5'b01000) begin
				HEX0 <= 7'b0000000;
				HEX1 <= 7'b0000000;
			end
			
			else if (count == 5'b01001) begin
				HEX0 <= 7'b0000000;
				HEX1 <= 7'b0000100;
			end
			
			else if (count == 5'b01010) begin
				HEX0 <= 7'b1001111;
				HEX1 <= 7'b0000000;
			end
			
			else if (count == 5'b01011) begin
				HEX0 <= 7'b1001111;
				HEX1 <= 7'b1001111;
			end
			
			else if (count == 5'b01100) begin
				HEX0 <= 7'b1001111;
				HEX1 <= 7'b0010010;
			end
			
			else if (count == 5'b01101) begin
				HEX0 <= 7'b1001111;
				HEX1 <= 7'b0000110;
			end
			
			else if (count == 5'b01110) begin
				HEX0 <= 7'b1001111;
				HEX1 <= 7'b1001100;
			end
			
			else begin
				HEX0 <= 7'b1001111;
				HEX1 <= 7'b0100100;
			end // inner if statement
		end // outer if statement
	end // always_comb
endmodule // parkingLotOccupancy

module parkingLotOccupancy_tb();

	// define signals
	logic 		clk, reset;
	logic [1:0] sensors;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic 	  	enter, exit;
	logic [4:0] count;
	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	parkingLotOccupancy dut (.clk(clk), .reset(reset), .sensors(sensors),
						.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
	
	// define simulated clock
	initial begin
		clk <= 0;
		forever	#(T/2)	clk <= ~clk;
	end  // initial clock
	
	initial begin
		reset <= 1; 						@(posedge clk);
		reset <= 0;							@(posedge clk);
		
		// Entering Test
		for (int i = 0; i < 20; i++) begin

			sensors[1:0] 	<=  2'b10; @(posedge clk);
			sensors[1:0] 	<=  2'b11; @(posedge clk);
			sensors[1:0] 	<=  2'b01; @(posedge clk);
			sensors[1:0]  	<=  2'b00; @(posedge clk);
		end // for loop - Enter sim run 20 times
		
		// Exiting Test
		for (int i = 0; i < 20; i++) begin
			sensors[1:0] 	<=  2'b01; @(posedge clk);
			sensors[1:0] 	<=  2'b11; @(posedge clk);
			sensors[1:0] 	<=  2'b10; @(posedge clk);
			sensors[1:0] 	<=  2'b00; @(posedge clk);
		end // for loop - Exit sim run 20 times
		
		// alternating Test 
		for (int i = 0; i < 5; i++) begin
			sensors[1:0] 	<=  2'b10; @(posedge clk);
			sensors[1:0] 	<=  2'b11; @(posedge clk);
			sensors[1:0] 	<=  2'b01; @(posedge clk);
			sensors[1:0]  	<=  2'b00; @(posedge clk);
			
			sensors[1:0] 	<=  2'b10; @(posedge clk);
			sensors[1:0] 	<=  2'b11; @(posedge clk);
			sensors[1:0] 	<=  2'b01; @(posedge clk);
			sensors[1:0]  	<=  2'b00; @(posedge clk);
			
			sensors[1:0] 	<=  2'b01; @(posedge clk);
			sensors[1:0] 	<=  2'b11; @(posedge clk);
			sensors[1:0] 	<=  2'b10; @(posedge clk);
			sensors[1:0] 	<=  2'b00; @(posedge clk);
		end // for loop - (Enter, Enter, Exit)x5
		$stop;
	end
	
endmodule  // DE1_SoC_tb