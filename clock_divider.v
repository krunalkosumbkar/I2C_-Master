//clock generation to toggle the anode and also to switch between x,y,z register data seperately by 1 second (32 bit data for each register respectively 4 seven segment display)

module clock_divider#(parameter n = 27)(arstn,clk,clk_div1,clk_div2,clk_div3,clk_div4);
input clk,arstn;
reg [n : 0]c_out;
output clk_div1,clk_div2,clk_div3,clk_div4;
always @ (posedge (clk))begin
if (~arstn)
  c_out <= 'h0;
  else 
  c_out <= c_out + 'h1;
  end
assign clk_div1 = c_out[24];
assign clk_div2 = c_out[17];
assign clk_div3 = c_out[18];
assign clk_div4 = c_out[n];
endmodule
