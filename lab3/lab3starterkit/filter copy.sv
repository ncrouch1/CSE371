module filter #(size=24) (clock, reset, datain, dataout);
    input logic clock, reset;
    input logic [23:0] datain;
    output logic [23:0] dataout;

    // divider
    logic [23:0] div_data;
    assign n = size;
    assign w = 8;
    assign div_data = {{n{data[w-1]}}, data[w-1:n]};

    always_ff @(posedge clock) begin
        if (reset)
            dataout <= 24'b0;
        else
            
    end
endmodule