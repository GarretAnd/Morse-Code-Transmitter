----------------------------------------------------------------------------------
-- Company: Engs 31 20S
-- Engineer: Garret Andreine, Wesley Heim, Shane Hewitt 
-- 
-- Create Date: 06/04/2020 11:40:22 PM
-- Design Name: Queue
-- Module Name: Queue_logic
-- Project Name: Morse Code Final Project 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: Queue to hold data and spit out data to encoder 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Queue_Block is
    Port (clk : in std_logic;
          uart_mp : in std_logic;
          uart_data : in std_logic_vector(7 downto 0);
          decoder_in_en : in std_logic;
          enter : out std_logic;
          char_out : out std_logic_vector(7 downto 0));
end Queue_block;

architecture Behavioral of Queue_Block is

type state_type is (idle,in_queue,out_queue,load);
signal current_state, next_state : state_type;
signal in_reg_en,queue_in, queue_out,enter_detected : std_logic := '0';
signal in_reg : std_logic_vector(7 downto 0) := (others => '0');
signal first_char : unsigned(2 downto 0) := (others => '0');

type regfile is array(0 to 149) of STD_LOGIC_VECTOR(7 downto 0);
signal queue_reg : regfile;
signal w_addr : integer := 0;
signal r_addr : integer := 0;


begin
datapath : process(clk)
begin
    if rising_edge(clk) then
        current_state <= next_state;
        
        if (in_reg_en = '1') then
        	enter_detected <= '0';
        	if uart_data = "00001010" then
            	enter_detected <= '1';
            	in_reg <= uart_data;
            else
        		in_reg <= uart_data;
            end if;
        end if;
        
        if (queue_in = '1') then
        	Queue_reg(w_addr) <= in_reg;
            if w_addr = 149 then
            	w_addr <= 0;
      		else
            	w_addr <= w_addr + 1;
            end if;
        end if;
        
        if (decoder_in_en = '1') and (r_addr /= w_addr) and (queue_out = '1') then
            Queue_reg(r_addr) <= (others => '0');
        	if r_addr = 149 then
            	r_addr <= 0;
      		else
            	   r_addr <= r_addr + 1; -- r_addr when in this state is not incrementing.
                end if;
        end if;
    end if;

end process datapath;

char_out <= queue_reg(r_addr) when (decoder_in_en = '1') and (r_addr /= w_addr) and (queue_out = '1') else
              "00000000";
enter <= enter_detected;

nextStateLogic: process(uart_mp,enter_detected,current_state, r_addr, w_addr)
begin

next_state <= current_state;
    
case (current_state) is
        when idle => 	    in_reg_en <= '0';
            				queue_in <= '0';
                            queue_out <= '0';
            				if uart_mp = '1' then
            					next_state <= load;
                            else
            			        next_state <= current_state;
                            end if;
                            
        when load =>		next_state <= in_queue;
        					in_reg_en <= '1';
            				queue_in <= '0';
                            queue_out <= '0';
            		            
                            
        when in_queue =>	in_reg_en <= '0';
                            queue_out <= '0';
            				queue_in <= '1';
							if enter_detected = '1' then
                            	next_state <= out_queue;
                            else
                            	next_state <= idle;
                            end if;
                            
        when out_queue =>   in_reg_en <= '0';
        					queue_in <= '0';
        					queue_out <= '1';
                            if (r_addr = w_addr) then
                            	next_state <= idle;
                            else 
                            	next_state <= current_state;
                            end if;
            
        when others =>      next_state <= idle;
                            in_reg_en <= '1';
            				queue_in <= '0';
                            queue_out <= '0';
   
end case;
			
end process nextStateLogic;

end Behavioral;