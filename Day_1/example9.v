module alu(a,b,c);
  input a,b;
  output reg c;
  
  assign c = a+b;
  or g1(c,a,b);
  always@(*) begin
    c = a+b;
  end
endmodule

module tb;
  reg a,b;
  wire c;
  alu dut(a,b,c);
  
  initial begin
    a = 10;
    b = 5;
    #1;
    $display("a = %0d, b = %0d, c = %0d",a,b,c);
  end
endmodule
