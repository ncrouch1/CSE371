module DE1_SoC(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO)
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	inout  logic [35:0] V_GPIO;	// expansion header 0 (LabsLand board)

    logic [4:0] counter;

    logic [9:0] SW;
    assign SW[9:0] = V_GPIO[14:5];
    logic KEY0;
    assign KEY0 = V_GPIO[0];
    logic KEY3;
    assign KEY3 = V_GPIO[3];
    assign LEDR[9:0] = 0;
    
    parameter wrtensplace = SW[8:4] / 10;
    parameter wronesplace = SW[8:4] % 10;
    parameter rdtensplace = counter / 10;
    parameter rdonesplace = counter % 10;

    always_comb begin
        case(SW[9]) 
            1'b1: begin
                HEX3 = 7'b1111111;
                HEX2 = 7'b1111111;
            end
        endcase
    end

    always_ff @(posedge ~KEY0) begin
        if (~KEY3 | SW[9]) begin
            counter = 0;
        end
        else if (counter == 32) begin
            counter = 0;
        end
        else begin
            counter++;
        end;
    end
    
    if (SW[9]) begin 
        task3 ram2 (.clock(~KEY0), .reset(~KEY3), .datain(SW[3:1]), .rdaddress(counter), .wraddress(SW[8:4]), .wren(SW[0]), .dataout(HEX0))
    end
    else begin
        task2 ram1 (.address(SW[8:4]), .clock(KEY0), .datain(SW[3:1]), .wren(SW[0]), .dataout(HEX0))
    end

    seg7 hex5 (.hex(wrtensplace), .leds(HEX5));
    seg7 hex4 (.hex(wronesplace), .leds(HEX4));
    seg7 hex3 (.hex(rdtensplace), .leds(HEX3));
    seg7 hex2 (.hex(rdonesplace), .leds(HEX2));
    seg7 hex1 (.hex(datain), .leds(HEX1));
    seg7 hex0 (.hex(dataout), .leds(HEX0));

endmodule
