module alu_top (
    input  wire clk,
    input  wire rst_n,
    input  wire [15:0] alu_cmd_in,
  input  wire [7:0] alu_in_1,
    input  wire [7:0] alu_in_2,
    output reg  [15:0] alu_out,
    output reg alu_out_valid
);

    
    reg [15:0] result_reg;
    reg [15:0] alu_result;
    reg [15:0] prev_cmd;
  reg [1:0]  state;

    parameter IDLE  = 2'b00;
    parameter WAIT = 2'b01;
    parameter DONE  = 2'b10;

    always @(*) begin
        alu_result = 16'd0;

        case (1'b1)
            alu_cmd_in[0]  : alu_result = alu_in_1 + alu_in_2;
          // ADD
            alu_cmd_in[1]  : alu_result = alu_in_1 - alu_in_2;             // SUB
            alu_cmd_in[2]  : alu_result = alu_in_1 << alu_in_2;             // LS
            alu_cmd_in[3]  : alu_result = alu_in_1 >> alu_in_2;              // RS
            alu_cmd_in[4]  : alu_result = alu_in_1 | alu_in_2;              // B_OR
            alu_cmd_in[5]  : alu_result = (alu_in_1 && alu_in_2);            // L_AND
            alu_cmd_in[6]  : alu_result = ~(alu_in_1 ^ alu_in_2);             // B_XNOR
            alu_cmd_in[7]  : alu_result = (alu_in_1 || alu_in_2);             // L_OR
            alu_cmd_in[8]  : alu_result = ~^alu_in_1;                             // R_XNOR
            alu_cmd_in[9]  : alu_result = ^alu_in_1;                           // R_XOR
            alu_cmd_in[10] : alu_result = alu_in_1 * alu_in_2;                          // MULT
            alu_cmd_in[11] : alu_result = (alu_in_2 != 0) ?
              (alu_in_1 / alu_in_2) : 0; // DIV
            alu_cmd_in[12] : alu_result = (alu_in_2 != 0) ?
              (alu_in_1 % alu_in_2) : 0; // MOD
            alu_cmd_in[13] : alu_result = $signed(alu_in_1) 
              <<<
              alu_in_2; // LS_W_S
            alu_cmd_in[14] : alu_result = $signed(alu_in_1)
              >>> 
              alu_in_2; // RS_W_S
            default : alu_result = 16'd0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            result_reg    <= 16'd0;
            alu_out       <= 16'd0;
            alu_out_valid <= 1'b0;
            prev_cmd      <= 16'd0;
        end
        else begin
            // detect command change
            if (alu_cmd_in != prev_cmd) begin
                state         <= IDLE;
                alu_out_valid <= 1'b0;
                prev_cmd      <= alu_cmd_in;
            end
            else begin
                case (state)

                    IDLE: begin
                        alu_out_valid <= 1'b0;
                        prev_cmd      <= alu_cmd_in;

                        if (alu_cmd_in != 16'd0) begin
                            result_reg <= alu_result;
                            state      <= WAIT;
                        end
                    end

                    WAIT: begin
                        alu_out_valid <= 1'b0;
                        prev_cmd      <= alu_cmd_in;
                        state         <= DONE;
                    end

                    DONE: begin
                        alu_out       <= result_reg;
                        alu_out_valid <= 1'b1;
                        prev_cmd      <= alu_cmd_in;
                    end

                    default: begin
                        state         <= IDLE;
                        alu_out_valid <= 1'b0;
                        prev_cmd      <= alu_cmd_in;
                    end

                endcase
            end
        end
    end

endmodule
