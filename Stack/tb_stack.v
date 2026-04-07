module tb_stack;

  reg clk;
  reg rst_n;
  reg push;
  reg pop;
  reg [7:0] in_data;

  wire [7:0] out_data;
  wire full;
  wire empty;
  wire push_err_on_full;
  wire pop_err_on_empty;

  stack dut (
    .clk(clk),
    .rst_n(rst_n),
    
    .push(push),
    .pop(pop),
    
    .in_data(in_data),
    .out_data(out_data),
    
    .full(full),
    .empty(empty),
    .push_err_on_full(push_err_on_full),
    .pop_err_on_empty(pop_err_on_empty)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("stack.vcd");
    $dumpvars(0, tb_stack);

    clk = 0;
    rst_n = 0;
    push = 0;
    pop = 0;
    in_data = 8'd0;

    #10 rst_n = 1;
    #10;

    push = 1;
    in_data = 8'd10;

    #10;
    in_data = 8'd20;

    #10;
    in_data = 8'd30;

    #10;
    push = 0; // data stops coming

    #10;
    pop = 1;

    #10;
    #10;
    #10;
    #10;

    pop = 0; // pop is now stopped

    #20;
    $finish;
  end

  initial begin
    $monitor("t=%0t clk=%b rst_n=%b push=%b pop=%b in_data=%0d out_data=%0d pointer=%0d full=%b empty=%b push_err=%b pop_err=%b",
             $time, clk, rst_n, push, pop, in_data, out_data,
             dut.pointer, full, empty,
             push_err_on_full, pop_err_on_empty);
  end

endmodule
