module mac2 (input wire clk, input wire rst_n, input wire clear, input wire en,
    input wire [1:0] a, input wire [1:0] b, output reg [3:0] acc);
    wire [3:0] prod = a * b;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     acc <= 0;
        else if (clear) acc <= 0;
        else if (en)    acc <= acc + prod;
    end
endmodule

module tile4 (input wire clk, input wire rst_n, input wire clear, input wire en,
    input wire [1:0] a0, input wire [1:0] a1, input wire [1:0] a2, input wire [1:0] a3, input wire [1:0] b, output reg [5:0] sum);
    wire [3:0] acc0, acc1, acc2, acc3;
    mac2 m0 (.clk(clk), .rst_n(rst_n), .clear(clear), .en(en), .a(a0), .b(b), .acc(acc0));
    mac2 m1 (.clk(clk), .rst_n(rst_n), .clear(clear), .en(en), .a(a1), .b(b), .acc(acc1));
    mac2 m2 (.clk(clk), .rst_n(rst_n), .clear(clear), .en(en), .a(a2), .b(b), .acc(acc2));
    mac2 m3 (.clk(clk), .rst_n(rst_n), .clear(clear), .en(en), .a(a3), .b(b), .acc(acc3));
    always @(posedge clk or negedge rst_n)                     // the glue: exists only at the tile level
        if (!rst_n) sum <= 0; else sum <= acc0 + acc1 + acc2 + acc3;
endmodule
