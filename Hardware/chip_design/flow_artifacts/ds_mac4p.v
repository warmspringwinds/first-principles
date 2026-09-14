module mac4p (input wire clk, input wire rst_n, input wire clear, input wire en,
    input wire [3:0] a, input wire [3:0] b, output reg [7:0] acc);
    reg  [7:0] prod;
    always @(posedge clk or negedge rst_n)
        if (!rst_n) prod <= 0; else prod <= a * b;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     acc <= 0;
        else if (clear) acc <= 0;
        else if (en)    acc <= acc + prod;
    end
endmodule
