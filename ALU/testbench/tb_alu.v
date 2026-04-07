module tb_alu_top;
  reg clk;
  reg rst_n;
  reg [15:0] alu_cmd_in;
  reg [7:0]  alu_in_1;
  reg [7:0]  alu_in_2;
  wire [15:0] alu_out;
  wire alu_out_valid;

  alu_top dut (
      .clk(clk),
      .rst_n(rst_n),
      .alu_cmd_in(alu_cmd_in),
      .alu_in_1(alu_in_1),
      .alu_in_2(alu_in_2),
      .alu_out(alu_out),
      .alu_out_valid(alu_out_valid)
  );

  initial begin
      clk = 0;
      forever #10 clk = ~clk; // T = 1 / f
                             //Clk half period is 10ns

  end
  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, tb_alu_top);
    $monitor("t=%0t cmd=%h a=%0d b=%0d | out=%0d valid=%b",
             $time, alu_cmd_in, alu_in_1, alu_in_2, alu_out,
             alu_out_valid);
  
        rst_n      = 1'b0;
        alu_cmd_in = 16'd0;
        alu_in_1   = 8'd0;
        alu_in_2   = 8'd0;

        #30;
        rst_n = 1'b1;

        @(negedge clk); // negedge becuase posedge 
    				// causes race conditions
        alu_cmd_in = 16'h0001;
        alu_in_1   = 8'd8;
        alu_in_2   = 8'd3;

        #80; // 4 clock cycle delays so the inputs dont change beofre fsm completes a cycle

        @(negedge clk);
        alu_cmd_in = 16'h0002;
        alu_in_1   = 8'd9;
        alu_in_2   = 8'd4;

        #80;

        @(negedge clk);
        alu_cmd_in = 16'h0400;
        alu_in_1   = 8'd5;
        alu_in_2   = 8'd6;

        #80;

        @(negedge clk);
        alu_cmd_in = 16'h0800;
        alu_in_1   = 8'd20;
        alu_in_2   = 8'd4;

        #80;

        @(negedge clk);
        alu_cmd_in = 16'h1000;
        alu_in_1   = 8'd20;
        alu_in_2   = 8'd6;

        #80;

        @(negedge clk);
        alu_cmd_in = 16'd0;
        alu_in_1   = 8'd0;
        alu_in_2   = 8'd0;

        #40;
        $finish;
    end

endmodule
