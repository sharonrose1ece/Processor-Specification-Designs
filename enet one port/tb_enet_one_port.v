module tb_enet_one_port;
reg clk;
  reg rst_n;
  reg [63:0] in_port_data;
  reg in_port_data_valid;

  wire [63:0] out_port_data;
  wire out_port_data_sop;
  wire out_port_data_eop;

  enet_one_port dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_port_data(in_port_data),
    
    .in_port_data_valid(in_port_data_valid),
    .out_port_data(out_port_data),
    
    .out_port_data_sop(out_port_data_sop),
    .out_port_data_eop(out_port_data_eop)
  );

  always #5 clk = ~clk;

  integer i;

  initial begin
    $dumpfile("packet_parser_single_port.vcd");
    $dumpvars(0, tb_enet_one_port);

    clk = 0;
    
     rst_n = 0;
    in_port_data = 0;
    in_port_data_valid = 0;

    #12 rst_n = 1;

    #8;
    in_port_data_valid = 1;

    for (i = 0; i < 10; i = i + 1) begin
      in_port_data = i + 1;
      #10;
    end

    in_port_data_valid = 0;
    
    in_port_data = 0;

    #150;
    $finish;
  end

  initial begin
    $monitor("t=%0t valid=%b in=%0d out=%0d sop=%b eop=%b count=%0d",
             $time, in_port_data_valid, in_port_data,
             
       out_port_data, out_port_data_sop, out_port_data_eop,
             dut.em.count);
  end

endmodule
