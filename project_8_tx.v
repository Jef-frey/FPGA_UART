module UART_transmitter
  #(
    parameter BAUD_RATE = 115200,
    parameter CLK_FREQ  = 25000000
    )
  (
    input [7:0] i_bin,
    input i_write_flag,
    input i_clk,
    output o_uart
  );

  // (0) IDLE: wait for send signal, then enter START
  // (1) START: wait for delay, one cycle
  // (2) BIT_READ: set output to first bit in input,  wait for a cycle, then output next bit and repeat until all 8 bits have been sent
  // (3) STOP: wait for delay, one cycle

  parameter BAUD_PERIOD = CLK_FREQ/BAUD_RATE;

  reg [1:0] state = 2'b00;
  reg [7:0] period_counter = 0;

  reg [2:0] byte_index = 0;
  reg r_uart = 1;

  always @ (posedge i_clk) begin
    case (state)
      0:
        begin
          r_uart <= 1;
          if (i_write_flag == 1'b1) begin
            state <= 1;
            period_counter <= BAUD_PERIOD;
          end
        end
      1:
        begin
          r_uart <= 0;
          period_counter <= period_counter-1;
        	if (period_counter == 8'b0000_0000) begin
            state <= 2;
            period_counter <= BAUD_PERIOD;
            byte_index <= 0;
          end
        end
      2:
        begin
          r_uart <= i_bin[byte_index];
          period_counter <= period_counter-1;
          if (period_counter == 0) begin
            period_counter <= BAUD_PERIOD;
            byte_index <= byte_index+1;
            if (byte_index == 3'b111) begin
              state <= 3;
            end
          end
        end
        3:
          begin
            r_uart <= 1;
            period_counter <= period_counter-1;
            if (period_counter == 8'b0000_0000) begin
              state <= 0;
            end
          end
    endcase

  end

  assign o_uart = r_uart;

endmodule
