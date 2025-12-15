module RandomGen(Clk, Rst, RandomValue);
  input Clk, Rst;
  output reg [12:0] RandomValue;

  // 13-bit LFSR taps chosen to give a good cycle (example polynomial)
  // feedback = bit12 ^ bit11 ^ bit1 ^ bit0
  wire feedback = RandomValue[12] ^ RandomValue[11] ^ RandomValue[1] ^ RandomValue[0];

  always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
      RandomValue <= 13'h1F2D; // non-zero seed
    end
    else begin
      RandomValue <= { RandomValue[11:0], feedback };
    end
  end
endmodule
