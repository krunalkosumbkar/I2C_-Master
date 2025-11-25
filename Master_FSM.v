//////////////////////////////////////////////////////////////////////////////////
The I2C Master Protocol FSM

module Master_FSM(
input source_clk,arstn,start,ten,ren,
input [7:0] data_in,
output [15:0] data_out ,
output reg  error, request,
inout scl,sda);
 
 localparam idle = 7'd0;
 
 localparam start1=7'd1;
 localparam start2 = 7'd2;
 
 localparam bit7a= 7'd3;
 localparam bit7b= 7'd4;
 localparam bit6a= 7'd5;
 localparam bit6b= 7'd6;    
 localparam bit5a= 7'd7;
 localparam bit5b= 7'd8;    
 localparam bit4a= 7'd9;
 localparam bit4b= 7'd10;    
 localparam bit3a= 7'd11;
 localparam bit3b= 7'd12;  
 localparam bit2a= 7'd13;
 localparam bit2b =7'd14;
 localparam bit1a= 7'd15;
 localparam bit1b =7'd16;
 
 localparam r_w_bit_a=7'd17;
 localparam r_w_bit_b=7'd18;
 
 localparam ack_nack_a=7'd19;
 localparam ack_nack_b=7'd20;
 localparam ack_nack_c=7'd21;
 
 localparam w_bit7a= 7'd22;
 localparam w_bit7b= 7'd23;
 localparam w_bit6a= 7'd24;
 localparam w_bit6b= 7'd25;    
 localparam w_bit5a= 7'd26;
 localparam w_bit5b= 7'd27;    
 localparam w_bit4a= 7'd28;
 localparam w_bit4b= 7'd29;    
 localparam w_bit3a= 7'd30;
 localparam w_bit3b= 7'd31;  
 localparam w_bit2a= 7'd32;
 localparam w_bit2b =7'd33;
 localparam w_bit1a= 7'd34;
 localparam w_bit1b =7'd35;
 localparam w_bit0a= 7'd36;
 localparam w_bit0b =7'd37;
 
 localparam r_h_bit7a= 7'd38;
 localparam r_h_bit7b= 7'd39;
 localparam r_h_bit6a= 7'd40;
 localparam r_h_bit6b= 7'd41;    
 localparam r_h_bit5a= 7'd42;
 localparam r_h_bit5b= 7'd43;    
 localparam r_h_bit4a= 7'd44;
 localparam r_h_bit4b= 7'd45;    
 localparam r_h_bit3a= 7'd46;
 localparam r_h_bit3b= 7'd47;  
 localparam r_h_bit2a= 7'd48;
 localparam r_h_bit2b =7'd49;
 localparam r_h_bit1a= 7'd50;
 localparam r_h_bit1b =7'd51;
 localparam r_h_bit0a= 7'd52;
 localparam r_h_bit0b =7'd53;
 
 localparam r_l_bit7a= 7'd54;
 localparam r_l_bit7b= 7'd55;
 localparam r_l_bit6a= 7'd56;
 localparam r_l_bit6b= 7'd57;    
 localparam r_l_bit5a= 7'd58;
 localparam r_l_bit5b= 7'd59;    
 localparam r_l_bit4a= 7'd60;
 localparam r_l_bit4b= 7'd61;    
 localparam r_l_bit3a= 7'd62;
 localparam r_l_bit3b= 7'd63;  
 localparam r_l_bit2a= 7'd64;
 localparam r_l_bit2b =7'd65;
 localparam r_l_bit1a= 7'd66;
 localparam r_l_bit1b =7'd67;
 localparam r_l_bit0a= 7'd68;
 localparam r_l_bit0b =7'd69;
 
 localparam high_gen_ack_nack_a= 7'd70;
 localparam high_gen_ack_b= 7'd71;


 localparam low_gen_ack_nack_a= 7'd72;
 localparam low_gen_ack_b= 7'd73;
 
 localparam gen_nack_c = 7'd74;
  
 localparam stop1 =7'd75;
 localparam stop2 = 7'd76;
 localparam stop3 = 7'd77;
 
 localparam intermediate1 = 7'd78;
 
   
 
 wire master_clk;
 wire clock_for_other_modules;
 
 reg [7:0]sda_data_out='h0;
 
 reg data_en;
 
 reg r_w_en;
 reg r_w;
 
 //reg [4:0]count;
 reg [6:0]state;
 
 reg scl_en=1'b1;
 reg sda_en=1'b1;
 
 reg [7:0] data_from_slave_high;
 reg [7:0] data_from_slave_low;
 //reg[7:0] data_out_high ;
 //reg[7:0] data_out_low ;
 //reg app_data_en;
 reg high_data_en;
 reg low_data_en;
 
 assign scl = (scl_en) ? 'hz :'h0;
 assign sda = (sda_en) ? 'hz :'h0;
 
 assign data_out = {data_from_slave_high,data_from_slave_low};
 
 clock_800khz m_clk (.arstn(arstn), .clock(source_clk),.slow_clock(master_clk));
 
// always@ (posedge source_clk , negedge arstn)begin
// if (~arstn)
//  count <= 'h0;
//  else
//  count = count +1;
//   end
// assign clock_for_other_modules = count[4];
 

 
always@(posedge data_en)begin
if (data_en)
  sda_data_out <= data_in;
 else
  sda_data_out <= sda_data_out ;
end

always@(posedge r_w_en)begin
if (r_w_en)
  r_w <= sda_data_out[0];
 else
  r_w<= r_w ;
end

//always@(posedge high_data_en)begin
//if (high_data_en)
// data_out_high<= data_from_slave_high;
//else 
// data_out_high <= data_out_high;
 
//end

//always@(posedge low_data_en)begin
//if (low_data_en)
// data_out_low<= data_from_slave_low;
//else 
// data_out_low <= data_out_low;

//end

always@(posedge master_clk ,negedge arstn)begin
if(~arstn && ! idle)
 state <= idle;
else begin
      case(state)
      idle : begin
                if (start)
                 state <=  start1;
                else
                 state <= idle;
                 //high_data_en <=1'b0;
                // low_data_en <= 1'b0;
                 r_w_en <= 1'b0;
                 data_en<= 1'b0;
                 scl_en <= 1'b1;
                 sda_en <= 1'b1;
                 error <= 1'b0;
                 request <= 1'b0;
                 //app_data_en<= 1'b0;
                 end
                 
       start1: begin
                 scl_en <= 1'b1;
                 sda_en <= 1'b0;                 
                 request <= 1'b1;
                 state <= start2;
                 end
                 
      start2: begin
                 request <= 1'b0;
                 scl_en <= 1'b0;
                 sda_en <= 1'b0;        
                 data_en<= 1'b1;
                 r_w_en <= 1'b0;
                 state <= bit7a; end
                 
      bit7a: begin
                 data_en<= 1'b0;
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[7];
                 state <= bit7b; end  
      bit7b: begin
                 scl_en <= 1'b1;
                 state <= bit6a; end
                   
      bit6a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[6];
                 state <= bit6b; end  
      bit6b: begin
                 scl_en <= 1'b1;
                 state <= bit5a; end    
 
       bit5a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[5];
                 state <= bit5b; end  
       bit5b: begin
                 scl_en <= 1'b1;
                 state <= bit4a; end  

       bit4a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[4];
                 state <= bit4b; end  
       bit4b: begin
                 scl_en <= 1'b1;
                 state <= bit3a; end    
                 
       bit3a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[3];
                 state <= bit3b; end  
       bit3b: begin
                 scl_en <= 1'b1;
                 state <= bit2a; end    
                 
       bit2a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[2];
                 state <= bit2b; end  
       bit2b: begin
                 scl_en <= 1'b1;
                 state <= bit1a; end  

       bit1a: begin
                 scl_en <= 1'b0;
                 r_w_en <= 1'b1;
                 sda_en <= sda_data_out[1];
                 state <= bit1b; end  
       bit1b: begin
                 scl_en <= 1'b1;
                 r_w_en <= 1'b0;
                 state <= r_w_bit_a; end  
 
       r_w_bit_a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[0];
                 state <= r_w_bit_b; end  
       r_w_bit_b: begin
                 scl_en <= 1'b1;
                 state <= ack_nack_a; end
                 
       ack_nack_a: begin
                  request <= 1'b1;
                  scl_en <= 1'b0;
                 sda_en <= 1'b1;
                 state <= ack_nack_b; end  
                           
//       ack_nack_b: begin
//                  request <= 1'b0;
//                  data_en<= 1'b1;
//                 scl_en <= 1'b1;
//                 state <= ack_nack_c; end
 
//       ack_nack_c: begin
//                 data_en<= 1'b0;
//                 scl_en <= 1'b0;
//                 if (sda == 1'b1)begin
//                 state <= stop1;
//                 error <= 1'b1;end
//                 else
//                 state <= intermediate1; end    

//       intermediate1: begin
//                 scl_en <= 1'b0;  
//                 sda_en <= 1'b0;
//                 if (!r_w && ten)
//                 state <= w_bit7a;
//                 else if (r_w && ren)
//                 state <= r_h_bit7a;
//                 else
//                 state <= stop1;
//                 end    
       ack_nack_b: begin
                 request = 1'b0;
                 data_en = 1'b1;
                 scl_en = 1'b1;
                 if (sda == 1'b0)begin
                   state = ack_nack_c;end
                   else begin
                    state = stop1;
                    error = 1'b1; end 
                    end
      
      ack_nack_c: begin
              //app_data_en <= 1'b0;
              scl_en <= 1'b0;  
              sda_en <= 1'b1;
              data_en <= 1'b0;
              if (!r_w && ten)
                state <= w_bit7a;
                else if (r_w && ren)begin
                 state <= r_h_bit7a;end
                 else
                 state <= stop1;end
      
      
      
      w_bit7a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[7];
                 state <= w_bit7b; end  
      w_bit7b: begin
                 scl_en <= 1'b1;
                 state <= w_bit6a; end
                   
      w_bit6a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[6];
                 state <= w_bit6b; end  
      w_bit6b: begin
                 scl_en <= 1'b1;
                 state <= w_bit5a; end    
 
       w_bit5a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[5];
                 state <= w_bit5b; end  
       w_bit5b: begin
                 scl_en <= 1'b1;
                 state <= w_bit4a; end  

       w_bit4a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[4];
                 state <= w_bit4b; end  
       w_bit4b: begin
                 scl_en <= 1'b1;
                 state <= w_bit3a; end    
                 
       w_bit3a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[3];
                 state <= w_bit3b; end  
       w_bit3b: begin
                 scl_en <= 1'b1;
                 state <= w_bit2a; end    
                 
       w_bit2a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[2];
                 state <= w_bit2b; end  
       w_bit2b: begin
                 scl_en <= 1'b1;
                 state <= w_bit1a; end  

       w_bit1a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[1];
                 state <= w_bit1b; end  
       w_bit1b: begin
                 scl_en <= 1'b1;
                 state <= w_bit0a; end  
                 
       w_bit0a: begin
                 scl_en <= 1'b0;
                 sda_en <= sda_data_out[0];
                 state <= w_bit0b; end  
       w_bit0b: begin
                 scl_en <= 1'b1;
                 state <= ack_nack_a; end  
                 
                 

      r_h_bit7a: begin
                 scl_en <= 1'b1;  
                            
                 state <= r_h_bit7b; end  
      r_h_bit7b: begin
                 scl_en <= 1'b0;
                 data_from_slave_high[7] <= sda;
                 state <= r_h_bit6a; end
                   
      r_h_bit6a: begin
                 scl_en <= 1'b1;
                 state <= r_h_bit6b; end  
      r_h_bit6b: begin
                 scl_en <= 1'b0;
                  data_from_slave_high[6] <= sda;
                 state <= r_h_bit5a; end    
 
       r_h_bit5a: begin
                 scl_en <= 1'b1;    
                 state <= r_h_bit5b; end  
       r_h_bit5b: begin
                 scl_en <= 1'b0;
                 data_from_slave_high[5] <= sda;
                 state <= r_h_bit4a; end  

       r_h_bit4a: begin
                 scl_en <= 1'b1;
                 state <= r_h_bit4b; end  
       r_h_bit4b: begin
                 scl_en <= 1'b0;
                 data_from_slave_high[4] <= sda;
                 state <= r_h_bit3a; end    
                 
       r_h_bit3a: begin
                 scl_en <= 1'b1;
                 state <= r_h_bit3b; end  
       r_h_bit3b: begin
                 scl_en <= 1'b0;
                 data_from_slave_high[3] <= sda;
                 state <= r_h_bit2a; end    
                 
       r_h_bit2a: begin
                 scl_en <= 1'b1;
                 state <= r_h_bit2b; end  
       r_h_bit2b: begin
                 scl_en <= 1'b0;
                 data_from_slave_high [2]<= sda;
                 state <= r_h_bit1a; end  

       r_h_bit1a: begin
                 scl_en <= 1'b1;                
                 state <= r_h_bit1b; end  
       r_h_bit1b: begin
                 scl_en <= 1'b0;
                 data_from_slave_high[1] <= sda;
                 state <= r_h_bit0a; end  
                 
       r_h_bit0a: begin
                 scl_en <= 1'b1;
                 state <= r_h_bit0b; end  
       r_h_bit0b: begin
                 scl_en <= 1'b0;
                 data_from_slave_high[0]<= sda;
                 state <= high_gen_ack_nack_a; end  
                 
       high_gen_ack_nack_a: begin
                //high_data_en <=1'b0;
                //app_data_en =1'b0;
                scl_en = 1'b0;
                if(ren)begin
                sda_en = 1'b0;
                state  = high_gen_ack_b;end
                else begin
                sda_en = 1'b1;
                state  = gen_nack_c ;end
                end
                
       high_gen_ack_b: begin
                
                scl_en <= 1'b1;
                state <= intermediate1;end 
                
       intermediate1:begin
                scl_en <= 1'b0;
                sda_en <=1'b1;
                state =r_l_bit7a;end 
                      
 
                                     
      r_l_bit7a: begin
                // low_data_en <= 1'b1;
                 scl_en <= 1'b1;              
                 state <= r_l_bit7b; end  
      r_l_bit7b: begin
                 scl_en <= 1'b0;
                 data_from_slave_low[7] <= sda;
                 state <= r_l_bit6a; end
                   
      r_l_bit6a: begin
                 scl_en <= 1'b1;
                 state <= r_l_bit6b; end  
      r_l_bit6b: begin
                 scl_en <= 1'b0;
                  data_from_slave_low[6] <= sda;
                 state <= r_l_bit5a; end    
 
       r_l_bit5a: begin
                 scl_en <= 1'b1;    
                 state <= r_l_bit5b; end  
       r_l_bit5b: begin
                 scl_en <= 1'b0;
                 data_from_slave_low[5] <= sda;
                 state <= r_l_bit4a; end  

       r_l_bit4a: begin
                 scl_en <= 1'b1;
                 state <= r_l_bit4b; end  
       r_l_bit4b: begin
                 scl_en <= 1'b0;
                 data_from_slave_low[4] <= sda;
                 state <= r_l_bit3a; end    
                 
       r_l_bit3a: begin
                 scl_en <= 1'b1;
                 state <= r_l_bit3b; end  
       r_l_bit3b: begin
                 scl_en <= 1'b0;
                 data_from_slave_low[3] <= sda;
                 state <= r_l_bit2a; end    
                 
       r_l_bit2a: begin
                 scl_en <= 1'b1;
                 state <= r_l_bit2b; end  
       r_l_bit2b: begin
                 scl_en <= 1'b0;
                 data_from_slave_low [2]<= sda;
                 state <= r_l_bit1a; end  

       r_l_bit1a: begin
                 scl_en <= 1'b1;                
                 state <= r_l_bit1b; end  
       r_l_bit1b: begin
                 scl_en <= 1'b0;
                 data_from_slave_low[1] <= sda;
                 state <= r_l_bit0a; end  
                 
       r_l_bit0a: begin
                 scl_en <= 1'b1;
                 state <= r_l_bit0b; end  
       r_l_bit0b: begin
                 scl_en <= 1'b0;
                 request <= 1'b1;
                 data_from_slave_low[0]<= sda;
                 state <= low_gen_ack_nack_a; end   

       low_gen_ack_nack_a: begin
                
                request = 1'b0;
               // low_data_en = 1'b0;
                scl_en = 1'b0;
                if(ren)begin
                sda_en = 1'b0;
                state <= low_gen_ack_b;end
                else begin
                sda_en = 1'b1;
                state <= gen_nack_c ;end
                end
                
       low_gen_ack_b: begin
               // app_data_en <= 1'b1;
                scl_en <= 1'b1;
                state <= ack_nack_c;end 
                 
 
        gen_nack_c: begin
               // app_data_en <= 1'b0;
                scl_en <= 1'b1;
                state <= stop1;end   
                
            stop1 : begin
                scl_en<=1'b0;
                sda_en<=1'b0;
                state <= stop2;end             
            
             stop2 : begin
                scl_en<=1'b1;
                sda_en<=1'b0;
                state <= stop3;end  

             stop3 : begin
                sda_en<=1'b1;
                state <= idle;end 
                
          default: begin
                // high_data_en <=1'b0;
                 //low_data_en <= 1'b0;
                 r_w_en <= 1'b0;
                 data_en<= 1'b0;
                 scl_en <= 1'b1;
                 sda_en <= 1'b1;
                 error <= 1'b0;
                 request <= 1'b0;
                // app_data_en<= 1'b0;
                 state <= idle;
                   end                                                                                                                                                                                                        
endcase
end
end
endmodule


//////////////////////////////////////////////////////////////////////////////////
