module input_datapath (
    input logic clock, player, enable_validation, enable_setting, enable_ram, update_state, lock_input, reset,
    output logic valid,
    input logic [9:0] SW,
    output logic [87:0] data
);
    logic [1:0] gamestate [9:0];
    logic [1:0] gamestate_next [9:0];
    logic [9:0] metaSW;
	 logic [3:0] address;

    always_ff @(posedge clock) begin
        if (~lock_input)
            metaSW <= SW;
        if (reset) begin
            for (int i = 0; i < 10; i++) begin
                gamestate[i] = 2'b00;
            end
        end
        if (update_state)
            gamestate <= gamestate_next;
	 end
    
    validate_move validator (.enable(enable_validation & ~reset), .valid(valid), .gamestate(gamestate), .metaSW(metaSW));
    set_move setter (.metaSW(metaSW), .gamestate(gamestate), .enable(enable_setting & ~reset), .player(player), .gamestate_next(gamestate_next), .clock(clock), .reset(reset));
    address_decoder addresser (.metaSW(metaSW), .enable(enable_ram), .address(address), .reset(reset), .clock(clock));
    rom rom (.address(address), .clock(clock), .q(data));
endmodule

`timescale 1 ps / 1 ps
module input_datapath_tb ();
    logic clock, player, enable_validation, enable_setting, enable_ram, update_state, lock_input, valid, reset;
    logic [9:0] SW;
    logic [87:0] data;
    logic [3:0] address;

    input_datapath idp (.*);

    parameter T = 20;
    initial begin
        clock <= 1'b0;
        forever #(T/2) clock <= ~clock;
    end

    initial begin
        reset <= 1'b1; @(posedge clock);
        reset <= 1'b0; player <= 1'b1; @(posedge clock);
        SW <= 10'd1;  lock_input <= 1'b0; enable_validation <= 1'b0; enable_setting <= 1'b0; enable_ram <= 1'b0; update_state <= 1'b0;  @(posedge clock);
        SW <= (SW << 1); lock_input <= 1'b1; @(posedge clock);
        SW <= (SW << 1); enable_validation <= 1'b1; @(posedge clock);
        SW <= (SW << 1); enable_validation <= 1'b0; enable_setting <= 1'b1; enable_ram <= 1'b1; @(posedge clock);
        SW <= (SW << 1); enable_setting <= 1'b0; enable_ram <= 1'b0; @(posedge clock);
        SW <= (SW << 1); update_state <= 1'b1;   @(posedge clock);
        update_state <= 1'b0;
        lock_input <= 1'b0; @(posedge clock);
        SW <= (SW << 1); @(posedge clock); 
        SW <= (SW << 1); @(posedge clock); 
        SW <= (SW << 1); @(posedge clock); 
        $stop;
    end
endmodule