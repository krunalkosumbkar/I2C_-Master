//clock generation

module clock_generator#(parameter n = 6)(arstn,clk,clk_for_app);
input clk,arstn;
reg [n : 0]c_out;
output clk_for_app;
always @ (posedge (clk))begin
if (~arstn)
  c_out <= 'h0;
  else 
  c_out <= c_out + 'h1;
  end
  
assign clk_for_app = c_out[n];
endmodule
