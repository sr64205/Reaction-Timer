module LcdInterface(Rst, Clk, Go, Display, LCD_Data, LCD_E, LCD_RS, LCD_RW);

   input Clk, Rst;
      input Go;
   input [8*16:1] Display;
   output [11:8] LCD_Data;
   output LCD_E, LCD_RS, LCD_RW;
   
   wire LCD_Clk;
   wire [7:0] DataValue;
   wire Command, Clear, Write, Busy, Ready;

   LCDCntrl LCDCntrl_0 (Rst, Clk, Go, Display, DataValue, Command, Clear, Write, Busy, Ready);
   LCDDriver LCDDriver_0 (Rst, Clk, DataValue, Command, Clear, Write, Busy, Ready, LCD_Data, LCD_E, LCD_RS, LCD_RW);

endmodule

module Bin2BCD(Binary, BCD);
   input [9:0] Binary;
      output reg [15:0] BCD;
      
      reg [25:0] Temp;
   integer i;

      always @(Binary) begin
         Temp = {16'h0000, Binary};
            for(i=0; i<9; i=i+1) begin
            Temp = Temp << 1;
                  if(Temp[13:10] > 4) Temp[13:10] = Temp[13:10] + 3;
                  if(Temp[17:14] > 4) Temp[17:14] = Temp[17:14] + 3;
                  if(Temp[21:18] > 4) Temp[21:18] = Temp[21:18] + 3;
                  if(Temp[25:22] > 4) Temp[25:22] = Temp[25:22] + 3;
            end
         Temp = Temp << 1;
            BCD <= Temp[25:10];
      end
endmodule
