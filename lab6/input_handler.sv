module input_handler (
    input logic clock, reset,
    input logic [9:0] SW,
    input logic button, drawing,
    output logic [9:0] metaSW,
    output logic gameover, player
);                                                                                                                                                                                                                                                                                                                                                                                                                                                                               vvvbn
    logic [1:0] gamestate [9:0];
	logic valid, enable_validation, enable_set;
    enum {reading, hold, hold2} ps, ns;
    assign holding = (ps != reading);
    assign enable_validation = (ps == hold);
    assign enable_set = (ps == hold) & valid;
    
    always_comb begin : state_logic
        case(ps)
            reading: begin
                metaSW = SW;
                ns = reading;
                if (button)
                    ns = hold;
            end
            hold: ns =  valid? hold2 : reading;
            hold2: ns = drawing? hold2 : reading;
        endcase
    end
    
    always_ff @(posedge clock) begin
        if (reset)
            ps <= reading;
        else
            ps <= ns;
        if (ps == hold2)
            gamestate <= gamestate_next;
    end
endmodule

module input_handler_tb();
    logic [9:0] SW, metaSW;
    logic clock, reset, button, holding, valid;
endmodule