mailbox mb = new();

class generator;
  task run();
    int a = 10;
    mb.put(a);
    $display("a = %0d", a);
  endtask
endclass

class driver;
  task run();
    int b;
    mb.get(b);
    $display("b = %0d", b);
  endtask
endclass

module top;
  generator g;
  driver d;
  initial begin
    g = new();
    d = new();
    g.run();
    d.run();
  end
endmodule
