module part3(A, B, Function, ALUout);
    input [3:0] A, B;
	input [2:0] Function;
    output reg [7:0] ALUout;
	wire [3:0] addOut;
	wire cout;
	part2 u1(A, B, 1'b0, addOut[3:0], cout);

	always @(*)
	begin
		case(Function[2:0])
			3'b000: ALUout = addOut;
			3'b001: ALUout = (A+B);
			3'b010: ALUout = {4'b0, B};
			3'b011: begin
				if((A|B) == 1)
						ALUout = 8'b00000001;
				else
						ALUout = 8'b0;
			end
			3'b100: begin 
				if((A&&B) == 1)
						ALUout = 8'b00000001;
				else
						ALUout = 8'b0;
			end
			3'b101: ALUout = {A, B};
			default: ALUout = 8'b0;
		endcase
	end

endmodule 


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
