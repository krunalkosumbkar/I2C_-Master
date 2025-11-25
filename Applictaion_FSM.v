// Applicaton layer to manipulate data to be sent to and get from the I2c Master

module Applictaion_FSM#(parameter idle = 4'b0000, wait_state = 4'b0001,s_address_w= 4'b0010,
data1 =4'b0011, s_address_r= 4'b0100,data_in_x = 4'b0101,data_in_y = 4'b0110,data_in_z='b0111,
done_write= 4'b1000,done_read=4'b1001,error_state = 4'b1010
 )(input source_clk,arstn,error,r_w_button,button_start,button_stop,request,input[15:0]data_in,
output reg start,error_led,done_w_led,done_r_led,ten,ren,output [7:0]data_out,
output [15:0]data_x,data_y,data_z );

reg [2:0]request_count;
reg request_count_rst;
reg [1:0]mux_sel_data,data_in_sel_mux;

reg [15:0]data_x_reg;
reg [15:0]data_y_reg;
reg [15:0]data_z_reg;

always@(posedge request, negedge arstn,posedge request_count_rst)begin
if(~arstn | request_count_rst)
 request_count <= 'h0;
 else
 request_count <= request_count + 1'b1;end
 
 reg [7:0] address_w= 8'b11010000;
 reg [7:0] address_r= 8'b11010001;
 reg [7:0] data_1 = 'h3B;
 reg [7:0] data_0 = 'h0;
 
  
clock_generator application_clk(.arstn(arstn),.clk(source_clk),.clk_for_app(app_clk));
 
assign data_out = (mux_sel_data[1]== 1'b0)?((mux_sel_data[0]==1'b0)? data_0:address_w):((mux_sel_data[0]==1'b0)?data_1:address_r);

always@(posedge app_clk )begin
if(data_in_sel_mux == 2'b01) 
  data_x_reg <= data_in;
else 
  data_x_reg <= data_x;end

assign data_x = data_x_reg;

always@(posedge app_clk )begin
if(data_in_sel_mux == 2'b10) 
  data_y_reg <= data_in;
else 
  data_y_reg <= data_y;end
  
assign data_y = data_y_reg;

always@(posedge app_clk )begin
if(data_in_sel_mux == 2'b11) 
  data_z_reg <= data_in;
else 
  data_z_reg <= data_z;end
  
assign data_z = data_z_reg; 

reg [4:0] p_state,n_state;

always@(posedge app_clk, negedge arstn)
begin
   if (~arstn)
    p_state<=idle;
   else
  p_state<=n_state;
end

always@(*)
begin
case(p_state)
  idle:begin
         if(button_start)
         n_state = wait_state;
         else
         n_state=idle;
         end
         
   wait_state:begin
          if(request_count == 3'b001 && !r_w_button && !error)
          n_state = s_address_w;
          else if (request_count==3'b001 && r_w_button && !error)
           n_state = s_address_r;
          else
           n_state = wait_state;end
           
    s_address_w: begin
          if (!r_w_button && request_count == 3'b010)
          n_state = data1;
          else
          n_state = s_address_w;
          end
      data1: begin
          if (request_count == 3'b011 && !error)
           n_state = done_write;
          else if(error)
          n_state=error_state;
          else
           n_state = data1;end
           

         
     done_write: begin
          if (button_stop)
            n_state = idle;
           else
            n_state = done_write ;end
     
     s_address_r: begin
          if (r_w_button && request_count == 3'b010)
          n_state = data_in_x;
          else
          n_state = s_address_r;
          end
     data_in_x: begin
          if (request_count == 3'b011 && !error)
           n_state = data_in_y;
          else if(error)
          n_state=error_state;
          else
          n_state =data_in_x;end
           
      data_in_y: begin
         if(request_count == 3'b100 && !error)
           n_state =data_in_z;
         else
           n_state =data_in_y;end
    
      data_in_z: begin
         if(request_count == 3'b101 && !error)
           n_state =done_read;
         else
           n_state =data_in_z;end
                 
       done_read: begin
         if (button_stop)
            n_state = idle;
           else
            n_state = done_read ;end
       
        error_state : begin
           if (button_stop)
           n_state = idle;
           else
           n_state = error_state;
           end    
       
   //     stop_state : begin
     //      if (button_start)
       //    n_state = wait_state;
        //   else
        //   n_state = stop_state;
        //   end
           
           default : n_state = idle;
           endcase
           end
  always@(*)begin
 
   case (p_state)          
   idle :begin
   start =1'b0;
   error_led = 1'b0;
   ten =1'b0 ;
   ren =1'b0;
   mux_sel_data =2'b00;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b1;
   data_in_sel_mux = 2'b00;
   end
   
   wait_state:begin
   begin
   if (!r_w_button)begin
   ten = 1'b1;
   ren = 1'b0;end
   else if (r_w_button)begin
   ten = 1'b0;
   ren = 1'b1;end
   else begin
   ten = 1'b0;
   ren = 1'b0;end
   end
   begin
   start =1'b1; 
   error_led = 1'b0;
   mux_sel_data =2'b00;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b0;
   data_in_sel_mux = 2'b00;
   end
   end
 
 
   s_address_w :begin
   ten = 1'b1;
   ren = 1'b0;
   start =1'b0;  
   error_led = 1'b0;
   mux_sel_data =2'b01;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b0;
   data_in_sel_mux = 2'b00;
   end  
   
   data1 :begin
   ten = 1'b1;
   ren = 1'b0;
   start =1'b0;  
   error_led = 1'b0;
   mux_sel_data =2'b10;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b0;
   data_in_sel_mux = 2'b00;
   end
   

   done_write :begin
   start =1'b0;
   error_led = 1'b0;
   ten =1'b0 ;
   ren =1'b0;
   mux_sel_data =2'b00;
   done_r_led = 1'b0;
   done_w_led =1'b1;
   request_count_rst = 1'b1;
   data_in_sel_mux = 2'b00;
   end  

   s_address_r:begin
   ten = 1'b0;
   ren = 1'b1;
   start =1'b0;
   error_led = 1'b0;
   mux_sel_data =2'b11;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b0;
   data_in_sel_mux = 2'b00;
   end


   data_in_x:begin
   ten = 1'b0;
   ren = 1'b1;
   start =1'b0;
   error_led = 1'b0;
   mux_sel_data =2'b00;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b0;
   data_in_sel_mux = 2'b01;
   end
   

   data_in_y:begin
   ten = 1'b0;
   ren = 1'b1;
   start =1'b0;
   error_led = 1'b0;
   mux_sel_data =2'b00;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b0;
   data_in_sel_mux = 2'b10;
   end
   
  data_in_z:begin
   ten = 1'b0;
   ren = 1'b1;
   start =1'b0;
   error_led = 1'b0;
   mux_sel_data =2'b00;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b0;
   data_in_sel_mux = 2'b11;
   end
   
  
   done_read :begin
   start =1'b0;
   error_led = 1'b0;
   ten =1'b0 ;
   ren =1'b0;
   mux_sel_data =2'b00;
   done_r_led = 1'b1;
   done_w_led =1'b0;
   request_count_rst = 1'b1;
   data_in_sel_mux = 2'b00;
   end  
   
   error_state :begin
   start =1'b0;
   error_led = 1'b1;
   ten =1'b0 ;
   ren =1'b0;
   mux_sel_data =2'b00;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b1;
   data_in_sel_mux = 2'b00;
   end  
   
  // stop_state :begin
  // start =1'b0;
  // stop =1'b1;
  // low_reg_en = 1'b0;
  // high_reg_en = 1'b0;
  // error_led = 1'b1;
  // ten =1'b0 ;
  // ren =1'b0;
  // a_n_gen = 1'b0;
  // mux_sel_data =2'b00;
  // done_r_led = 1'b0;
  // done_w_led =1'b0;
  // request_count_rst = 1'b1;
  // end  
   
   default: begin
   start =1'b0;
   error_led = 1'b0;
   ten =1'b0 ;
   ren =1'b0;
   mux_sel_data =2'b00;
   done_r_led = 1'b0;
   done_w_led =1'b0;
   request_count_rst = 1'b1;
   data_in_sel_mux = 2'b00;
   end
endcase
end

endmodule

//////////////////////////////////////////////////////////////////////////////////
