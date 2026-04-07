module tb_window_marker;

  reg clk;
  reg rst_n;
  reg [63:0] in_port_data;
  reg in_port_data_sop;
  reg in_port_data_eop;
 wire [63:0] out_port_data;
  wire out_port_data_valid;

  window_marker dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_port_data(in_port_data),
    .in_port_data_sop(in_port_data_sop),
    .in_port_data_eop(in_port_data_eop),
    .out_port_data(out_port_data),
    .out_port_data_valid(out_port_data_valid)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("window_marker.vcd");
    $dumpvars(0, tb_window_marker);

    clk = 0;
    rst_n = 0;
    in_port_data = 64'd0;
    in_port_data_sop = 1'b0;
    in_port_data_eop = 1'b0;

    #10 rst_n = 1;

   
    #10;
    in_port_data = 64'h1; // first beat
    in_port_data_sop = 1'b1;
    in_port_data_eop = 1'b0;

    
    #10;
    in_port_data = 64'h2; // middle beats
    in_port_data_sop = 1'b0;
#10;
    in_port_data = 64'h3;
    #10;
    in_port_data = 64'h4;

   
    #10;
    in_port_data = 64'h5;  // last beat
    in_port_data_eop = 1'b1;

    #10;
    in_port_data = 64'd0;
    in_port_data_eop = 1'b0;

    #30;
    $finish;
  end

  initial begin
    $monitor("t=%0t sop=%b eop=%b in=%0d out=%0d valid=%b",
             $time, in_port_data_sop, in_port_data_eop,
             in_port_data, out_port_data, out_port_data_valid);
  end

endmodule
