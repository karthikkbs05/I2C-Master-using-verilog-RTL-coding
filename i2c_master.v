`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module i2c_master(
    inout sda,
    output scl,clk2mhz_dummy,rw,
    input clk100mhz,res,
    input [7:0]data_to_send, addr_to_send  // contains 5 bit slave address and 2 bit dummy and last bit says the read/write
);
    
      parameter [3:0]idle = 4'b0000, start_init = 4'b0001, start = 4'b0010, 
                address_send = 4'b0011, slave_ack_init = 4'b0100, slave_ack = 4'b0101,
                data_send_init_wait = 4'b0110, data_send_init = 4'b0111, data_send = 4'b1000,
                data_ack_init = 4'b1001, data_ack = 4'b1010, stop_init = 4'b1011,
                stop = 4'b1100, data_read_init = 4'b1101, data_read = 4'b1110 ;
      
      reg [3:0]state = idle;
      
      reg clk2mhz,
          sda_h=0,scl_h=0,
          sda_mode=1,scl_mode = 1,scl_toggle = 0;
      reg [7:0]addr_to_send_store;   
      reg [7:0]data_to_send_store,data_read_store;
      
      always@(data_to_send or addr_to_send)
      begin
          addr_to_send_store = addr_to_send;    
          data_to_send_store = data_to_send;
      end
      
      assign rw = addr_to_send_store[0];
      
      integer count = 0 , bit_count = 8 , count_ack_wait = 4 , count_sda_wait = 2; 
      
      assign sda = sda_mode ? 1'bZ : sda_h;
      assign scl = scl_mode ? 1'bZ : scl_toggle ? clk2mhz : scl_h;
     
     always @(posedge clk100mhz)
     begin
     count <= count + 1;
     if(count>=0 && count<=24)
       clk2mhz <=0;
     else 
       clk2mhz <=1;
     
     if(count ==49)
       count <=0;    
     end
     
     assign clk2mhz_dummy = clk2mhz;
     
     always@(posedge clk2mhz or posedge res)
     begin
     if(res)
      state <= idle;
     case(state)
     idle : begin
            sda_mode <= 1;
            sda_h <= 1;
            scl_mode <= 1;
            scl_h <= 1;
            
            if(addr_to_send_store)
             begin
              state <= start_init;
             end 
            else 
             begin
              state <= idle;
             end
            end
            
     start_init : begin
                  sda_mode <= 0;
                  sda_h <= 0;
                  scl_mode <= 1;
                  scl_h <= 1;
                  state <= start;
                  end   
                  
     start : begin
             sda_mode <= 0;
             sda_h <= 0;
             scl_mode <= 0;
             scl_h <= 0;
             state <= address_send;
             end    
     
     address_send : begin
                    scl_toggle <= 1;
//                    always @(posedge scl)
//                     begin
//                     sda_h <= data_to_send_store[bit_count-1];
//                     bit_count <= bit_count-1;
//                     end
                    sda_h <= addr_to_send_store[bit_count-1];
                    bit_count <= bit_count-1;
                    if(bit_count < 0)
                     begin
                      //scl_toggle <= 0;
                      bit_count <= 8;
                      state <= slave_ack_init;
                     end
                    else
                    state <= address_send; 
                    end    
     
     slave_ack_init : begin
                      sda_mode <= 1;
                      sda_h <= 1;
//                      scl_mode <= 1;
//                      scl_h <= 1;
                      state <= slave_ack;
                      end
     
     slave_ack : begin
                 count_ack_wait <= count_ack_wait - 1;
                 if(count_ack_wait < 0)
                  begin
                   
                   if(sda == 0) // if(sda == 0 && addr_to_send_store[0] == 1)
                     if(rw == 0)
                        state <= data_send_init_wait;
                     else 
                        state <= data_read_init;
                   else
                    state <= idle;
                   
                   count_ack_wait <= 4;
                  end
                 end  
             
     data_send_init_wait : begin
                          //pull sda up again and repeat prev start cond. 
                          count_sda_wait <= count_sda_wait -1;
                          if(count_sda_wait < 0)
                           begin                                             // here sda_h is made 1 and sda is made 1
                           sda_mode <= 1;
                           sda_h <= 1;
                           state <= data_send_init;
                           count_sda_wait <= 2;
                           end
                          else 
                          state <= data_send_init_wait;
                          end
                          
     data_send_init : begin
                      sda_mode <= 0;
                      sda_h <= 0;
//                      scl_mode <= 0;
//                      scl_h <= 0;
                      state <= data_send;
                      end 
     
     data_send : begin
//                  scl_toggle <= 1;
                  sda_h <= data_to_send_store[bit_count - 1];
                  bit_count <= bit_count - 1;
                  if(bit_count < 0)
                   begin
//                    scl_toggle <= 0;
                    bit_count <= 8;
                    state <= data_ack_init;
                   end
                  else 
                   state <= data_send;
                 end
                 
     data_ack_init: begin
                    sda_mode <= 1;
                    sda_h <= 1;
//                    scl_mode <= 1;
//                    scl_h <= 1;
                    state <= data_ack;
                    end
                    
     data_ack : begin
                count_ack_wait = count_ack_wait - 1;
                if(count_ack_wait < 0)
                 begin
                  if(sda == 0)
                  state <= stop_init;                      //sda made high in tb
                  else
                  state <= data_send_init;
                 end
                end
      
      data_read_init : begin
                       sda_mode <= 1;
                       sda_h <= 1;
                       state <= data_read;
                       end
             
      data_read : begin
                      data_read_store[bit_count -1] <= sda;
                      bit_count <= bit_count - 1;
                      if(bit_count < 0)
                       begin
 //                    scl_toggle <= 0;
                        bit_count <= 8;
                        state <= stop_init;
                       end
                      else 
                       state <= data_read;
                  end
                
                
     stop_init : begin
                 count_sda_wait <= count_sda_wait - 1;          //to make sda high
                  if(count_sda_wait < 0)
                   begin
                   state <=  stop;
                   count_sda_wait <= 2;
                   end
                  else 
                   state <= stop_init;                         
                 end
     
     stop : begin
            sda_mode <= 1;
            sda_h <= 1;
            scl_toggle <= 0;
            scl_mode <= 1;
            scl_h <= 1;
            data_to_send_store <= 8'b0000_0000;
            addr_to_send_store <= 8'b0000_0000;
            state <= idle;
            end
     endcase
     end
     
endmodule
