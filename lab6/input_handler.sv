module input_handler (
    input logic clock, reset, button, drawing_done,
    input logic [9:0] SW,
    output logic enable_drawing, player,
    output logic [9:0] LEDR,
    output logic [87:0] data
);
    logic enable_validation, enable_setting, enable_ram, valid;
    logic lock_input, update_state;

    input_controller ic (
        .clock(clock), .reset(reset), .button(button),
        .valid(valid), .drawing_done(drawing_done),
        .enable_validation(enable_validation),
        .enable_setting(enable_setting),
        .enable_ram(enable_ram),
        .enable_drawing(enable_drawing),
        .lock_input(lock_input), .player(player),
        .update_state(update_state)
    );

    input_datapath idp (
        .clock(clock), .reset(reset), .lock_input(lock_input),
        .update_state(update_state), .enable_ram(enable_ram),
        .enable_setting(enable_setting), .player(player),
        .enable_validation(enable_validation), .valid(valid),
        .SW(SW), .data(data), .LEDR(LEDR)
    );
endmodule

`timescale 1 ps / 1 ps
module input_handler_tb();
    logic clock, reset, button, drawing_done, enable_drawing, player;
    logic [9:0] SW, LEDR;
    logic [87:0] data;

    input_handler ih (.*);

    parameter T = 20;
    initial begin
        clock <= 1'b0;
        forever #(T/2) clock <= ~clock;
    end

    initial begin
        player <= 1'b1;
        reset <= 1'b1; SW <= 10'd0; button <= 1'b0; @(posedge clock);
        reset <= 1'b0;                              @(posedge clock);
        SW <= 10'b1;                                @(posedge clock);
        button <= 1'b1;                             @(posedge clock);
        @(posedge clock);
        button <= 1'b0;                             @(posedge clock);
        while (~enable_drawing)                     @(posedge clock);
        drawing_done <= 1'b1;                       @(posedge clock);
        @(posedge clock);
		  @(posedge clock);
        $stop;
    end
endmodule
