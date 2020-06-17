----------------------------------------------------------------------------------
-- Company: Engs 31 20S
-- Engineer: Garret Andreine, Wesley Heim, Shane Hewitt 
-- 
-- Create Date: 06/04/2020 11:40:22 PM
-- Design Name: UART Transmitter
-- Module Name: Serial_Tx
-- Project Name: Morse Code Final Project 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: UART Transmitter functionality  
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:  Made possible with the contributions of many great
-- teaching staff and designs made with the help of Matt Gardner
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SerialTx is
    Port ( clk : in  STD_LOGIC;
           tx_data : in  STD_LOGIC_VECTOR (7 downto 0);
           tx_start : in  STD_LOGIC;
           tx : out  STD_LOGIC;					    -- to RS-232 interface
           tx_done_tick : out  STD_LOGIC);
end SerialTx;


ARCHITECTURE behavior of SerialTx is
--Datapath elements

constant BAUD_PERIOD : integer := 1042; --Number of clock cycles needed to achieve a baud rate of 256,000 given a 100 MHz clock (100 MHz / 256000 = 391)
--adjusted to 9600 baud/10MHz clock -> 1042

--create your other datapath elements here
signal shift_reg : std_logic_vector(9 downto 0) := (others => '1'); --all zeros w/ active low bus
signal baud_count : unsigned(10 downto 0) := (others => '0'); -- count up to 1042
signal count : unsigned(3 downto 0) := "0000";
signal baud_tc : std_logic := '0';

BEGIN

--Datapath
datapath : process(clk) --everything should be synchronous in this design.
begin
	if rising_edge(clk) then  
    
        -- create baud counter
        baud_tc <= '0';
        baud_count <= baud_count + 1;
        if baud_count = BAUD_PERIOD then
        	baud_tc <= '1';
        	baud_count <= (others => '0');
        end if;
        
        if tx_start = '1' then
        	baud_count <= (others => '0');
        end if;
        
        -- create shift register
        if tx_start = '1' then
        	shift_reg <= '1' & tx_data & '0';
        elsif baud_tc = '1' then
        	shift_reg <= '1' & shift_reg(9 downto 1); 
        end if;
        --right-shift and append a '1' in the MSB             
        
    end if;
end process datapath;

counter: process (clk)
begin

	if rising_edge(clk) then  -- emission process for tx_done tick
    	if tx_start = '1' then
        	count <= (others => '0');
        else
        	if baud_tc = '1' then
            	count <= count + 1;
            end if;
        end if;
        
        if count = 9 then
        	count <= (others => '0');
            tx_done_tick <= '1';
        else
        	tx_done_tick <= '0';
        end if;
    end if;
end process counter;
        
--hardwire the LSB of the Shift Register to the output Tx.
tx <= shift_reg(0);

end behavior;
