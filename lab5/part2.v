module part2(ClockIn, Reset, Speed, CounterValue);

    input ClockIn, Reset;
    input [1:0] Speed;
    output reg [3:0] CounterValue;

    parameter oneS = 32'd50000000; //50m 
    parameter twoS = 32'd100000000; //100m 
    parameter fourS = 32'd200000000; //200m 
    parameter full = 32'd0;
    reg [31:0] RateDivider;
    wire EnableDC;

    always @ (posedge ClockIn)
    begin
        if(Reset)
            RateDivider <= full;
        else 
            begin
                if(EnableDC) 
                    begin 
                        case(Speed)
                            2'b00: RateDivider <= full; 
                            2'b01: RateDivider <= oneS - 1'b1; 
                            2'b10: RateDivider <= twoS - 1'b1; 
                            2'b11: RateDivider <= fourS - 1'b1;
                            default: RateDivider <= 32'b0; 
                        endcase
                    end
                else 
                    begin
                        RateDivider <= RateDivider - 1'b1;
                    end
            end
    end

    always @ (posedge ClockIn) 
        begin
            if(Reset)
                CounterValue <= 4'h0;
            else if(Reset == 1'b1)
                CounterValue <= RateDivider;
            else if(EnableDC == 1'b1) 
                if(CounterValue == 4'b1111)
                    CounterValue <= 0;
                else
                    CounterValue <= CounterValue + 1;
        end

    assign EnableDC = (RateDivider == 32'd0) ? 1:0;


endmodule
