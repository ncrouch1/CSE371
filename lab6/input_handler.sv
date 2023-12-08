module input_handler (
    input logic clock, reset, button, drawing_done,
    input logic [9:0] SW,
    output logic enable_drawing,
    output logic [9:0] LEDR,
    output logic [87:0] data;
);
    logic enable_validation, enable_setting, enable_ram, valid;
    logic lock_input, player, update_state;

    input_controller ic (
        .clock(clock), .reset(reset), .button(button),
        .valid(valid), .drawing_done(drawing_done),
        .enable_validation(enable_validation),
        .enable_setting(enable_setting),
        .enable_ram(enable_ram),
        .enable_drawing(enable_drawing),
        .lock_input(lock_input), .player(player),
        .update_state(update_state), .LEDR(LEDR)
    );

    input_datapath idp (
        .clock(clock), .reset(reset), .lock_input(lock_input),
        .update_state(update_state), .enable_ram(enable_ram),
        .enable_setting(enable_setting), .player(player),
        .enable_validation(enable_validation), .valid(valid),
        .SW(SW), .data(data)
    );


endmodule