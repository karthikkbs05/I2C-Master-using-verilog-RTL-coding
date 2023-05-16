`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// 
//////////////////////////////////////////////////////////////////////////////////


module i2c_master_tb;
    wire sda;
    wire scl;
    wire clk2mhz_dummy,rw;
    reg clk100mhz,res;
    reg [7:0]data_to_send, addr_to_send;
    
    reg sda_in;
    
    i2c_master dut(.sda(sda),.scl(scl),.clk100mhz(clk100mhz),.res(res),
                   .data_to_send(data_to_send),.addr_to_send(addr_to_send),.clk2mhz_dummy(clk2mhz_dummy),.rw(rw));
    
    assign sda = sda_in;
    
    always #5 clk100mhz = ~clk100mhz;
    initial
    begin
    clk100mhz = 0;    
    res =1;
    sda_in = 1'bZ;
    end
    
    initial
    begin
    #250 res =0; 
    data_to_send = 8'b0101_0101;
    addr_to_send = 8'b1001_1000;
    
    #7500 sda_in = 0;
    #3000 sda_in = 1'bZ;
    #7250 sda_in = 0;
    #3000 sda_in = 1'bZ;
    end
endmodule
