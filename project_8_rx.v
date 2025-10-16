module UART_receiver
  #(
    parameter BAUD_RATE = 115200,
    parameter CLK_FREQ  = 25000000
    )
  (
    input i_uart,
    input i_clk,
    output o_read_flag,
    output [7:0] o_bin
  );

  // (0) IDLE: wait for a falling edge, then enter START
  // (1) START: wait for delay, one cycle
  // (2) BIT_READ: wait for half a cycle to check input and write to a bit, then after half a cycle move to next bit and repeat until all 8 bits have been written
  // (3) STOP: wait for delay, one cycle

  parameter BAUD_PERIOD = CLK_FREQ/BAUD_RATE;

  reg [1:0] state = 2'b00;
  reg [7:0] period_counter = 0;

  reg last_signal = 0;

  reg [7:0] byte_read;
  reg [2:0] byte_index=0;
  reg [7:0] r_bin = 0;

  reg r_read_flag = 0;

  always @ (posedge i_clk) begin
    case (state)
      0:
        begin
          r_read_flag <= 0;
          if (last_signal == 1'b1 && i_uart == 1'b0) begin
            state <= 1;
            period_counter <= BAUD_PERIOD;
          end
        end
      1:
        begin
          period_counter <= period_counter-1;
        	if (period_counter == 8'b0000_0000) begin
            state <= 2;
            period_counter <= BAUD_PERIOD;
            byte_index <= 0;
          end
        end
      2:
        begin
          period_counter <= period_counter-1;
          if (period_counter == BAUD_PERIOD/2) begin
            byte_read[byte_index] <= i_uart;
          end
          if (period_counter == 0) begin
            period_counter <= BAUD_PERIOD;
            byte_index <= byte_index+1;
            if (byte_index == 3'b111) begin
              state <= 3;
              r_bin <= byte_read;
            end
          end
        end
        3:
          begin
            period_counter <= period_counter-1;
            r_read_flag <= 1;
            if (period_counter == 8'b0000_0000) begin
              state <= 0;
              r_read_flag <= 0;
            end
          end
    endcase

    last_signal <= i_uart;
  end

  assign o_bin = r_bin;
  assign o_read_flag = r_read_flag;

endmodule
