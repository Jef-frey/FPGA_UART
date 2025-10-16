module UART_tb ();

  reg r_clk_tx = 1'b0;
  reg r_clk_rx = 1'b0;

  always #5 r_clk_rx <= ~r_clk_rx;
  int tx_delay = $random()%10;
  initial begin
    #(tx_delay);
   forever #5 r_clk_tx <= ~r_clk_tx;
  end

  reg i_tx = 1'b1;

  parameter BAUD_RATE = 115200;
  parameter CLK_FREQ  = 25000000;
  parameter BAUD_PERIOD = CLK_FREQ/BAUD_RATE*5;

  reg [7:0] message;
  wire message_tx_to_rx;
  reg [7:0] message_in;

  reg send_flag = 0;

  UART_transmitter U_TX(
    .i_bin(message),
    .i_write_flag(send_flag),
    .i_clk(r_clk_tx),
    .o_uart(message_tx_to_rx)
    );

  UART_receiver U_RX(
    .i_uart(message_tx_to_rx),
    .i_clk(r_clk_rx),
    .o_read_flag(),
    .o_bin(message_in)
    );

  initial
    begin
      $display("Starting Testbench...");
      $display("tx_delay is %d:", tx_delay);
      #20;

      for (int j = 1; j < 10; j++) begin
        message <= $random();
        send_flag <= 1;
        for (int i = 0; i < 8;i++) begin
          #(BAUD_PERIOD*2);
        end
        send_flag <= 0;
        #(BAUD_PERIOD*2);
        #(BAUD_PERIOD*2);
        $display("Test %d, transmitted is %d, received is %d", j, message, message_in);
        if (message == message_in) begin
          $display("===Test PASS===");
        end
        else begin
          $display("===Test FAIL===");
        end
      end

      #100

      $finish();
    end

  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
    end

endmodule

