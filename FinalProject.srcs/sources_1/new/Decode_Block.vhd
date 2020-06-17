----------------------------------------------------------------------------------
-- Company: Engs 31 20S
-- Engineer: Garret Andreine, Wesley Heim, Shane Hewitt 
-- 
-- Create Date: 06/04/2020 11:40:22 PM
-- Design Name: Decode_Block
-- Module Name: Decoder
-- Project Name: Morse Code Final Project 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: Decodes ASCII Data 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity decoder is
port (	clk	:	in	std_logic;
		decode_en	:	in	std_logic;
		letter	:	in	std_logic_vector(7 downto 0);
        done_tick	:	out	std_logic;
        address	:	out	std_logic_vector(7 downto 0));
end decoder;
        
architecture behavior of decoder is
-- signals
signal letter_encoding	:	unsigned(7 downto 0)	:= (others => '0');
signal decode_en_signal_1 : std_logic := '0';
signal decode_en_signal : std_logic := '0';
signal done_count : std_logic := '0';
signal temp_count, count : std_logic := '0';
begin

letter_encoding <= unsigned(letter(7 downto 0));
path	:	process( clk)
begin
	--done_tick <= '1';
    --address <= (others => '0');
    --letter_encoding <= unsigned(letter(7 downto 0));
  	if rising_edge(clk) then
  	    --done_tick <= '0';
  	    --letter_encoding <= unsigned(letter(7 downto 0));
  	    done_count <= '0';
  	    temp_count <= '0';
        if decode_en = '1' then --if output logic asking
            done_count <= '1';
            temp_count <= done_count;
        end if;      

    end if;
        
end process path;

address <= std_logic_vector(letter_encoding - 65) when letter_encoding <= 90 and letter_encoding >= 65 else -- letters 
           std_logic_vector(letter_encoding - 23) when letter_encoding <= 57 and letter_encoding >= 49 else -- 1 through 9
           std_logic_vector(letter_encoding - 13) when letter_encoding = 48 else --0
           std_logic_vector(letter_encoding + 4)  when letter_encoding = 32 else -- space
           std_logic_vector(letter_encoding - 91) when letter_encoding >= 91 and letter_encoding <= 116 else -- lowercase
           "00100101"; -- Enter character

done_tick <= temp_count xor done_count;

end architecture;
