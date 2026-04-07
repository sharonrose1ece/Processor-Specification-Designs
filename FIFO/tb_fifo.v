module tb_fifo;

  reg clk;
  reg rst_n;
  
  reg push;
  reg pop;
  reg [7:0] data_in;

  wire [7:0] data_out;
 
  wire full;
  wire empty;
  wire push_on_full_error;

   wire pop_on_empty_error;
  wire almost_full;
  wire almost_empty;

  fifo fifo_i (
    .clk(clk),
    .rst_n(rst_n),
    .push(push),
    .pop(pop),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty),
    .push_on_full_error(push_on_full_error),
    .pop_on_empty_error(pop_on_empty_error),
    .almost_full(almost_full),
    .almost_empty(almost_empty)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0, tb_fifo);

    clk = 0;
    rst_n = 0;
    push = 0;
    pop = 0;
    data_in = 8'd0;

    #10 rst_n = 1;
    #10;

    push = 1;
    data_in = 8'd10;

    #10;
    data_in = 8'd20;

    #10;
    data_in = 8'd30;

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
    $monitor("t=%0t clk=%b rst_n=%b push=%b pop=%b data_in=%0d data_out=%0d wr_ptr=%0d rd_ptr=%0d count=%0d full=%b empty=%b almost_full=%b almost_empty=%b push_err=%b pop_err=%b",
             $time, clk, rst_n, push, pop, data_in, data_out,
             fifo_i.write_pointer, fifo_i.read_pointer, fifo_i.count,
             full, empty, almost_full, almost_empty,
             push_on_full_error, pop_on_empty_error);
  end

endmodule
