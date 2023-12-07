module input_datapath (
    input logic clock, player, enable_validation, enable_setting, enable_ram, update_state, lock_input
    output logic valid, set,
    input logic [9:0] SW,
    output logic [87:0] data
);
    logic [1:0] gamestate [9:0];
    logic [1:0] gamestate_next [9:0];


    always_ff @(posedge clock) 
        if (~lock_input)
            metaSW <= SW;
    
    always_ff @(posedge update_state)
        gamestate <= gamestate_next
    
    validate_move validator (.enable(enable_validation), .valid(valid), .gamestate(gamestate), .metaSW(metaSW));
    set_move setter (.metaSW(metaSW), .gamestate(gamestate), .enable(enable_setting), .player(player), .gamestate_next(gamestate_next));
    address_decoder addresser (.metaSW(metaSW), .enable(enable_ram), .address(address));
    rom rom (.address(address), .clock(clock), .data(data);)
endmodule