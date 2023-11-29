module input_handler (
    input logic clock, reset,
    input logic [9:0] SW,
    input logic button, drawing, player,
    output logic [9:0] metaSW,
    output logic holding, gameover
);
    logic [1:0] gamestate [9:0];
	logic valid;
    enum {reading, hold, hold2} ps, ns;
    assign holding = (ps != reading);

    
    always_comb begin : _State_logic
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
    end
endmodule

module input_handler_tb();
    logic [9:0] SW, metaSW;
    logic clock, reset, button, holding, valid;
endmodule