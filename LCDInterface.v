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

