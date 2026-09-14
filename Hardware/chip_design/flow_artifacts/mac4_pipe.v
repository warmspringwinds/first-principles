// mac4: a 4-bit multiply-accumulate unit -- one cell of a MAC array.
//   acc <= clear ? 0 : (en ? acc + a*b : acc)
module mac4 (   // PIPELINED: product registered before the add
    input  wire       clk,
    input  wire       rst_n,      // asynchronous reset, active low
    input  wire       clear,      // synchronous clear
    input  wire       en,
    input  wire [3:0] a,
    input  wire [3:0] b,
    output reg  [7:0] acc
);
    reg  [7:0] prod;              // pipeline register: stage 1 = multiply
    always @(posedge clk or negedge rst_n)
        if (!rst_n) prod <= 8'd0; else prod <= a * b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)       acc <= 8'd0;
        else if (clear)   acc <= 8'd0;
        else if (en)      acc <= acc + prod;   // combinational adder + mux, then 8 flops
    end
endmodule
