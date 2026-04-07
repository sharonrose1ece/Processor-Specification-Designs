module memory_controller (
  input wire clk,
  input wire rst_n,
  input wire rd_wr_valid,
  input wire rd_wr_mem,     // 1 = write, 0 = read
  input wire [10:0] mem_addr,
  input wire [7:0] wr_data,

  output reg [7:0] rd_data,
  output reg [2:0] err_status
);
//3'b000 = no error
//3'b001 = read in write-only
//3'b010 = write in read-only
//3'b100 = reserved access
  
//write-only: 64 to 319
//read-only: 960 to 1215
//reserved: 1280 to 1343
  
//some logic: reset low → rd_data = 0, err_status = 0
//if rd_wr_valid = 0, no operation
//if rd_wr_valid = 1 and rd_wr_mem = 1, do write
//if rd_wr_valid = 1 and rd_wr_mem = 0, do read
  reg [7:0] mem [0:2047];

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_data <= 0;
      err_status <= 0;
    end else begin

      rd_data <= 0; //set defaults
      err_status <= 0;

      if (rd_wr_valid) begin

        
        if (mem_addr >= 1280 && mem_addr <= 1343) begin
          err_status <= 3'b100;
        end

        
        else if (rd_wr_mem == 1) begin //write 
          if (mem_addr >= 960 && mem_addr <= 1215) begin
            err_status <= 3'b010; // write in read-only
          end else begin
            mem[mem_addr] <= wr_data;
          end
        end

        
        else begin //read
          if (mem_addr >= 64 && mem_addr <= 319) begin
            err_status <= 3'b001; // read in write-only
          end else begin
            rd_data <= mem[mem_addr];
          end
        end

      end

    end
  end

endmodule
