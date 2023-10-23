module filter #(size=24) (clock, reset, datain, dataout);
    input logic clock, reset;
    input logic [23:0] datain;
    output logic [23:0] dataout;

    // divider
    logic [23:0] div_data;
    assign div_data = datain / size;

    genvar i;
    logic [23:0] data [size - 1: 0];
    d_ff first_reg(.clock(clock), .reset(reset), .data(div_data), .dataout(data[0]));
    generate 
        for (i = 0; i < size - 1; i++) begin : cringe_name
            d_ff next_reg(.clock(clock), .reset(reset), .data(data[i]), .dataout(data[i + 1]));
        end
    endgenerate
    
    always_ff @(posedge clock) begin
        if (reset)
            dataout <= 24'b0;
        else begin
            dataout <= dataout + div_data + (-1 * data[size - 1]);
        end
    end
endmodule