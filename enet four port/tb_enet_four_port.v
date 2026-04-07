module tb_enet_four_port;
 reg clk;
  reg rst_n;

  reg [63:0] in_port_data0, in_port_data1, in_port_data2, in_port_data3;
  reg [3:0]  in_port_data_valid;
wire [63:0] out_port_data0, out_port_data1, out_port_data2, out_port_data3;
  wire [3:0]  out_port_data_sop;
  wire [3:0]  out_port_data_eop;

  enet_four_port dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_port_data0(in_port_data0),
    .in_port_data1(in_port_data1),
    .in_port_data2(in_port_data2),
    .in_port_data3(in_port_data3),
    .in_port_data_valid(in_port_data_valid),
    .out_port_data0(out_port_data0),
    .out_port_data1(out_port_data1),
    .out_port_data2(out_port_data2),
    .out_port_data3(out_port_data3),
    .out_port_data_sop(out_port_data_sop),
    .out_port_data_eop(out_port_data_eop)
  );

  always #5 clk = ~clk;

  integer i;

  initial begin
    $dumpfile("enet_four_port.vcd");
    $dumpvars(0, tb_enet_four_port);

    clk = 0;
    rst_n = 0;

    in_port_data_valid = 0;
    in_port_data0 = 0;
    in_port_data1 = 0;
    in_port_data2 = 0;
    in_port_data3 = 0;

    #10 rst_n = 1;

    in_port_data_valid = 4'b1111; // we send packet on 4 ports

    for (i = 0; i < 10; i = i + 1) begin
      in_port_data0 = i + 1;
      in_port_data1 = i + 10;
      in_port_data2 = i + 20;
      in_port_data3 = i + 30;
      #10;
    end

    in_port_data_valid = 0;

    #200;
    $finish;
  end

endmodule
