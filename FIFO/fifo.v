module fifo (
  input  wire clk,
  input  wire rst_n,
  input  wire push,
  input  wire pop,
  input  wire [7:0] data_in,

  output reg  [7:0] data_out,
  output reg full,
  output reg empty,
  output reg push_on_full_error,
  output reg pop_on_empty_error,
  output reg  almost_full,
  output reg  almost_empty
);

  parameter FIFO_DEPTH = 1024;
  
  parameter DATA_WIDTH = 8;
  parameter ALMOST_FULL_THRESHOLD  = 10;
  parameter ALMOST_EMPTY_THRESHOLD = 5;

  reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];
  reg [9:0]  write_pointer;
  reg [9:0]  read_pointer;
  
  reg [10:0] count;
  reg [10:0] next_count;

  always @(*) begin
    next_count = count;

    if (push && !pop && count != FIFO_DEPTH)
      next_count = count + 1;
    else if (pop && !push && count != 0)
      next_count = count - 1;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      write_pointer      <= 10'd0;
      read_pointer       <= 10'd0;
      count              <= 11'd0;
      data_out           <= 8'd0;
      full               <= 1'b0;
      empty              <= 1'b1;
      push_on_full_error <= 1'b0;
      pop_on_empty_error <= 1'b0;
      almost_full        <= 1'b0;
      almost_empty       <= 1'b1;
    end else begin
      push_on_full_error <= 1'b0;
      pop_on_empty_error <= 1'b0;

      if (push && !pop) begin
        if (count == FIFO_DEPTH) begin
          push_on_full_error <= 1'b1;
        end else begin
          fifo_mem[write_pointer] <= data_in;

          if (write_pointer == FIFO_DEPTH-1)
            write_pointer <= 10'd0;
          else
            write_pointer <= write_pointer + 1'b1;

          count <= next_count;
        end
      end
      else if (pop && !push) begin
        if (count == 0) begin
          pop_on_empty_error <= 1'b1;
        end else begin
          data_out <= fifo_mem[read_pointer];

          if (read_pointer == FIFO_DEPTH-1)
            read_pointer <= 10'd0;
          else
            read_pointer <= read_pointer + 1'b1;

          count <= next_count;
        end
      
      end
      else begin
        count <= next_count;
      
      end

      full         <= (next_count == FIFO_DEPTH);
      
      empty        <= (next_count == 0);
      
      almost_full  <= (next_count >= (FIFO_DEPTH - ALMOST_FULL_THRESHOLD));
      almost_empty <= (next_count <= ALMOST_EMPTY_THRESHOLD);
    end
  end

endmodule
