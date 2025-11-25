//top module of the design

module I2C_protocol(input start_button,stop_button,r_w_button,source_clk,arstn,inout sda,scl,
output error_led,done_write_led,done_read_led,a0,a1,a2,a3,a,b,c,d,e,f,g);

wire w_error;
wire w_request;
wire [15:0]w_data_in;
wire w_start;
wire w_ten;
wire w_ren;
wire [7:0]w_data_out;
wire [15:0]w_data_x;
wire [15:0]w_data_y;
wire [15:0]w_data_z;

Applictaion_FSM  application(.source_clk(source_clk),.arstn(arstn),.error(w_error),.r_w_button(r_w_button),
.button_start(start_button),.button_stop(stop_button),
.request(w_request),.data_in(w_data_in),
.start(w_start),.error_led(error_led),.done_w_led(done_write_led),.done_r_led(done_read_led ),.ten(w_ten),.ren(w_ren),.data_out(w_data_out),
.data_x(w_data_x),.data_y(w_data_y),.data_z(w_data_z));

Master_FSM  master(
 .source_clk(source_clk),.arstn(arstn),.start(w_start),.ten(w_ten),.ren(w_ren),
.data_in(w_data_out),
.data_out(w_data_in) ,
 .error(w_error), .request(w_request),
.scl(scl),.sda(sda));

display segment_display (.data_x(w_data_x),.data_y(w_data_y),.data_z(w_data_z),
.clk(source_clk),.arstn(r_w_button),.a0(a0),.a1(a1),.a2(a2),.a3(a3),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g));

endmodule
