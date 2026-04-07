module enet_four_port ( // main module 2 - what we are doing
  input wire clk,
  input wire rst_n,
input wire [63:0] in_port_data0,
  input wire [63:0] in_port_data1,
  
  input wire [63:0] in_port_data2,
  input wire [63:0] in_port_data3,
  input wire [3:0]  in_port_data_valid,

  output wire [63:0] out_port_data0,
  output wire [63:0] out_port_data1,
 
output wire [63:0] out_port_data2,
  output wire [63:0] out_port_data3,
  output wire [3:0]  out_port_data_sop,
  output wire [3:0]  out_port_data_eop
);

  enet_one_port p0 (
    .clk(clk), .rst_n(rst_n),
    .in_port_data(in_port_data0),
    .in_port_data_valid(in_port_data_valid[0]),
    .out_port_data(out_port_data0),
    .out_port_data_sop(out_port_data_sop[0]),
    .out_port_data_eop(out_port_data_eop[0])
  );

  enet_one_port p1 (
    .clk(clk), .rst_n(rst_n),
    .in_port_data(in_port_data1),
    .in_port_data_valid(in_port_data_valid[1]),
    .out_port_data(out_port_data1),
    .out_port_data_sop(out_port_data_sop[1]),
    .out_port_data_eop(out_port_data_eop[1])
  );

  enet_one_port p2 (
    .clk(clk), .rst_n(rst_n),
    .in_port_data(in_port_data2),
    .in_port_data_valid(in_port_data_valid[2]),
    .out_port_data(out_port_data2),
    .out_port_data_sop(out_port_data_sop[2]),
    .out_port_data_eop(out_port_data_eop[2])
  );

  enet_one_port p3 (
    .clk(clk), .rst_n(rst_n),
    .in_port_data(in_port_data3),
    .in_port_data_valid(in_port_data_valid[3]),
    .out_port_data(out_port_data3),
    .out_port_data_sop(out_port_data_sop[3]),
    .out_port_data_eop(out_port_data_eop[3])
  );

endmodule


module enet_one_port ( //main module 1
  input wire clk,
  input wire rst_n,
  input wire [63:0] in_port_data,
  input wire in_port_data_valid,
  output wire [63:0] out_port_data,
  output wire out_port_data_sop,
  output wire out_port_data_eop
);

  reg valid_d;

  wire valid_fall;
  wire pop;
  wire count_gt_zero;
  wire count_eq_one;
  wire [3:0] count_wire;

  assign valid_fall = valid_d && !in_port_data_valid;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      valid_d <= 0;
    else
      valid_d <= in_port_data_valid;
  end

  edge_marker em (
    .clk(clk),
    .rst_n(rst_n),
    .up_dn(in_port_data_valid),
    .valid_intr(pop),
    .count(count_wire),
    .count_gt_zero(count_gt_zero),
    .count_eq_one(count_eq_one)
  );

  glue_logic gl (
    .valid_fall(valid_fall),
    .count_gt_zero(count_gt_zero),
    .count_eq_one(count_eq_one),
    .pop(pop),
    .sop(out_port_data_sop),
    .eop(out_port_data_eop)
  );

  data_buffer db (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(in_port_data),
    .push(in_port_data_valid),
    .pop(pop),
    .data_out(out_port_data)
  );

endmodule


module data_buffer (
  input wire clk,
  input wire rst_n,
  input wire [63:0] data_in,
  input wire push,
  input wire pop,
  output reg [63:0] data_out
);

  reg [63:0] mem [0:15];
  reg [3:0] wr_ptr;
  reg [3:0] rd_ptr;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      data_out <= 0;
    end else begin
      if (push) begin
        mem[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
        data_out <= 0;
      end else if (pop) begin
        data_out <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
      end else begin
        data_out <= 0;
      end
    end
  end

endmodule


module edge_marker (
  input wire clk,
  input wire rst_n,
  input wire up_dn,
  input wire valid_intr,
  output reg [3:0] count,
  output wire count_gt_zero,
  output wire count_eq_one
);

  assign count_gt_zero = (count > 0);
  
assign count_eq_one  = (count == 1);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= 0;
    end else begin
    
      if (up_dn)
        
        count <= count + 1;
      else if (valid_intr && count_gt_zero)
        count <= count - 1;
    end
  end

endmodule


module glue_logic (
  input wire valid_fall,
  input wire count_gt_zero,
  input wire count_eq_one,
  output wire pop,
  output wire sop,
  output wire eop
);

  assign pop = valid_fall || count_gt_zero;
  
  assign sop = valid_fall;
  assign eop = count_eq_one;

endmodule



