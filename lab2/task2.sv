// second level module that uses 3D array as 32x3 RAM.
 // inputs: clock - 1-bit
// 			enable - 1-bit, enables any manipulation of this RAM
// 			address - 5-bit, used to specify location on RAM for reading or writing
// 			datain - 3-bit, data to be written to RAM
// 			wren - 1-bit, enables writing onto the RAM
// outputs: dataout - 3-bit, data read from the RAM
module task2 (address, enable, clock, datain, wren, dataout);
	input logic [4:0] address;
	input logic wren, clock, enable;
	input logic [2:0] datain;
	output logic [2:0] dataout;
	
	// 32x3 RAM as a 3D array
   logic [2:0] RAM [31:0];

	// allows passing of data in and out when enable is true
   always_ff @(posedge clock) begin 
        if (wren & enable) begin
            RAM[address] <= datain;
            dataout <= datain;
        end
        else if (enable)
            dataout <= RAM[address];
   end
endmodule // task2

module task2_tb();
	// define signals
   logic [4:0] addr;
	logic [2:0] datain, dataout;
	logic clock, wren;
	
	// define parameters
	parameter T = 20;
	
	// instantiate module
	task2 dut (.address(addr), .enable(1'b1), .clock(clock), .datain(datain), .wren(wren), .dataout(dataout));

	// define simulated clock
	initial begin
		clock <= 0;
		forever #(T/2) clock <= ~clock;
	end

	initial begin
		addr <= 0; wren <= 1; datain <= 3'b111; @(posedge clock); // write 111 at addr[0]
		for (int i = 0; i < 32; i++) begin	// iterate through RAM and write 111
			addr++; @(posedge clock);
		end
		addr <= 0; wren <= 0; @(posedge clock); // read addr[0]
		for (int i = 0; i < 32; i++) begin // iterate through RAM and read
			addr++;	@(posedge clock);
		end
		$stop;
	end // initial
endmodule // task2_tb