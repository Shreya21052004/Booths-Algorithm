

// booth_v.v
// 2-bit Booth multiplier

module two_bit_adder_subtractor(
    input wire cin,
    input wire [1:0] i0, i1,
    output wire [1:0] sum);

    wire cout;
    wire [1:0] temp;
    wire [1:0] int_ip;

    // if cin == 1, int_ip = 1's complement
    // else int_ip = i1
    xor2 x0 (i1[0], cin, int_ip[0]);
    xor2 x1 (i1[1], cin, int_ip[1]);

    // if cin == 1, cin added to make two's complement
    // else addition takes place
    fa fa1(i0[0], int_ip[0], cin,     sum[0], temp[0]);
    fa fa2(i0[1], int_ip[1], temp[0], sum[1], cout);

endmodule


module booth_substep(
    input wire signed [1:0] acc,
    input wire signed [1:0] Q,
    input wire signed q0,
    input wire signed [1:0] multiplicand,
    output reg signed [1:0] next_acc,
    output reg signed [1:0] next_Q,
    output reg q0_next);

    wire [1:0] addsub_temp;

    two_bit_adder_subtractor myadd(Q[0], acc, multiplicand, addsub_temp);

    always @(*) begin    
        if(Q[0] == q0) begin
            q0_next = Q[0];
            next_Q = Q >> 1;
            next_Q[1] = acc[0];
            next_acc = acc >> 1;
            if (acc[1] == 1)
                next_acc[1] = 1;
        end else begin
            q0_next = Q[0];
            next_Q = Q >> 1;
            next_Q[1] = addsub_temp[0];
            next_acc = addsub_temp >> 1;
            if (addsub_temp[1] == 1)
                next_acc[1] = 1;
        end            
    end    
endmodule


module booth_multiplier(
    input signed [1:0] multiplier, multiplicand,
    output signed [3:0] product);

    wire signed [1:0] Q[0:1];
    wire signed [1:0] acc[0:2];
    wire q0;

    assign acc[0] = 2'b00;

    booth_substep step1(acc[0], multiplier, 1'b0, multiplicand, acc[1], Q[0], q0);
    booth_substep step2(acc[1], Q[0], q0, multiplicand, product[3:2], product[1:0], q0);

endmodule
