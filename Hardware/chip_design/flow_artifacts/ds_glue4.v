module glue4 (input wire clk, input wire rst_n, input wire [3:0] acc0, input wire [3:0] acc1, input wire [3:0] acc2, input wire [3:0] acc3,
    output reg [5:0] sum);
    always @(posedge clk or negedge rst_n)
        if (!rst_n) sum <= 0; else sum <= acc0 + acc1 + acc2 + acc3;
endmodule
