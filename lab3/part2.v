module FA(a, b, Cin, S, Cout);
     input a, b, Cin;
     output S, Cout;
     
     assign S = Cin ^ a ^ b;
     assign Cout = (a&b)|(Cin&a)|(Cin&b);

endmodule

module part2(a, b, c_in, s, c_out);

     input [3:0] a, b;
     input c_in;
     output [3:0] s;
     output [3:0]c_out;
     
     
     FA bit0 (.a(a[0]), .b(b[0]), .Cin(c_in), .S(s[0]), .Cout(c_out[0]));
     FA bit1 (.a(a[1]), .b(b[1]), .Cin(c_out[0]), .S(s[1]), .Cout(c_out[1]));
     FA bit2 (.a(a[2]), .b(b[2]), .Cin(c_out[1]), .S(s[2]), .Cout(c_out[2]));
     FA bit3 (.a(a[3]), .b(b[3]), .Cin(c_out[2]), .S(s[3]), .Cout(c_out[3]));

endmodule
