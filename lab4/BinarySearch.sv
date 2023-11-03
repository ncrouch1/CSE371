module BinarySearch(A, Start, Reset, Clock, Loc, Done, Found);
    input logic Start, Reset, Clock;
    input logic [7:0] A;
    output logic Done, Found;
    output logic [4:0] Loc;

    logic [4:0] left, right, middle;
    logic [7:0] middle_data;
    
    enum {S_idle, S_searching, S_done} ps, ns;

    ram32x8 ram (.address(middle), .clock(Clock), .data(8'h00), .wren(1'b0), .q(middle_data));
    
    always_latch begin
        Done = 0; Found = 0;
        case(ps)
            S_idle: begin
                left = 5'b00000;
                right = 5'b11111;
                middle = 5'b01111;
                Loc = 5'b00000;
                ns = S_idle;
                if (Start) begin
                    ns = S_searching;
                end
            end
            S_searching: begin
                if (left < right) begin
                    if (A == middle_data) begin
                        Done = 1;
                        Found = 1;
                        Loc = middle;
                        ns = S_done;
                    end
                    else begin
                        if (middle_data > A) 
                            right = middle - 1;
                        else if (middle_data < A)
                            left = middle + 1;
                    end
						  middle = left + ((right - left) / 2);
                end
                else begin
                    Done = 1;
                    Found = 0;
                    ns = S_done;
                end
            end
            S_done: begin
                Done = 1;
                if (Loc == middle) 
                    Found = 1;
                if (Start)
                    ns = S_done;
                else
                    ns = S_idle;
            end
        endcase
    end

    always_ff @(posedge Clock) begin
        if (Reset)
            ps <= S_idle;
        else
            ps <= ns;
    end
	 
	 always_ff @(posedge Clock) begin

	 end
endmodule

`timescale 1 ps / 1 ps
module bsearch_tb();
    logic [7:0] A;
    logic Clock, Reset, Start, Done, Found;
    logic [4:0] Loc;

    BinarySearch dut (.A(A), .Start(Start), .Reset(Reset), .Clock(Clock),
                .Loc(Loc), .Done(Done), .Found(Found));
    
    parameter T = 20;

    initial begin
        Clock <= 0;
        forever #(T/2) Clock <= ~Clock;
    end

    initial begin
        Reset <= 1; Start <= 0; A <= 5'b01111;         @(posedge Clock);
        Reset <= 0;                                    @(posedge Clock);
        Start <= 1;                                    @(posedge Clock);
        while (~Done) begin
            @(posedge Clock);
        end
        Start <= 0;                                    @(posedge Clock);
        A <= 5'b00011;                                 @(posedge Clock);
        Start <= 1;                                    @(posedge Clock);
        while (~Done) begin
            @(posedge Clock);
        end
        Start <= 0;												 @(posedge Clock);
        A <= 6'b100000;											 @(posedge Clock);
        Start <= 1;												 @(posedge Clock);
        while (~Done) begin
            @(posedge Clock);
        end
        $stop;
    end
endmodule
