----------------------------------------------------------------------------------
-- Company: Engs 31 20S
-- Engineer: Garret ANdreine, Wesley Heim, Shane Hewitt
-- 
-- Create Date: 06/08/2020 03:02:37 PM
-- Design Name: Oscillator_logic
-- Module Name: oscillator_logic_block - Behavioral
-- Project Name: Morse Code Final Project
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: Produces wave for output of morse code block
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY oscillator IS
PORT ( 	clk				: 	in 	STD_LOGIC;
		enable_bit : in std_logic;
        output: out std_logic);
end oscillator;


ARCHITECTURE behavioral of oscillator is
begin 

  output_logic: process(enable_bit, clk)
  begin
    if enable_bit = '1' then
        output <= clk;
    else
        output <= '0';
    end if;

  end process output_logic;
  
end behavioral;
        
        

