
// tb_booth_v.v
module tb;
    wire signed [3:0] z;
    reg signed [1:0] a, b;

    booth_multiplier my_booth(.multiplier(a), .multiplicand(b), .product(z));

    initial begin
        $dumpfile("tb_booth.vcd");
        $dumpvars(0, tb);
    end

    initial begin
        $monitor($time, "       ", a, " *", b, " = ", z);

        b = 2'b01;
        a = 2'b01;
        #10;

        a = 2'b10;
        b = 2'b11;
        #10;

        a = 2'b01;
        b = 2'b00;
        #10;

        a = 2'b01;
        b = 2'b01;
        #10;

        a = 2'b01;
        b = 2'b11;
        #10;

        a = 2'b11;
        b = 2'b11;
        #10;
    end
endmodule
