----------------------------------------------------------------------------------
-- Company: Engs 31 20S
-- Engineer: Garret Andreine, Wesley Heim, Shane Hewitt 
-- 
-- Create Date: 06/04/2020 11:40:22 PM
-- Design Name: UART Reciever
-- Module Name: Serial_Rx
-- Project Name: Morse Code Final Project 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: UART Reciever functionality  
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

entity SerialRx is
Port ( 	clk : in STD_LOGIC; -- 10MHz master clock
		RsRx : in STD_LOGIC; -- received bit stream
		rx_data : out STD_LOGIC_VECTOR (7 downto 0); -- data byte
		rx_done_tick : out STD_LOGIC ); -- data ready tick
end SerialRx;

ARCHITECTURE behavior of SerialRx is

type state_type is (idle, wait2, wait1, done, reset_b, count_r, baud_eq);
signal current_state, next_state : state_type;
-- Declares states

--Datapath elements
constant BAUD_PERIOD : integer := 1042; --(10 MHz / 9600 = 1042) Round Up
signal baud_count : integer := 0;
signal start_count: std_logic := '0';

--creat your other datapath elements here
signal counter: unsigned(3 downto 0) := "0000";
signal shiftreg: std_logic_vector(8 downto 0) := (others => '0');

signal flip1: std_logic := '1';  -- flip flop synchronizer 
signal flip2: std_logic := '1';
signal edge_detect : std_logic := '0';
signal count_en: std_logic := '0';
signal reset: std_logic := '0';

signal shift_flag: std_logic := '0';
signal take_data: std_logic := '0';
signal Irx_data : STD_LOGIC_VECTOR (7 downto 0) := "00000000";

BEGIN 

stateUpdate: process(clk) --Makes state change each clk rise
begin
    	if rising_edge(clk) then
    		current_state <= next_state;
        end if;
end process stateUpdate;

nextStateLogic: process(current_state, flip2, counter, baud_count, edge_detect) --switch for states
begin  
  
	case (current_state) is
		when idle =>
            
             rx_done_tick <= '0'; 
             shift_flag <= '0';
             take_data <= '0';
             start_count <= '0'; 
             reset <= '0';
             count_en <= '0';
            
        	if flip2 = '0' and edge_detect = '1' then  -- when we get a leading bit signal go to next wait state
           		next_state <= wait2;
            else
                next_state <= current_state;
            end if;
            
		when wait2 =>
            
            rx_done_tick <= '0'; 
            shift_flag <= '0';
            take_data <= '0';
            start_count <= '1';  -- Enables baud counter 
            reset <= '0';
            count_en <= '0';
            
            if baud_count = BAUD_PERIOD/2 - 1 then  -- Don't need to shift in this bit
            	next_state <= reset_b;			-- Because it's just our starting zero
            else
                 next_state <= current_state; 
            end if;
        
        when reset_b =>
        
            rx_done_tick <= '0'; 
            shift_flag <= '0';
            take_data <= '0';
            start_count <= '0';  -- Resets baud counter 
            reset <= '0';
            count_en <= '0';

            next_state <= wait1;
            
        when wait1 => 
            rx_done_tick <= '0'; 
            shift_flag <= '0';
            take_data <= '0';
            start_count <= '1';  -- to start baud counter 
            reset <= '0';
            count_en <= '0';
            
            if counter = 8 then -- when you get last bit
                next_state <= count_r;
            elsif baud_count = BAUD_PERIOD - 1 then  -- Shift in data to register 
                next_state <= baud_eq;
            else
                next_state <= wait1;
            end if;
            
        when baud_eq =>
            rx_done_tick <= '0'; 
            shift_flag <= '1';
            take_data <= '0';
            start_count <= '0';  -- to reset baud counter 
            reset <= '0';
            count_en <= '1';  -- to enable bit counter
            
            next_state <= wait1;
          
        when count_r =>
            rx_done_tick <= '0'; 
            shift_flag <= '0';
            take_data <= '1';
            start_count <= '0';  -- to reset baud counter 
            reset <= '1';
            count_en <= '0'; 
  
            next_state <= done;
            
        when done =>
        
            rx_done_tick <= '1'; 
            shift_flag <= '0';
            take_data <= '0';
            start_count <= '0';  -- to reset baud counter 
            reset <= '0';
            count_en <= '0';  -- to enable bit counter        
        
        	next_state <= idle;
        
		when others => 
            rx_done_tick <= '0'; 
            shift_flag <= '0';
            take_data <= '0';
            start_count <= '0'; 
            reset <= '0';
            count_en <= '0';
		  
		    next_state <= idle;  -- Just in case 

  end case;
  
end process nextStateLogic;

end_data: process(clk)
begin
    if rising_edge(clk) then
        if take_data = '1' then
            Irx_data <= shiftreg(8 downto 1); -- maybe issue
        else
            Irx_data <= Irx_data;
        end if;
    end if;
end process end_data;

rx_data <= Irx_data; -- set the internal data out to output asynchronously

baud_tick: process(clk, start_count)  
begin

    if rising_edge(clk) then
        if start_count = '1' then  -- if enabled to baud count 
            baud_count <= baud_count + 1;
        else 
            baud_count <= 0;
        end if;
    end if;

end process baud_tick;

flip_flop: process(clk)
begin

    if rising_edge(clk) then
      flip1 <= RsRx;  -- flip flop synchronizer to just make sure the data is accurate 
      flip2 <= flip1;
      edge_detect <= flip2;
    end if;

end process flip_flop;

count_proc: process(clk)
begin

    if rising_edge(clk) then
        if count_en = '1' then
            counter <= counter + 1; -- keep track of how many bits you recieve and shift them in
        elsif reset = '1' then
            counter <= "0000";
        end if;
    end if;


end process count_proc;

register_proc: process(clk)
begin

    if rising_edge(clk) then  -- To output data 
        if shift_flag = '1' then
            shiftreg <= flip2 & shiftreg(8 downto 1);
        end if;
    end if;

end process register_proc; 

end behavior;

