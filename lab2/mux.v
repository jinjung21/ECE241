`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    mux2to1 u0(
        .x(SW[0]),
        .y(SW[1]),
        .s(SW[9]),
        .m(LEDR[0])
        );
endmodule

module mux2to1 (x,y,s,m);
    input x,y,s;
    output m;

    wire Connection1, Connection2, Connection3;

    v7404 not(
        .pin1(s), .pin2(Connection1)
    );

    v7408 and(
        .pin1(Connection1),
		.pin2(x),
		.pin3(Connection2),
		.pin4(s),
		.pin5(y).
		.pin6(Connection3)
    );

    v7432 o1(
        .pin1(Connection2), .pin2(Connection3), .pin3(m)
    );

endmodule
