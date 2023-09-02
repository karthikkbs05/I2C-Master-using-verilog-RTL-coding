# I2C-Master-using-verilog-RTL-coding

The I2C (Inter-Integrated Circuit) protocol is a simple and versatile way for electronic devices to talk to each other. It works by sending data between devices using two wires: one for timing (clock) and the other for the actual information (data). Each device has a unique address, allowing them to identify who they're communicating with. This makes I2C suitable for applications like connecting sensors to microcontrollers, controlling displays, managing batteries in devices, and enabling communication between various components in electronic systems, making it an essential part of many everyday gadgets and systems.

## Features
- Serial Communication Protocol : I2C is an interface specification for synchronous serial data transfer, using a clock.
- Half/Full Duplex Suppor : I2C supports both half-duplex and full-duplex serial communication modes.
- Synchronous Communication : It is a synchronous communication protocol, utilizing a shared clock signal for synchronization.
- Two-Wire Communication Protocol: I2C is a two-wire protocol, consisting of a data line (SDA) and a clock line (SCL) for communication.
  - `Serial Data Line (SDA)`: SDA is used for bidirectional data transfer between the master and slave devices.
  - `Serial Clock Line (SCL)`: SCL provides the clock signal that synchronizes the data transfer between the master and slave devices.
- Master-Slave Configuration : In most cases, I2C follows a one-master-multiple-slaves protocol, but it also supports multiple master configurations.
- Maximum Speed : I2C supports maximum speeds of up to several Mbps, commonly ranging from 100 kbps (standard mode) to 3.4 Mbps (high-speed mode).
- Clock Source : The master device provides the clock signal for synchronization.
- Data Formats : I2C supports both 8-bit and 16-bit data formats for communication.

## Master and Slave interface
The below digram shows the connection between a single master and multiple slaves. I2C communication can also have multiple masters connected to multiple slaves. 

<img width="544" alt="image" src="https://github.com/karthikkbs05/I2C-Master-using-verilog-RTL-coding/assets/129792064/27caebf6-ddd4-4048-882a-52579fee5792">

## Timing Diagram of the protocol
The below image shows the timimg diagram of the working of the protocol.

<img width="840" alt="image" src="https://github.com/karthikkbs05/I2C-Master-using-verilog-RTL-coding/assets/129792064/f72580d8-49e9-438a-84a3-509add709725">

## Design using verilog RTL
- [i2c_master.v](i2c_master.v) : Design module.
- [i2c_master_tb.v](i2c_master_tb.v) : Testbench module.
- Operation states
   - Below image shows the operating states of the protocol.
 
     <img width="533" alt="image" src="https://github.com/karthikkbs05/I2C-Master-using-verilog-RTL-coding/assets/129792064/cb4f71db-1940-42b3-b6e4-0ec092d2f443">

## Simulation Output 
Simulation is done using Xilinx Vivado. The simulation results are shown below :


<img width="749" alt="image" src="https://github.com/karthikkbs05/I2C-Master-using-verilog-RTL-coding/assets/129792064/bae44f94-339b-42f9-bfaa-c48cb3669c32">
