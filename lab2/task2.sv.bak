module task2 (address, clock, datain, wren, dataout);
	input logic [4:0] address;
	input logic wren, clock;
	input logic [2:0] datain;
	output logic [2:0] dataout;

    logic [2:0] RAM [31:0];


    always_ff @(posedge clock) begin 
        if (wren) begin
            RAM[address] <= datain;
            dataout <= datain;
        end
        else 
            dataout <= RAM[address];
    end

endmodule

module task2_tb();
    logic [4:0] addr;
	logic [2:0] datain, dataout;
	logic clock, wren;

	parameter T = 20;
	task2 dut (.address(addr), .clock(clock), .datain(datain), .wren(wren), .dataout(dataout));

	initial begin
		clock <= 0;
		forever #(T/2) clock <= ~clock;
	end

	initial begin
		addr <= 0; wren <= 0; @(posedge clock);
		for (int i = 0; i < 32; i++) begin
			addr++;	@(posedge clock);
		end
		addr <= 0; wren <= 1; datain <= 3'b111; @(posedge clock);
		for (int i = 0; i < 32; i++) begin
			addr++; @(posedge clock);
		end
	end

endmodule

