// 4-bit Counter Test bench version 1
// This just hooks up the test bench

module counter_tb;          // this will become the TLM
  reg clk, reset, enable;   // define some regs, like global vars
  wire [3:0] count;         // just need a wire for count as it is stored
                            // within the counter module
  counter U0 (     // instantiate the counter (U0 = unit under test)
   .clk    (clk),     
   .reset  (reset),
   .enable (enable),
   .count  (count)
  );

endmodule

