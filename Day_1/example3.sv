class sample;
  rand int a;
  rand int b;
  constraint c1{a inside {[20:50]};}
  constraint c2{b>25; b<100;}
endclass

module top;
  sample s;
  initial begin
    s = new();
    repeat(10) begin
      s.randomize();
      $display("a = %0d", s.a);
      $display("b = %0d", s.b);
    end
  end
endmodule
