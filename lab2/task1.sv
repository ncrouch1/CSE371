module task1(address, clock, datain, wren, dataout);
	input logic [4:0] address;
	input logic wren, clock;
	input logic [2:0] datain;
	output logic [2:0] dataout;

	ram32x3 ram (.address(address), .clock(clock), .data(datain), .wren(wren), .q(dataout));
	
endmodule 

module task1_tb();
	logic [4:0] addr;
	logic [2:0] datain, dataout;
	logic clock, wren;

	parameter T = 20;
	task1 dut (addr, clock, datain, wren, dataout);

	initial begin
		clock <= 0;
		forever #(T/2) clock <= ~clock;
	end

	initial begin
		addr <= 0; wren <= 0; @(posedge clock);
		addr <= 0; wren <= 1; datain <= 3'b111; @(posedge clock);
		addr <= 1; wren <= 0; @(posedge clock);
	end
	
endmodule