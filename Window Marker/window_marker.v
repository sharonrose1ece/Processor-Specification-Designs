module window_marker (
  input wire clk,
  input wire rst_n,
  input wire [63:0] in_port_data,
  input wire in_port_data_sop,
  input wire in_port_data_eop,
  output reg [63:0] out_port_data,
  output reg out_port_data_valid
);

  reg active;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      active <= 1'b0;
      out_port_data <= 64'd0;
      out_port_data_valid <= 1'b0;
    end else begin

      if (in_port_data_sop)
        active <= 1'b1;
      else if
        (in_port_data_eop)
        
        active <= 1'b0;

     
      if (active || in_port_data_sop) begin
        
        out_port_data <= in_port_data;
        out_port_data_valid <= 1'b1;
      end else begin
        out_port_data <= 64'd0;
        
        out_port_data_valid <= 1'b0;
      end

    end
  end

endmodule


