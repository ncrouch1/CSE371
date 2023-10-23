module d_ff(clock, reset, data, dataout);
    input logic clock, reset;
    input logic [23:0] data;
    output logic [23:0] dataout;

    always_ff @(posedge clock) begin
        if (reset)
            dataout <= 24'b0;
        else 
            dataout <= data;
    end
endmodule