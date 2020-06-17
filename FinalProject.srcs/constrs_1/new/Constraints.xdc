## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project
## - CASE SENSITIVE: make sure the port names here exactly match those in your top level!

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name mclk -period 10.00 -waveform {0 5} [get_ports clk]
 
## Switches
#set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
#set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
#set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
#set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
#set_property PACKAGE_PIN W15 [get_ports {sw[4]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
#set_property PACKAGE_PIN V15 [get_ports {sw[5]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
#set_property PACKAGE_PIN W14 [get_ports {sw[6]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
#set_property PACKAGE_PIN W13 [get_ports {sw[7]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
#set_property PACKAGE_PIN V2 [get_ports {sw[8]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
#set_property PACKAGE_PIN T3 [get_ports {sw[9]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
#set_property PACKAGE_PIN T2 [get_ports {sw[10]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
#set_property PACKAGE_PIN R3 [get_ports {sw[11]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
#set_property PACKAGE_PIN W2 [get_ports {sw[12]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
#set_property PACKAGE_PIN U1 [get_ports {sw[13]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
#set_property PACKAGE_PIN T1 [get_ports {sw[14]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]
#set_property PACKAGE_PIN R2 [get_ports {sw[15]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]
 

## LEDs  U16 is the LED we want 
set_property PACKAGE_PIN U16 [get_ports {LED_flash}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN E19 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN U19 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN V19 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN W18 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN U15 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN U14 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN V14 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN V13 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN V3 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN W3 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN U3 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN P3 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN N3 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#set_property PACKAGE_PIN P1 [get_ports {LED_flash]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash]
#set_property PACKAGE_PIN L1 [get_ports {LED_flash}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
	
	
##7 segment display
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

#set_property PACKAGE_PIN V7 [get_ports dp]							
#	set_property IOSTANDARD LVCMOS33 [get_ports dp]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


##Buttons
#set_property PACKAGE_PIN U18 [get_ports btnC]						
	#set_property IOSTANDARD LVCMOS33 [get_ports btnC]
#set_property PACKAGE_PIN T18 [get_ports btnU]						
	#set_property IOSTANDARD LVCMOS33 [get_ports btnU]
#set_property PACKAGE_PIN W19 [get_ports run_stop_reset]						
	#set_property IOSTANDARD LVCMOS33 [get_ports run_stop_reset]
#set_property PACKAGE_PIN T17 [get_ports split]						
	#set_property IOSTANDARD LVCMOS33 [get_ports split]
#set_property PACKAGE_PIN U17 [get_ports btnD]						
	#set_property IOSTANDARD LVCMOS33 [get_ports btnD]
 

## No JA 5 and 6 because those are power and ground 
##Pmod Header JA
##Sch name = JA1
#set_property PACKAGE_PIN J1 [get_ports {RsRx_p}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {RsRx_p}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {RsTx}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {RsTx}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {RsRx}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {RsRx}]
#Sch name = JA4
#set_property PACKAGE_PIN G2 [get_ports {LED_flash}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {LED_flash}]
#Sch name = JA7
#set_property PACKAGE_PIN H1 [get_ports {rx_shift_p}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {rx_shift_p}]
#Sch name = JA8
#set_property PACKAGE_PIN K2 [get_ports {rx_done_tick_p}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {rx_done_tick_p}]
##Sch name = JA9
#set_property PACKAGE_PIN H2 [get_ports {JA[6]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[6]}]
##Sch name = JA10
#set_property PACKAGE_PIN G3 [get_ports {JA[7]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]

##Pmod Header JB
#Bank = 15, Pin name = IO_L15N_T2_DQS_ADV_B_15,				Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {buzz_out}]
set_property IOSTANDARD LVCMOS33 [get_ports {buzz_out}]
###Bank = 14, Pin name = IO_L13P_T2_MRCC_14,					Sch name = JB2
#set_property PACKAGE_PIN A16 [get_ports {DinA}]
#set_property IOSTANDARD LVCMOS33 [get_ports {DinA}]
###Bank = 14, Pin name = IO_L21N_T3_DQS_A06_D22_14,			Sch name = JB3
#set_property PACKAGE_PIN B15 [get_ports {DinB}]
#set_property IOSTANDARD LVCMOS33 [get_ports {DinB}]
###Bank = CONFIG, Pin name = IO_L16P_T2_CSI_B_14,				Sch name = JB4
#set_property PACKAGE_PIN B16 [get_ports {daclk}]
#set_property IOSTANDARD LVCMOS33 [get_ports {daclk}]
##Bank = 15, Pin name = IO_25_15,							Sch name = JB7
#set_property PACKAGE_PIN K16 [get_ports {JB[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[4]}]
##Bank = CONFIG, Pin name = IO_L15P_T2_DQS_RWR_B_14,			Sch name = JB8
#set_property PACKAGE_PIN R16 [get_ports {JB[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[5]}]
##Bank = 14, Pin name = IO_L24P_T3_A01_D17_14,				Sch name = JB9
#set_property PACKAGE_PIN T9 [get_ports {JB[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[6]}]
##Bank = 14, Pin name = IO_L19N_T3_A09_D25_VREF_14,			Sch name = JB10
#set_property PACKAGE_PIN U11 [get_ports {JB[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[7]}]


## These additional constraints are recommended by Digilent, do not remove!
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]