module part1 (Clock, Enable, Clear_b, CounterValue);
  input Clock, Enable, Clear_b;
  output [7:0] CounterValue;
  
  wire w0, w1, w2, w3, w4, w5, w6;
  assign w0 = Enable & CounterValue[0];
  assign w1 = w0 & CounterValue[1];
  assign w2 = w1 & CounterValue[2];
  assign w3 = w2 & CounterValue[3];
  assign w4 = w3 & CounterValue[4];
  assign w5 = w4 & CounterValue[5];
  assign w6 = w5 & CounterValue[6];
  
  tflipflop t1(Clock, Enable, Clear_b, CounterValue[0]);
  tflipflop t2(Clock, w0, Clear_b, CounterValue[1]);
  tflipflop t3(Clock, w1, Clear_b, CounterValue[2]);
  tflipflop t4(Clock, w2, Clear_b, CounterValue[3]);
  tflipflop t5(Clock, w3, Clear_b, CounterValue[4]);
  tflipflop t6(Clock, w4, Clear_b, CounterValue[5]);
  tflipflop t7(Clock, w5, Clear_b, CounterValue[6]);
  tflipflop t8(Clock, w6, Clear_b, CounterValue[7]);
  
endmodule




module tflipflop(Clock, Enable, Clear_b, Q);

    input Clock, Enable, Clear_b;
    output reg Q;

    always@ (posedge Clock, negedge Clear_b)
        if (Clear_b  == 1'b0)
            Q <= 1'b0;
        else if (Enable == 1'b1)
            Q <= !Q;

endmodule
