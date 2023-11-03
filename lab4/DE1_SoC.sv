// Module to implement lab 4

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR);
    // port declarations
    input  logic CLOCK_50;  // 50MHz clock
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;  // active low
    output logic [9:0] LEDR;
    input logic [3:0] KEY;
    input logic [9:0] SW;

    // logic for task 1
    logic reset, start, s, done;
    logic [7:0] A; // 8-bit input
    assign A = SW[7:0]; // A is controlled by switches 0-7

    // Synchronous reset, using two DFF's to handle metastability
    always_ff @(posedge CLOCK_50) begin
        reset <= ~KEY[0];
        s <= ~KEY[3];
        start <= s;
    end 

    // bit counter logic
    logic [3:0] result; 

    // Location for Binary Search
    logic [4:0] Loc;
    // Logic Signals for Binary Search
    logic Found, Done;
    assign LEDR[9] = Done;
    assign LEDR[0] = Found;
    
    bitcounter task1 (
        .input_a(A), 
        .s(start), 
        .clock(CLOCK_50), 
        .reset(reset), 
        .result(result), 
        .done(done),
        .enable(~SW[8])
    );

    BinarySearch task2 (
        .A(A),
        .Start(start),
        .Reset(reset),
        .Clock(CLOCK_50),
        .Loc(Loc),
        .Done(Done),
        .Found(Found),
        .Enable(SW[8])
    );

    assign HEX3 = 7'b1111111;
    assign HEX2 = 7'b1111111;

    logic [6:0] hex1_intermediate, hex0_intermediate, hex1_final, hex0_final;

    seg7 hex1signal (.hex({3'b000, Loc[4]}), .leds(hex1_intermediate));
    seg7 hex0signal (.hex(SW[8] ? Loc[3:0] : result), .leds(hex0_intermediate));

    seg7 hex5inputhandler (.hex(SW[7:4]), .leds(HEX5));
    seg7 hex4inputhandler (.hex(SW[3:0]), .leds(HEX4));

    always_comb begin
        if (~SW[8]) begin
            hex1_final = 7'b1111111;
            hex0_final = hex0_intermediate;
        end
        // else if (SW[8] & ~Found & Done) begin
        //     hex1_final = 7'b0111111;
        //     hex0_final = 7'b0111111;
        // end
        else begin
            hex1_final = hex1_intermediate;
            hex0_final = hex0_intermediate;
        end
    end

    assign HEX1 = hex1_final;
    assign HEX0 = hex0_final;
endmodule