// module that calls quartus generated 32x3 RAM submodule.
// inputs: 	clock - 1-bit
// 			address - 5-bit, used to specify location on RAM for reading or writing
// 			wren - 1-bit, enables writing onto the RAM
// 			datain - 3-bit, data to be written to RAM
// outputs: dataout - 3-bit, data read from the RAM
module task1(address, clock, datain, wren, dataout);
	input logic [4:0] address;
	input logic wren, clock;
	input logic [2:0] datain;
	output logic [2:0] dataout;

	// 32x3 ram submodule, inputs - address, clock, data, wren
	// output- q
	ram32x3 ram (.address(address), .clock(clock), .data(datain), .wren(wren), .q(dataout));
	
endmodule // task1

`timescale 1 ps / 1 ps

module task1_tb();
	// define signals
	logic [4:0] addr;
	logic [2:0] datain, dataout;
	logic clock, wren;

	// define parameters
	parameter T = 20;
	
	// instantiate module
	task1 dut (addr, clock, datain, wren, dataout);

	// define simulated clock
	initial begin
		clock <= 0;
		forever #(T/2) clock <= ~clock;
	end

	/*
	Test Procedure:
	- Iterate through RAM and write with incrementing data
	- Read from addr[0]
	- Iterate through RAM and read
	*/
	initial begin
		addr <= 0; wren <= 1; datain <= 3'b000; @(posedge clock); 
		for (int i = 0; i < 32; i++) begin	
			addr++; datain++; @(posedge clock);
		end
		addr <= 0; wren <= 0; @(posedge clock); 
		for (int i = 0; i < 32; i++) begin 
			addr++;	@(posedge clock);
		end
		$stop;
	end // initial
endmodule // task1_tb