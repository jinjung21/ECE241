module part3(ClockIn, Resetn, Start, Letter, DotDashOut, NewBitOut);

    input ClockIn, Resetn, Start;
    input [2:0]Letter;
    output DotDashOut, NewBitOut;

    wire [11:0]letter_out;
    wire shift_out;
    assign NewBitOut = shift_out;
    
    LUT l1(Letter, letter_out);
    RateDivider r1(ClockIn, Resetn, Start, shift_out);
    shift s1(ClockIn, Resetn, Start, shift_out, letter_out, DotDashOut);

endmodule

module LUT(Letter, letter_out);
    input [2:0] Letter;
    output reg [11:0] letter_out;

    always @(*)
        case(Letter[2:0])
            3'b000: letter_out = {5'b10111, 7'b0}; //A
            3'b001: letter_out = {9'b111010101, 3'b0}; //B
            3'b010: letter_out = {11'b11101011101, 1'b0}; //C
            3'b011: letter_out = {7'b1110101, 5'b0}; //D
            3'b100: letter_out = {1'b1, 11'b0}; //E
            3'b101: letter_out = {9'b101011101, 3'b0}; //F
            3'b110: letter_out = {9'b111011101, 3'b0}; //G
            3'b111: letter_out = {7'b1010101, 5'b0}; //H
            default: letter_out = 12'b0;
        endcase

endmodule

module RateDivider(ClockIn, Resetn, Start, enable);
    input ClockIn, Resetn, Start;
    output enable;

    reg [7:0] CounterValue;

    always @(posedge ClockIn, negedge Resetn)
        begin
            if(Resetn == 1'b0)
                CounterValue <= 0;
            else if(Start == 1'b1) 
                CounterValue <= 8'b11111001;
            else
                if(CounterValue == 8'b0)
                    CounterValue <= 8'b11111001; 
                else
                    CounterValue <= CounterValue-1;
        end

    assign enable = (CounterValue == 8'b0) ? 1:0;

endmodule

module shift(ClockIn, Resetn, ParLoad, enable, letter_out, out);
    input ClockIn, Resetn, ParLoad, enable;
    input [11:0] letter_out;
    output out;

    reg [11:0] Q;

    always @ (posedge ClockIn, negedge Resetn)
        begin
            if(Resetn == 1'b0)
                Q <= 0;
            else if(ParLoad == 1'b1)
                Q <= letter_out;
            else if(enable == 1'b1)
                Q = Q << 1;
        end

    assign out = Q[11];

endmodule
