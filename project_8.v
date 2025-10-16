module project_8 (
  input i_Clk,
  input i_UART_RX,
  output o_UART_TX,
  output o_Segment1_A,
  output o_Segment1_B,
  output o_Segment1_C,
  output o_Segment1_D,
  output o_Segment1_E,
  output o_Segment1_F,
  output o_Segment1_G,
  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G
  );

  wire [7:0] uart_receiver_output;
  wire read_n_write_flag;

  UART_receiver U_RX(
    .i_uart(i_UART_RX),
    .i_clk(i_Clk),
    .o_read_flag(read_n_write_flag),
    .o_bin(uart_receiver_output)
    );

  UART_transmitter U_TX(
    .i_bin(uart_receiver_output),
    .i_clk(i_Clk),
    .i_write_flag(read_n_write_flag),
    .o_uart(o_UART_TX)
    );

  bin_to_7seg U2(
    .i_bin(uart_receiver_output),
    .o_Segment1_A(o_Segment1_A),
    .o_Segment1_B(o_Segment1_B),
    .o_Segment1_C(o_Segment1_C),
    .o_Segment1_D(o_Segment1_D),
    .o_Segment1_E(o_Segment1_E),
    .o_Segment1_F(o_Segment1_F),
    .o_Segment1_G(o_Segment1_G),
    .o_Segment2_A(o_Segment2_A),
    .o_Segment2_B(o_Segment2_B),
    .o_Segment2_C(o_Segment2_C),
    .o_Segment2_D(o_Segment2_D),
    .o_Segment2_E(o_Segment2_E),
    .o_Segment2_F(o_Segment2_F),
    .o_Segment2_G(o_Segment2_G)
    );

endmodule
