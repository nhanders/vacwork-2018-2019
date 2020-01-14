// Counter test bench 3
// Set up a monitor and change some pins
// Coder: S. Winberg

// 4-bit Upcounter testbench
module counter_tb; 
  reg clk, reset, enable; 
  wire [3:0] count; 
    
  counter U0 (     // instantiate the module
  .clk    (clk), 
  .reset  (reset), 
  .enable (enable), 
  .count  (count) 
  ); 
    
  initial 
  begin 
    // Set up a monitor routine to keep printing out the
    // pins we are interested in...
    // But first do a display so that you know what columns are used
    $display("\t\ttime,\tclk,\treset,\tenable,\tcount"); 
    $monitor("%d,\t%b,\t%b,\t%b,\t%d",$time, clk,reset,enable,count); 
    // Now excercise the pins!!!
    clk = 0; 
    reset = 0; 
    enable = 0; 
    #5 clk = !clk;   // The # says pause for x simulation steps
                     // The command just toggles the clock
    reset = 1;
    #5 clk = !clk;   // Let's just toggle it again for good measure
    reset  = 0;      // Lower the reset line
    enable = 1;      // now start counting!!

    repeat (10) begin
        #5 clk = !clk;   // Let's just toggle it a few more times
       end 

  end 
    
endmodule 

