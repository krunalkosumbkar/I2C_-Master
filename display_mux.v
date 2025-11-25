// mux to provide seperate data to each 7 segment display
module display_mux(in1,in2,in3,in4,a,b,c,d,e,f,g,sel);
input [6:0]in1,in2,in3,in4;
input [1:0]sel;
output reg a,b,c,d,e,f,g;
always@(*)begin
case(sel)
2'b00 : {a,b,c,d,e,f,g} = in1;
2'b01 : {a,b,c,d,e,f,g} = in2;
2'b10 : {a,b,c,d,e,f,g} = in3;
2'b11 : {a,b,c,d,e,f,g} = in4;
default : {a,b,c,d,e,f,g} = 'hz;
endcase
end
endmodule
