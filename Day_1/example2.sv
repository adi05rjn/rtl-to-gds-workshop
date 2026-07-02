class sample;
  integer a;
  task print();
    $display("workshop");
  endtask
endclass
module top;
  sample s1,s2,s3;
  initial begin
    s1 = new();
    s2 = new();
    s3 = new();
    s1.a = 10;
    s2.a = 20;
    s3.a = 25;
    s1.print();
    s2.print();
    s3.print();
    $display("s1.a = %0d", s1.a);
    $display("s2.a = %0d", s2.a);
    $display("s3.a = %0d", s3.a);
  end
endmodule
