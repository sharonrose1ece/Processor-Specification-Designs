module tb_edge_marker;

  reg clk;
  reg rst_n;
  reg [63:0]  in_port_data;
  reg in_port_data_valid;

  wire [63:0] out_port_data;
  wire out_port_data_sop;
  wire out_port_data_eop;

  edge_marker dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_port_data(in_port_data),
    .in_port_data_valid(in_port_data_valid),
    .out_port_data(out_port_data),
    .out_port_data_sop(out_port_data_sop),
    .out_port_data_eop(out_port_data_eop)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("edge_marker.vcd");
    $dumpvars(0, tb_edge_marker);

    clk = 0;
    rst_n = 0;
    in_port_data = 64'd0;
    in_port_data_valid = 1'b0;

    #10 rst_n = 1;

    #10;
    in_port_data_valid = 1'b1;
    in_port_data = 64'd1;

    #10;
    in_port_data = 64'd2;

    #10;
    in_port_data = 64'd3;

    #10;
    in_port_data = 64'd4;

    #10;
    in_port_data_valid = 1'b0;
    in_port_data = 64'd0;

    #10;

    #10;
    in_port_data_valid = 1'b1;
    in_port_data = 64'd7;

    #10;
    in_port_data = 64'd8;

    #10;
    in_port_data = 64'd9;

    #10;
    in_port_data_valid = 1'b0;
    in_port_data = 64'd0;

    #20;
    $finish;
  end

  initial begin
    $monitor("t=%0t clk=%b rst_n=%b valid=%b in_data=%0d out_data=%0d sop=%b eop=%b data_valid_1d=%b",
             $time, clk, rst_n, in_port_data_valid,
             in_port_data, out_port_data,
             out_port_data_sop, out_port_data_eop,
             dut.data_valid_1d);
  end

endmodule
