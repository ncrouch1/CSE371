module photoSensor (Clk, Rst, Sensor, Enter, Exit, HEX0, HEX1);
	input logic  Clk, Rst;
	input logic  [1:0] Sensor;
	output logic [6:0] HEX0, HEX1;
	output logic Enter, Exit;
	logic [4:0] counter;
	
	enter_exit_handler dut (.clk(Clk), .reset(Rst), .counterstate(counter), .HEX0(HEX0), .HEX1(HEX1));
	
	enum { empty, oBlocked, iBlocked, both} ps, ns;
	
	always_comb begin
		case(ps)
			empty: begin
				if (Sensor == 2'b11)			ns = both;
				else if (Sensor == 2'b01)	ns = iBlocked;
				else if (Sensor == 2'b10)	ns = oBlocked;
				else								ns = empty;
			end
			
			oBlocked: begin
				if (Sensor == 2'b11)			ns = both;
				else if (Sensor == 2'b01)	ns = iBlocked;
				else if (Sensor == 2'b10)	ns = oBlocked;
				else								ns = empty;
			end
			
			iBlocked: begin
				if (Sensor == 2'b11)			ns = both;
				else if (Sensor == 2'b01)	ns = iBlocked;
				else if (Sensor == 2'b10)	ns = oBlocked;
				else								ns = empty;
			end
			
			both: begin
				if (Sensor == 2'b11)			ns = both;
				else if (Sensor == 2'b01)	ns = iBlocked;
				else if (Sensor == 2'b10)	ns = oBlocked;
				else								ns = empty;
			end
			
			default: ns = empty;
		endcase
	end
	
	always_ff @(posedge Clk) begin
		if (Rst)
			ps <= empty;
		else
			ps <= ns;
	end
		
	always_ff @(posedge Clk) begin
		if (Rst)
			counter <= 0;
		else if ((ns == iBlocked) & (ps == both)) begin
			if (counter < 16)
				counter++;
			Enter = 1;
			Exit = 0;
		end
		
		else if ((ns == oBlocked) & (ps == both)) begin
			if (counter > 0)
				counter--;
			Enter = 0;
			Exit = 1;
		end
		
		else begin
			Enter = 0;
			Exit = 0;
		end
	end
endmodule

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