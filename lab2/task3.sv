// second level module that calls quartus generated 32x3 RAM submodule.
// inputs: clock - 1-bit
// 			enable - 1-bit, enables changes to be made to this RAM
// 			raddress - 5-bit, used to find stored data in RAM
// 			wraddress - 5-bit, used to specifiy location to write data
// 			wren - 1-bit, enables writing onto the RAM
// 			datain - 3-bit, data to be written to RAM
// outputs: dataout - 3-bit, data read from the RAM
module task3(clock, enable, reset, datain, rdaddress, wraddress, wren, dataout);
    input logic clock, wren, reset, enable;
    input logic [4:0] rdaddress, wraddress;
    input logic [2:0] datain;
    output logic [2:0] dataout;
	 logic enwren;
	 
	 // second enable attached to wren 
	 always_comb begin
		if (enable) begin
			enwren = wren;
		end
		else begin
			enwren = 0;
		end
	end
			
	 // 32x3 ram submodule
    ram32x3port2 ram(.clock(clock), .data(datain), .rdaddress(rdaddress), .wraddress(wraddress), .wren(enwren), .q(dataout));

endmodule // task3

`timescale 1 ps / 1 ps

module task3_tb();
	 // define singals
    logic clock, wren, reset;
    logic [4:0] rdaddress, wraddress;
    logic [2:0] datain, dataout;

	 // instantiate module
    task3 dut(.clock, .enable(1), .reset, .datain, .rdaddress, .wraddress, .wren, .dataout);
	
	 // define parameters
    parameter T = 20;
	 
	 // define simulated clock
    initial begin
        clock <= 0;
        forever #(T/2) clock <= ~clock;
    end

    initial begin
        rdaddress <= 0; wraddress <= 0; wren <= 0; datain <= 0; reset <= 1; @(posedge clock); // reset
        reset <= 0; @(posedge clock);
        for (int i = 0; i < 32; i++) begin 
            rdaddress++; @(posedge clock); // increment both address while reading
        end
		  
        rdaddress <= 0; @(posedge clock);
        wren <= 1; datain <= 3'b111; @(posedge clock); 
        for (int i = 0; i < 32; i++) begin
            rdaddress++; wraddress++; @(posedge clock); // increment both addresses while writing 111
        end
		  $stop;
    end // initial
endmodule // task3_tb