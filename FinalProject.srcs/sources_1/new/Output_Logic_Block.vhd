----------------------------------------------------------------------------------
-- Company: Engs 31 20S
-- Engineer: Garret Andreine, Wesley Heim, Shane Hewitt 
-- 
-- Create Date: 06/04/2020 11:40:22 PM
-- Design Name: Output Logic Block
-- Module Name: Output_Logic
-- Project Name: Morse Code Final Project 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: Takes in decoder data and interprets it to the output 
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

entity Output_Logic is
    Port (clk : in std_logic;
          decoder_out : in std_logic_vector(19 downto 0);
          decoder_mp : in std_logic; --tells output logic that 
          							 --decoder has updated decoder_out
          enter : in std_logic;
          ready_mp : out std_logic; --tells decoder that the output 
          							--logic is ready for another signal
          led_buzz : out std_logic);
end Output_Logic;

architecture Behavioral of Output_Logic is

type state_type is (start,idle,load,output,letterpause);
signal current_state, next_state : state_type;
signal read_bit : integer := 18; --initial 18
signal decoded_reg : std_logic_vector(19 downto 0) := (others => '0');
signal on_count : unsigned(22 downto 0) := (others => '0');
signal load_en, idle_en, output_en, letterpause_en, start_en, output_done, letterpause_done, read_ahead, space : std_logic := '0';
signal load_count : unsigned(1 downto 0) := "00";
constant T : integer := 1000000;

begin
datapath : process(clk)
begin

if rising_edge(clk) then
    current_state <= next_state;	
    
    if start_en = '1' then
        led_buzz <= '0';
    else
    
    end if;
    
    if load_en = '1' then
    	decoded_reg <= decoder_out;
        --led_buzz <= '0';
        load_count <= load_count + 1;
        
    end if;
    
        
    if output_en = '1' and output_done = '0' then
        load_count <= "00";
        if decoded_reg(19) = '1' then
            if (on_count < 4*T) then
                on_count <= on_count + 1;
                led_buzz <= '0';
            else
                on_count <= (others => '0');
                output_done <= '1';
                space <= '1';
            end if;   

        else
        	if decoded_reg(read_bit) = '1' then
            	if (on_count < T) and read_ahead = '0' then 
                	on_count <= on_count + 1;
                	led_buzz <= '1';
                    
                elsif read_ahead = '1' then
                	if (on_count < T) then
                    	led_buzz <= '0';
                    	on_count <= on_count + 1;
                	else
                    	on_count <= (others => '0');
                    	if read_bit > 1 then
                            read_bit <= read_bit - 2;
                        else
                            output_done <= '1';
                            read_bit <= 18;
                        end if;
                        read_ahead <= '0';
                    end if;
                
            	else
                	on_count <= (others => '0');
                	if read_bit > 0 then
                    	if decoded_reg(read_bit - 1) = '0' then
                        	read_ahead <= '1';
                        else 
                        	read_bit <= read_bit - 1;   
                        end if;
                    else
                    	output_done <= '1';
                        read_bit <= 18;
                    end if;
                end if;
            else
                if read_bit > 0 then
           		   read_bit <= read_bit - 1;
           		else
           		   output_done <= '1';
           		   read_bit <= 18;
           		end if;
            end if;
        end if;
    else
    	output_done <= '0';
        space <= '0';
    end if;
    
    
    if letterpause_en = '1' then
    	if on_count < 2*T then --wait for 0.3s
            led_buzz <= '0';
            on_count <= on_count + 1;
        else
        	on_count <= (others => '0');
			letterpause_done <= '1';
        end if;
    else
    	letterpause_done <= '0';
    end if;
    
    
end if;
end process datapath;


nextStateLogic: process(enter,current_state, decoder_mp, output_done, letterpause_done, decoder_out, space, load_count)
begin

next_state <= current_state;
    
case (current_state) is
        when start => 	    load_en <= '0';
        					output_en <= '0';
                            letterpause_en <= '0';
                            ready_mp <= '0';
                            start_en <= '1';
                            if enter = '1' then
                                next_state <= idle;
                            end if;
                            
        when idle => 	    load_en <= '0';
                            idle_en <= '1';
        					output_en <= '0';
                            letterpause_en <= '0';
                            start_en <= '0';
                            ready_mp <= '1';                            
            				if decoder_mp = '1' then
            					next_state <= load;
            			    else 
            			        next_state <= current_state;
                            end if;
                            
        when load =>		--next_state <= output;
        					load_en <= '1';
        					idle_en <= '0';
        					output_en <= '0';
        					start_en <= '0';
            		        letterpause_en <= '0';    
                            ready_mp <= '0';
                            if load_count = 2 then
                                next_state <= output;
                            else
                                next_state <= load;
                            end if;
                            
        when output =>	    load_en <= '0';
        					output_en <= '1';
                            letterpause_en <= '0';
                            ready_mp <= '0';
                            start_en <= '0';
                            
                            if output_done = '1' and space = '0' then
                            	next_state <= letterpause;
                            elsif output_done = '1' and space = '1' then
                            	next_state <= idle;
                            end if;
                            
        when letterpause =>	load_en <= '0';
        					output_en <= '0';
                            letterpause_en <= '1';
                            ready_mp <= '0';
                            start_en <= '0';
                            
                            if letterpause_done = '1' then
                            	next_state <= idle;
                            end if;
            
        when others =>      next_state <= idle;
                            load_en <= '0';
        					output_en <= '0';
                            ready_mp <= '0';
                            letterpause_en <= '0';
                            start_en <= '0';
   
end case;
end process nextStateLogic;

end Behavioral;
