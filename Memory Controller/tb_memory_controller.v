module tb_memory_controller;

  reg clk;
  reg rst_n;
  reg rd_wr_valid;
  reg rd_wr_mem;
  reg [10:0] mem_addr;
  reg [7:0] wr_data;

  wire [7:0] rd_data;
  wire [2:0] err_status;

  memory_controller dut (
    .clk(clk),
    .rst_n(rst_n),
    .rd_wr_valid(rd_wr_valid),
    .rd_wr_mem(rd_wr_mem),
    .mem_addr(mem_addr),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .err_status(err_status)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("memory_controller.vcd");
    $dumpvars(0, tb_memory_controller);

    clk = 0;
    rst_n = 0;
    rd_wr_valid = 0;
    rd_wr_mem = 0;
    mem_addr = 0;
    wr_data = 0;

    #10 rst_n = 1;

    // write normal
    #10 rd_wr_valid = 1;
    rd_wr_mem = 1;
    mem_addr = 100;
    wr_data = 55;

    // write to read only (error)
    #10 mem_addr = 1000;

    // read normal
    #10 rd_wr_mem = 0;
    mem_addr = 100;

    // read from write only (error)
    #10 mem_addr = 200;

    // reserved
    #10 mem_addr = 1300;

    // no operation done
    #10 rd_wr_valid = 0;

    #20 $finish;
  end

  initial begin
    $monitor("t=%0t valid=%b rw=%b addr=%0d wr=%0d rd=%0d err=%b",
             $time, rd_wr_valid, rd_wr_mem,
             mem_addr, wr_data, rd_data, err_status);
  end

endmodule
