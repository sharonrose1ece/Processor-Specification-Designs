module tb_qos;

  reg clk;
  reg rst_n;
  reg new_pkt_in;
  reg [3:0] recharge;

  wire [7:0] available_credit;
  wire no_available_credit;

  qos dut (
    .clk(clk),
    .rst_n(rst_n),
    .new_pkt_in(new_pkt_in),
    .recharge(recharge),
    .available_credit(available_credit),
    .no_available_credit(no_available_credit)
  );

  always #10 clk = ~clk; // Clock

  initial begin
    $dumpfile("qos.vcd");
    $dumpvars(0, tb_qos);

    clk = 0;
    rst_n = 0;
    new_pkt_in = 0;
    recharge = 4'd3;

    #10 rst_n = 1;

    repeat (10) begin
      #10 new_pkt_in = 1; // send packet
      #10 new_pkt_in = 0;
    end

    #100;
    $finish;
  end

  initial begin
    $monitor("t=%0t | pkt=%b | available_credit=%0d no_available_credit=%b",
             $time, new_pkt_in, available_credit, no_available_credit);
  end

endmodule
