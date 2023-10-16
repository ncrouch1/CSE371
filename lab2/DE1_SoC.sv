// top level module that reads and writes to two different 32x3 RAMs. 
// Uses user inputs as address to read and write on RAM1 
// User inputs to write and internal counter to read on RAM2
// inputs: CLOCK_50, clock divider used for ~1 sec clock cycles
// SW[9] is used to switch between RAMS
// SW[8:4] are used for write address
// SW[3:1] are used for write data
// SW[0] enables writing onto the ram
// outputs: HEX0 displays data on ram
// HEX1 displays data to be wirtten
// HEX2 & HEX3 display the read adress for RAM2, turns off when RAM1 selected
// HEX4 & HEX5 display the address the write data will be wirtten to
module DE1_SoC(CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);
   input logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	inout  logic [35:0] V_GPIO;	// expansion header 0 (LabsLand board)
	logic [4:0] counter, num, buff1, buff2;
	logic [6:0] HEX2valid, HEX3valid;
	logic [2:0] read, read1, read2;
	logic [31:0] div_clock;
	logic [3:0] wrtensplace;
	logic [3:0] wronesplace;
	logic [3:0] rdtensplace;
	logic [3:0] rdonesplace;
	
	// turn of all LEDs
	assign LEDR[9:0] = 0;
	
	clock_divider cd (.clock(CLOCK_50), .reset(~V_GPIO[3]), .divided_clocks(div_clock));

	// read address counter w/delay to synch wth ram2 
   always_ff @(posedge div_clock[24]) begin
		if (~V_GPIO[3] | ~V_GPIO[14]) begin
			num <= 0;
			buff1 <= num;
			counter <= buff1;
		end
		else if (num == 32) begin
			num <= 0;
			buff1 <= num;
			counter <= buff1;
		end
		else begin
			num <= num + 1;
			buff1 <= num;
			counter <= buff1;
		end
   end // always_ff
	
	// RAM modules, V_GPIO are inputs that simulate the actile low button and active high swicthes on the FPGA board,
	// read1 and read 2 are the output for the word read from the corresponding ram module
	task2 ram1 (.address(V_GPIO[13:9]), .enable(~V_GPIO[14]), .clock(CLOCK_50), .datain(V_GPIO[8:6]), .wren(V_GPIO[5]), .dataout(read1));
	task3 ram2 (.clock(div_clock[24]), .enable(V_GPIO[14]), .reset(~V_GPIO[3]), .datain(V_GPIO[8:6]), .rdaddress(num), .wraddress(V_GPIO[13:9]), .wren(V_GPIO[5]), .dataout(read2));

	// splits 32-bit binary two 4-bit hex
	assign wrtensplace = V_GPIO[13:9] / 16;
	assign wronesplace = V_GPIO[13:9] % 16;
	assign rdtensplace = counter / 16;
	assign rdonesplace = counter % 16;
	
	// converts 4-bit hex into 7-segment HEX display for each HEX
	seg7 hex5 (.hex(wrtensplace), .leds(HEX5)); 			// write address [1]
	seg7 hex4 (.hex(wronesplace), .leds(HEX4)); 			// write address [0]
	seg7 hex3 (.hex(rdtensplace), .leds(HEX3valid));	// read address  [1]
	seg7 hex2 (.hex(rdonesplace), .leds(HEX2valid));	// read address  [0]
	seg7 hex1 (.hex(V_GPIO[8:6]), .leds(HEX1));			// write data
	seg7 hex0 (.hex(read), .leds(HEX0));					// read  data
	
	// display for HEX0, HEX2 & HEX3 depending on RAM selected by V_GPIO[14]
	always_comb begin
		if (V_GPIO[14]) begin									  
			HEX3 = HEX3valid;
			HEX2 = HEX2valid;
			read = read2;
		end
		else begin
			HEX3 = 7'b1111111;
			HEX2 = 7'b1111111;
			read = read1;
		end
	end // always_comb
endmodule // DE1_SoC

 `timescale 1 ps / 1 ps

 module DE1_SoC_tb();
 	// define signals
   logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	logic [9:0] LEDR;
	logic [31:0] div_clock;
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
 	end // initial
	
 	genvar i;
 	generate
 		for (i = 0; i < 36; i++) begin : gpio
 			assign V_GPIO[i] = V_GPIO_dir[i] ? V_GPIO_in[i] : 1'bZ;
 		end
 	endgenerate
	
 	// define parameters
 	parameter T = 20;
	
 	// instantiate module for the design to be tested
 	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, .V_GPIO);
	
 	// define simulated clock
 	initial begin
 		CLOCK_50 <= 0;
 		forever	#(T/2)	CLOCK_50 <= ~CLOCK_50;
 	end  // initial clock
	
/*
  Test Procedure:
  1. Enable RAM1
  2. Write data to RAM1[0]
  3. Iterate through RAM1 with incrementing data
  4. Read data from RAM1[0]
  5. Iterate through RAM1
  6. Reset and enable RAM2
  7. Read data from RAM2[0]
  8. Iterate through RAM2
  9. Reset
  10. Write data to RAM2[0]
  11. Iterate through RAM2 with incrementing data
*/
 	initial begin
 		@(posedge CLOCK_50);
 		V_GPIO_in[3] <= 0;	@(posedge CLOCK_50);	// reset
		
 		// enable ram1 and test
 		V_GPIO_in[3] <= 1; V_GPIO_in[14] <= 0;  @(posedge CLOCK_50);	
 		V_GPIO_in[13:9] <= 5'b00000;  V_GPIO_in[5] <= 1;  V_GPIO_in[8:6] <= 3'b000; 	@(posedge CLOCK_50);	
 		for (int i = 0; i < 32; i++) begin  
 			V_GPIO_in[13:9]++; 	V_GPIO_in[8:6]++;  @(posedge CLOCK_50);	
 		end
 		V_GPIO_in[13:9] <= 5'b00000;  V_GPIO_in[5] <= 0;  @(posedge CLOCK_50);	
 		for (int i = 0; i < 32; i++) begin
 			V_GPIO_in[13:9]++;  @(posedge CLOCK_50);	
 		end
		
 		// enable ram2 and test
 		V_GPIO_in[3] <= 0; V_GPIO_in[14] <= 1; @(posedge CLOCK_50);	
 		V_GPIO_in[3] <= 1; V_GPIO_in[13:9] <= 5'b00000; V_GPIO_in[5] <= 0; V_GPIO_in[8:6] <= 3'b000;  @(posedge CLOCK_50);		
 		for (int i = 0; i < 32; i++) begin
 			V_GPIO_in[13:9]++; @(posedge CLOCK_50);	
 		end
 		V_GPIO_in[3] <= 0;  @(posedge CLOCK_50);	
 		V_GPIO_in[3] <= 1;  V_GPIO_in[5] <= 1;  V_GPIO_in[8:6] <= 3'b000; @(posedge CLOCK_50);	
 		for (int i = 0; i < 32; i++) begin
 			V_GPIO_in[13:9]++;  V_GPIO_in[8:6]++;  @(posedge CLOCK_50);	
 		end
 		$stop;
 	end // initial
 endmodule  // DE1_SoC_tb