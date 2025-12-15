module ReactionTimer(Clk, Rst, Start, LED, ReactionTime, Cheat, Slow, Wait, RandomValue, LCDUpdate, LCDAck);

input Clk, Rst, Start, LCDAck;
input [12:0] RandomValue;
output reg [9:0] ReactionTime;
output reg [7:0] LED;
output reg Cheat, Slow, Wait, LCDUpdate;

reg [2:0] state;
reg [12:0] delay_cnt;
reg [12:0] wait_limit;
reg [9:0] react_cnt;
reg Start_prev;
wire Start_edge = Start & ~Start_prev;

parameter S_INIT=0, S_WAIT_RANDOM=1, S_LED_ON=2, S_REACT=3, S_SLOW=4, S_CHEAT=5, S_DONE=6;

reg LCDUpdate_req;
reg LCDUpdate_d;

always @(posedge Clk) begin
    LCDUpdate_d <= LCDUpdate_req;
    LCDUpdate <= LCDUpdate_req & ~LCDUpdate_d;
    Start_prev <= Start;
end

always @(posedge Clk) begin
   if(Rst) begin
      state <= S_INIT;
      LED <= 8'b0;
      Cheat <= 0;
      Slow <= 0;
      Wait <= 0;
      ReactionTime <= 0;
      delay_cnt <= 0;
      wait_limit <= 0;
      react_cnt <= 0;
      LCDUpdate_req <= 0;
   end else begin
      LCDUpdate_req <= 0;
      case(state)

         S_INIT: begin
            Cheat <= 0; Slow <= 0; Wait <= 0;
            LED <= 0;
            if(!LCDAck && Start_edge) begin
               wait_limit <= (RandomValue % 2000) + 1000;
               delay_cnt <= 0;
               Wait <= 1;
               LCDUpdate_req <= 1;
               state <= S_WAIT_RANDOM;
            end
         end

         S_WAIT_RANDOM: begin
            if(Start_edge) begin
               Wait <= 0; Cheat <= 1;
               LCDUpdate_req <= 1;
               state <= S_CHEAT;
            end else if(delay_cnt >= wait_limit) begin
               Wait <= 0; LED <= 8'hFF;
               react_cnt <= 0;
               state <= S_LED_ON;
            end else delay_cnt <= delay_cnt + 1;
         end

         S_LED_ON: begin
            LED <= 8'hFF;
            if(Start) begin
                ReactionTime <= react_cnt;
                LCDUpdate_req <= 1;
                state <= S_DONE;
            end else if(react_cnt >= 500) begin
               Slow <= 1;
               LCDUpdate_req <= 1;
               state <= S_SLOW;
            end else react_cnt <= react_cnt + 1;
         end

         S_SLOW: begin
            LED <= 0;
            if(Start) state <= S_INIT;
         end

         S_CHEAT: begin
            LED <= 0;
            if(Start) state <= S_INIT;
         end

         S_DONE: begin
            LED <= 0;
            if(Start) state <= S_INIT;
         end

      endcase
   end
end

endmodule
