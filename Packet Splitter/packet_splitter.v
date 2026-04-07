module packet_splitter (
  input wire clk,
  input wire rst_n,
  input wire [63:0] in_port_data,
  
  input wire in_port_data_valid,
  
  output reg [31:0] out_port_data,
  output reg out_port_data_sop,
  output reg out_port_data_eop
);

  reg [63:0] temp;
  reg part;
  reg valid_d;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      temp <= 64'd0;
      part <= 1'b0;
      valid_d <= 1'b0;
      
      out_port_data <= 32'd0;
      out_port_data_sop <= 1'b0;
      out_port_data_eop <= 1'b0;
    end else begin
      out_port_data_sop <= 1'b0;
      out_port_data_eop <= 1'b0;
      
      valid_d <= in_port_data_valid;

      if (in_port_data_valid) begin
       
        
        if (part == 1'b0) begin
          temp <= in_port_data;
          out_port_data <= in_port_data[63:32];
         
          if (valid_d == 1'b0)
            out_port_data_sop <= 1'b1;
          part <= 1'b1;
       
        
        
        
        end else begin
          out_port_data <= temp[31:0];
          part <= 1'b0;
        end
     
      end 
      else 
        begin
        out_port_data <= 32'd0;
        part <= 1'b0;
        if (valid_d == 1'b1)
          out_port_data_eop <= 1'b1;
      end
    end
  end

endmodule


