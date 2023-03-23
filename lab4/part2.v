module part2(Clock, Reset_b, Data, Function, ALUout);
    input [3:0] Data;
    input Clock, Reset_b;
    input [2:0] Function;
    output [7:0]ALUout;
    reg [7:0]q;

    wire [3:0]addOut;
    wire [3:0]cout;

    ripple ra(Data, ALUout[3:0], 0, addOut, cout);
    flipflop u1(Clock, Reset_b, q, ALUout[7:0]); 

    always @(*)
    begin
        case(Function[2:0])
            3'b000: q = {cout[3], addOut};
            3'b001: q = Data + ALUout[3:0];
            3'b010: q = {{4{ALUout[3]}}, ALUout[3:0]};
            3'b011: if ((Data > 1) | (ALUout[3:0] > 1))
                        q = 8'b00000001;
                    else
                        q = 8'b0;
            3'b100: if ((Data == 15) & (ALUout[3:0] == 15))
                        q = 8'b00000001;
                    else
                        q = 8'b0;
            3'b101: q = ALUout[3:0] << Data;
            3'b110: q = Data*ALUout[3:0]; 
            3'b111: q = ALUout; 
            default: q = 8'b0;
        endcase
    end

endmodule 

module ripple(a, b, c_in, s, c_out);
    input [3:0] a, b;
    input c_in;
    output [3:0] s;
    output [3:0] c_out;
    wire w1, w2, w3, w4;

    assign c_out = {w4, w3, w2, w1};
    FA bit0(a[0], b[0], c_in, s[0], w1);
    FA bit1(a[1], b[1], w1, s[1], w2);
    FA bit2(a[2], b[2], w2, s[2], w3);
    FA bit3(a[3], b[3], w3, s[3], w4);
endmodule

module FA(a, b, Cin, S, Cout);
     input a, b, Cin;
     output S, Cout;
     
     assign S = Cin ^ a ^ b;
     assign Cout = (a&b)|(Cin&a)|(Cin&b);

endmodule

module flipflop(Clock, Reset_b, q, ALUout);
    input Clock, Reset_b;
    input [7:0]q; 
    output reg [7:0]ALUout; 

    always @(posedge Clock)
    begin
        if (!Reset_b) 
            ALUout <= 8'b0;
        else 
            ALUout <= q;
    end
endmodule
