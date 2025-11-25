// toggling the anode so only one seven segment get power at a time

module anode_toggle(a0,a1,a2,a3,sel);
input [1:0]sel;
output reg a0,a1,a2,a3;
always@(*)begin
 case(sel)
 2'b00 : {a3,a2,a1,a0} = 4'b1110;
 2'b01 : {a3,a2,a1,a0} = 4'b1101;
 2'b10 : {a3,a2,a1,a0} = 4'b1011;
 2'b11 : {a3,a2,a1,a0} = 4'b0111;
 default : {a3,a2,a1,a0} = 4'b1111;
 endcase
 end
endmodule
