class sample;
  static int a;
  static function void print();
    $display("static things");
  endfunction
endclass

module top;
  initial begin
    sample::a = 10;
    $display("a = %0d", sample::a);
    sample::print();
  end
endmodule
