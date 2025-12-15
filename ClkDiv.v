module ClkDiv #(parameter DIVBY = 50000) (
  input  wire Clk,
  input  wire Rst,
  output reg  ClkOut
);
  // DIVBY must be set such that toggle period = 2*DIVBY input cycles
  // For 100 MHz -> 1 kHz, DIVBY = 50000 (toggle every 50,000 cycles).
  localparam CNT_WIDTH = $clog2(DIVBY);
  reg [CNT_WIDTH-1:0] cnt;

  always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
      cnt    <= {CNT_WIDTH{1'b0}};
      ClkOut <= 1'b0;
    end
    else begin
      if (cnt == DIVBY - 1) begin
        cnt    <= {CNT_WIDTH{1'b0}};
        ClkOut <= ~ClkOut; // toggle -> half-period = DIVBY cycles
      end
      else begin
        cnt <= cnt + 1'b1;
      end
    end
  end
endmodule
