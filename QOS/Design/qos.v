module qos (
  input  wire clk,
  input  wire rst_n,
  input  wire new_pkt_in,
  input  wire [3:0]recharge,
  output reg  [7:0]  available_credit,
  output reg no_available_credit
);

  reg [2:0] cycle_count;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      available_credit     <= 8'd0;
      cycle_count          <= 3'd0;
      no_available_credit  <= 1'b1;
    end else begin

      if (new_pkt_in && available_credit > 0)
        available_credit <= available_credit - 1; // credit for packet

      if (cycle_count == 3'd4) begin // if cycler 5, then recharge
        cycle_count <= 3'd0;

        if (available_credit + recharge > 8'd255)
          available_credit <= 8'd255;
        else
          available_credit <= available_credit + recharge;

      end else begin
        cycle_count <= cycle_count + 1;
      end
      if (available_credit == 8'd0)
        no_available_credit <= 1'b1;
      else
        no_available_credit <= 1'b0;

    end
  end

endmodule
