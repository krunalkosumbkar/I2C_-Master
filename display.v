//// to display the output from the slave
module display(data_x,data_y,data_z,clk,arstn,a0,a1,a2,a3,a,b,c,d,e,f,g);
input [15:0]data_x,data_y,data_z;
input clk,arstn;
output a0,a1,a2,a3,a,b,c,d,e,f,g; 
wire clk1,clk2,clk3,clk4;
wire [3:0]temp1,temp2,temp3,temp4;
wire [6:0]seg1,seg2,seg3,seg4;
wire[1:0]disp_clk;
reg [15:0] data_temp;
reg [1:0]count_sel;
wire [1:0]counter;
clock_divider display_clk (.arstn(arstn),.clk(clk),.clk_div1(clk1),.clk_div2(clk2),.clk_div3(clk3),.clk_div4(clk4));



always@(posedge clk4,negedge arstn)
begin
if(~arstn)
    count_sel <= 2'b00;
else 
    count_sel <= count_sel + 2'b01;
end
assign counter = count_sel;

//assign data_in = (count_sel[1]== 1'b0)?((count_sel[0]==1'b0)? 'h0:data_x):((count_sel[0]==1'b0)?data_y:data_z);

always@(negedge clk1,negedge arstn)
begin
if(~arstn)
    data_temp <= 'h0;
else begin

case(counter)
2'b00 : data_temp = 'h0;
2'b01 : data_temp = data_x;
2'b10 : data_temp = data_y;
2'b11 : data_temp = data_z;
default : data_temp = 'hz;
endcase
end
end



assign {temp4,temp3,temp2,temp1} = data_temp;
data_display A0 (temp1,seg1);
data_display A1 (temp2,seg2);
data_display A2 (temp3,seg3);
data_display A3 (temp4,seg4);

display_mux display_select (seg1,seg2,seg3,seg4,a,b,c,d,e,f,g,{clk2,clk3});

anode_toggle anode_shuffle (a0,a1,a2,a3,{clk2,clk3});


endmodule
