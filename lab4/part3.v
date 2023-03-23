module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
    input [7:0] Data_IN;
    input clock, reset, ParallelLoadn, RotateRight, ASRight;
    output reg [7:0] Q;

    reg [7:0] regout = 0;

    always @(posedge clock)
    begin
        if (reset) 
            regout <=8'b0;
        else if (ParallelLoadn == 0)
            regout <= Data_IN;
            Q <= Data_IN; 
    end

    always @(*)
    begin
        if ((ParallelLoadn)&&(RotateRight)&&(ASRight==0))
            regout = {Q[0], Q[7:1]};
        else if ((ParallelLoadn)&&(RotateRight)&&(ASRight))
            regout = {0,Q[7:1]};
        else if ((ParallelLoadn)&&(RotateRight==0))
            regout = {Q[6:0], Q[7]};
    end

    always @(posedge clock)
    begin
        if (reset)
            Q<=8'b0;
        else
            Q<=regout;
    end

endmodule
