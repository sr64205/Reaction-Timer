module ReactionTimer_tb();
    reg Clk_s, Rst_s, Start_s, LCDAck_s;
    reg [12:0] RandomValue_s;
    wire [7:0] LED_s;
    wire [9:0] ReactionTime_s;
    wire Cheat_s, Slow_s, Wait_s, LCDUpdate_s;

    // FIXED INSTANTIATION – use named ports
    ReactionTimer dut (
        .Clk(Clk_s),
        .Rst(Rst_s),
        .Start(Start_s),
        .LED(LED_s),
        .ReactionTime(ReactionTime_s),
        .Cheat(Cheat_s),
        .Slow(Slow_s),
        .Wait(Wait_s),
        .RandomValue(RandomValue_s),
        .LCDUpdate(LCDUpdate_s),
        .LCDAck(LCDAck_s)
    );

    // Clock
    always begin
        #5 Clk_s = 0;
        #5 Clk_s = 1;
    end

    // 1–cycle pulse for Start
    task pulse_start;
    begin
        Start_s <= 1;
        @(posedge Clk_s);
        Start_s <= 0;
    end
    endtask

    initial begin
        // init
        Rst_s = 1;
        LCDAck_s = 0;  // MUST start low!!!
        Start_s = 0;
        RandomValue_s = 13'd3;
        @(posedge Clk_s);
        Rst_s = 0;

        // TEST 1: TOO SLOW
        #20 pulse_start;       // enter S_INIT → S_WAIT_RANDOM

        // ack LCD update
        @(posedge LCDUpdate_s);  // wait until FSM pulses LCDUpdate
        @(posedge Clk_s);
        LCDAck_s <= 1;
        @(posedge Clk_s);
        LCDAck_s <= 0;

        // allow FSM to wait entire random period
        repeat(2500) @(posedge Clk_s);

        // LED is ON now, wait too long → Slow
        repeat(600) @(posedge Clk_s);

        pulse_start;  // acknowledge S_SLOW screen

        // ack LCD update
        @(posedge LCDUpdate_s);
        @(posedge Clk_s);
        LCDAck_s <= 1;
        @(posedge Clk_s);
        LCDAck_s <= 0;

        // TEST 2: CHEAT
        // reset
        @(posedge Clk_s);
        Rst_s <= 1;
        @(posedge Clk_s);
        Rst_s <= 0;

        RandomValue_s <= 13'd2;
        LCDAck_s <= 0;

        pulse_start;        // go to wait state
        @(posedge LCDUpdate_s);
        @(posedge Clk_s);
        LCDAck_s <= 1;
        @(posedge Clk_s);
        LCDAck_s <= 0;

        #20 pulse_start;    // pressing early → cheat

        // TEST 3: NORMAL REACTION TIME
        @(posedge Clk_s);
        Rst_s <= 1;
        @(posedge Clk_s);
        Rst_s <= 0;

        pulse_start;        // start → wait_random
        @(posedge LCDUpdate_s);
        @(posedge Clk_s);
        LCDAck_s <= 1;
        @(posedge Clk_s);
        LCDAck_s <= 0;

        // let the random delay pass
        repeat(1500) @(posedge Clk_s);

        // LED ON: react quickly
        repeat(50) @(posedge Clk_s);
        pulse_start;

        // ack LCD update
        @(posedge LCDUpdate_s);
        @(posedge Clk_s);
        LCDAck_s <= 1;
        @(posedge Clk_s);
        LCDAck_s <= 0;

        #200 $stop;
    end
endmodule
