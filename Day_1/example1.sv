module top;
  integer a;
  task print();
    $display("Workshop");
  endtask
  initial begin
    a = 10;
    $display("a = %0d", a);
    print();
  end
endmodule
