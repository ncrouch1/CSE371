module DE1_SoC(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	inout  logic [35:0] V_GPIO;	// expansion header 0 (LabsLand board)
	logic [4:0] counter;
	logic [6:0] HEX2valid, HEX3valid;
	logic [2:0] read, read1, read2;
	int wrtensplace;
	int wronesplace;
	int rdtensplace;
	int rdonesplace;
	
	// turn of all LEDs
	assign LEDR[9:0] = 0;

	// counter for ram2 read address
   always_ff @(posedge ~V_GPIO[0]) begin
		if (V_GPIO[3] | V_GPIO[14]) begin
			counter = 0;
		end
		else if (counter == 32) begin
			counter = 0;
		end
		else begin
			counter++;
		end
   end
	
	task2 ram1 (.address(V_GPIO[13:9]), .enable(~V_GPIO[14]), .clock(V_GPIO[0]), .datain(V_GPIO[8:6]), .wren(V_GPIO[5]), .dataout(read1));
	task3 ram2 (.clock(~V_GPIO[0]), .enable(V_GPIO[14]), .reset(~V_GPIO[3]), .datain(V_GPIO[8:6]), .rdaddress(counter), .wraddress(V_GPIO[13:9]), .wren(V_GPIO[5]), .dataout(read2));

	// splits 32-bit binary two 4-bit hex
	assign wrtensplace = V_GPIO[13:9] / 10;
	assign wronesplace = V_GPIO[13:9] % 10;
	assign rdtensplace = counter / 10;
	assign rdonesplace = counter % 10;
	
	// converts 4-bit hex into 7-segment HEX display for each HEX
	seg7 hex5 (.hex(wrtensplace), .leds(HEX5)); 			// write address [1]
	seg7 hex4 (.hex(wronesplace), .leds(HEX4)); 			// write address [0]
	seg7 hex3 (.hex(rdtensplace), .leds(HEX3valid));	// read address  [1]
	seg7 hex2 (.hex(rdonesplace), .leds(HEX2valid));	// read address  [0]
	seg7 hex1 (.hex(V_GPIO[8:6]), .leds(HEX1));			// write data
	seg7 hex0 (.hex(read), .leds(HEX0));					// read  data
	
	// Sets HEX0, HEX2 & HEX3 depending on V_GPIO[14]
	always_comb begin
		if (V_GPIO[14]) begin									  
			HEX3 = 7'b1111111;
			HEX2 = 7'b1111111;
			read = read2;
		end
		else begin
			HEX3 = HEX3valid;
			HEX2 = HEX2valid;
			read = read1;
		end
	end
endmodule

`timescale 1 ps / 1 ps

module DE1_SoC_tb();
	// define signals
	logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0]  LEDR;
	wire  [35:0] V_GPIO;
	logic [35:0] V_GPIO_in, V_GPIO_dir;

	initial begin
		V_GPIO_dir[14] = 1'b1; // SW[9] - RAM toggle
		V_GPIO_dir[13] = 1'b1; // SW[8] - write address
		V_GPIO_dir[12] = 1'b1; // SW[7] - write address
		V_GPIO_dir[11] = 1'b1; // SW[6] - write address
		V_GPIO_dir[10] = 1'b1; // SW[5] - write address
		V_GPIO_dir[9]  = 1'b1; // SW[4] - write address
		V_GPIO_dir[8]  = 1'b1; // SW[3] - write data
		V_GPIO_dir[7]  = 1'b1; // SW[2] - write data
		V_GPIO_dir[6]  = 1'b1; // SW[1] - write data
		V_GPIO_dir[5]  = 1'b1; // SW[0] - write enable
		V_GPIO_dir[3]  = 1'b1; // KEY3  - reset
		V_GPIO_dir[0]  = 1'b1; // KEY0  - clock
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
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, .V_GPIO);
	
	// define simulated clock
	initial begin
		V_GPIO_in[0] <= 0;
		forever	#(T/2)	V_GPIO_in[0] <= ~V_GPIO_in[0];
	end  // initial clock
	
	initial begin
		@(posedge V_GPIO_in[0]);
		V_GPIO_in[3] <= 1;	@(posedge V_GPIO_in[0]);	// reset
		// enable ram1 and test
		V_GPIO_in[3] <= 1'b0; V_GPIO_in[14] <= 1'b0;  @(posedge V_GPIO_in[0]);	// ram1 enable
		V_GPIO_in[13:9] <= 5'b00000;  V_GPIO_in[5] <= 1'b1;  V_GPIO_in[8:6] <= 3'b000; 	@(posedge V_GPIO_in[0]);	// write 111 on ram1[0]
		for (int i = 0; i < 32; i++) begin  
			V_GPIO_in[13:9]++; 	V_GPIO_in[8:6]++;  @(posedge V_GPIO_in[0]);	// iterate through ram1
		end
		V_GPIO_in[13:9] <= 5'b00000;  V_GPIO_in[5] <= 1'b0;  @(posedge V_GPIO_in[0]);	// read ram1[0]
		for (int i = 0; i < 32; i++) begin
			V_GPIO_in[13:9]++;  @(posedge V_GPIO_in[0]);	// iterate through ram1
		end
		
		// enable ram2 and test
		V_GPIO_in[3] <= 1'b1; V_GPIO_in[14] <= 1'b1; @(posedge V_GPIO_in[0]);	// reset & ram2 enable
		V_GPIO_in[3] <= 1'b0; V_GPIO_in[13:9] <= 5'b00000; V_GPIO_in[5] <= 1'b0; V_GPIO_in[8:6] <= 3'b000;  @(posedge V_GPIO_in[0]);	// read ram2[0]	
		for (int i = 0; i < 32; i++) begin
			V_GPIO_in[13:9]++; @(posedge V_GPIO_in[0]);	// iterate through ram2
		end
		V_GPIO_in[3] <= 1'b1;  @(posedge V_GPIO_in[0]);	// reset
		V_GPIO_in[3] <= 1'b0;  V_GPIO_in[5] <= 1'b1;  V_GPIO_in[8:6] <= 3'b000; @(posedge V_GPIO_in[0]);	// write 111 on ram2[0]
		for (int i = 0; i < 32; i++) begin
			V_GPIO_in[13:9]++;  V_GPIO_in[8:6]++;  @(posedge V_GPIO_in[0]);	// iterate through ram2
		end
		$stop;
	end
endmodule  // DE1_SoC_tb
