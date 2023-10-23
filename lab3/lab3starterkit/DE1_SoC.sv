module DE1_SoC(CLOCK_50, CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT, V_GPIO);
	input CLOCK_50, CLOCK2_50;
	inout logic [35:0] V_GPIO;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	part1 task1(.CLOCK_50, .CLOCK2_50, .KEY(V_GPIO[3]), .FPGA_I2C_SCLK, .FPGA_I2C_SDAT, .AUD_XCK, 
		        .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT, .AUD_DACDAT, .SW9(V_GPIO[14]), .SW8(V_GPIO[13]));
endmodule