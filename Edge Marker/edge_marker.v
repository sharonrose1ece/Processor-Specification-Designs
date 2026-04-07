module edge_marker (
  
  input  wire clk,
  input  wire rst_n,
  input  wire [63:0] in_port_data,
  input  wire in_port_data_valid,
  output reg [63:0] out_port_data,
  output wire out_port_data_sop,
  output wire out_port_data_eop
);

  wire data_valid_1d;

  dff_valid u_dff_valid (
    
    .clk(clk),
    .rst_n(rst_n),
     .d(in_port_data_valid),
    .q(data_valid_1d)
  );
  sop_eop_generator u_sop_eop_generator (
    .in_port_data_valid(in_port_data_valid),
    .data_valid_1d(data_valid_1d),
    .out_port_data_sop(out_port_data_sop),
    .out_port_data_eop(out_port_data_eop)
  );
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      out_port_data <= 64'd0;
    else if (in_port_data_valid)
      out_port_data <= in_port_data;
    else
      out_port_data <= 64'd0;
  end

endmodule






module dff_valid (
  input  wire clk,
  input  wire rst_n,
  input  wire d,
  output reg  q
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      q <= 1'b0;
    else
      q <= d;
  end

endmodule







module sop_eop_generator (
  input  wire in_port_data_valid,
  input  wire data_valid_1d,
  output wire out_port_data_sop,
  output wire out_port_data_eop
);
  assign out_port_data_sop =  in_port_data_valid & ~data_valid_1d;
  assign out_port_data_eop = ~in_port_data_valid & data_valid_1d;

endmodule



