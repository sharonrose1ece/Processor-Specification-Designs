module stack (
  input  wire clk,
  input  wire rst_n,
  input  wire push,
  input  wire   pop,
  input  wire [7:0]  in_data,

  output reg  [7:0]out_data,
  output reg full,
  output reg empty,
  output reg push_err_on_full,
  output reg  pop_err_on_empty
);

  reg [7:0] stack_mem [0:1023];
  reg [9:0] pointer;
  reg [9:0] next_pointer;

  always @(*) begin
    next_pointer = pointer;
    if (push && !pop && pointer != 1023)
      next_pointer = pointer + 1;
    else if (pop && !push && pointer != 0)
      next_pointer = pointer - 1;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pointer          <= 10'd0;
      next_pointer     <= 10'd0;
      out_data         <= 8'd0;
      full             <= 1'b0;
      empty            <= 1'b1;
      push_err_on_full <= 1'b0;
      pop_err_on_empty <= 1'b0;
    end else begin
      push_err_on_full <= 1'b0;
      pop_err_on_empty <= 1'b0;

      if (push && !pop) begin
        if (pointer == 1023) begin
          push_err_on_full <= 1'b1;
        end else begin
          stack_mem[pointer] <= in_data;
          pointer <= next_pointer;
        end
      end
      else if (pop && !push) begin
        if (pointer == 0) begin
          pop_err_on_empty <= 1'b1;
        end else begin
          out_data <= stack_mem[pointer - 1];
          pointer  <= next_pointer;
        end
      end
      else begin
        pointer <= next_pointer;
      end

      full  <= (next_pointer == 1023);
      empty <= (next_pointer == 0);
    end
  end

endmodule
