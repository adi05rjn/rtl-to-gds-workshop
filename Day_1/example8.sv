mailbox mb = new();

module top;
  task issue();
    int a[10];
    for(int i=0;i<10;i++) begin
      a[i] = $urandom_range(10, 100);
      mb.put(a[i]);
    end
    $display("a = %p",a);
  endtask
  
  task collect();
    int b[10];
    for(int i=0;i<10;i++) begin
      mb.get(b[i]);
    end
    $display("b = %p",b);
  endtask
  
  initial begin
    issue();
    collect();
  end
endmodule
