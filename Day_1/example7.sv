mailbox mb = new();

module source;
  int b;
  initial begin
    mb.put(10);
    mb.put(20);
    mb.put(35);
    mb.put(124);
    mb.put(95);
    repeat(5) begin
      mb.get(b);
      $display("b = %0d",b);
    end
  end
endmodule
