module part1 (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT, SW9, SW8);

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire [23:0] intermediate_left, intermediate_right;
	wire reset = ~KEY[0];


	/////////////////////////////////
	// Your code goes here
	reg [15:0] counter;
	wire [23:0] ram_data;
	input SW9, SW8;
	wire [23:0] filtered_left, filtered_right;

	always @(posedge CLOCK_50) begin
		if (reset | ~SW9)
		    counter <= 0;
		else begin
		    counter <= counter + 1;
		    if (counter >= 48000)
		        counter <= 0;
		end
	end

	rom1port rom (.address(counter), .clock(CLOCK_50), .q(ram_data));

	/////////////////////////////////
	assign intermediate_left = SW9 ? ram_data : readdata_left;
	assign intermediate_right = SW9 ? ram_data : readdata_right;

	filter filter_l(.clock(CLOCK_50), .reset(reset), .data(intermediate_left), .dataout(filtered_left));
	filter filter_r(.clock(CLOCK_50), .reset(reset), .data(intermediate_right), .dataout(filtered_right));
	assign writedata_left = SW8 ? filtered_left : intermediate_left;
	assign writedata_right = SW8 ? filtered_right : intermediate_right;
	assign read = (read_ready & write_ready & ~reset);
	assign write = (write_ready & read_ready & ~reset);
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule
