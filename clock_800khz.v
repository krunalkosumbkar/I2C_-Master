// clock generated for I2C Master
module clock_800khz (input arstn, input clock, output reg slow_clock);

 reg [7:0] count = 0;
 
    always @(posedge clock,negedge arstn)begin
        if (~arstn) begin
            count <=0;
            slow_clock <=0;
        end else begin
            if (count ==124)begin
                count <=0;
                slow_clock <= !slow_clock;
            end else begin
                count <= count +1;
            end
        end
    end
endmodule
