----------------------------------------------------------------------------------
-- Company: Engs 31 20S
-- Engineer: Garret Andreine, Wesley Heim, Shane Hewitt 
-- 
-- Create Date: 06/04/2020 11:40:22 PM
-- Design Name: Morse Code Shell Testbench
-- Module Name: TopLevel_tb
-- Project Name: Morse Code Final Project 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: Final prject top level testbench 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
 
ENTITY toplevel_tb IS
END toplevel_tb;
 
ARCHITECTURE behavior OF toplevel_tb IS 
 
component TopLevel is
    Port ( Clk : in  STD_LOGIC;
           RsRx  : in  STD_LOGIC;
			 RsTx  : out  STD_LOGIC );
end component;

   --Inputs
   signal clk : std_logic := '0';
   signal RsRx : std_logic := '1';

 	--Outputs
   signal RsTx : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10ns;		-- 10 MHz clock
	
	-- Data definitions
	constant bit_time : time := 104us;		-- 9600 baud
	
	-- Characters for Transmission
	constant TxDataA : std_logic_vector(7 downto 0) := "01000001"; -- letter A
	constant TxDataB : std_logic_vector(7 downto 0) := "01000010"; -- letter B
	constant TxDataC : std_logic_vector(7 downto 0) := "01000011"; -- letter C
	constant TxDataD : std_logic_vector(7 downto 0) := "01000100"; -- letter D
	constant TxDataE : std_logic_vector(7 downto 0) := "01000101"; -- letter E
	constant TxData2 : std_logic_vector(7 downto 0) := "00110010"; -- Number 2
    constant TxData4 : std_logic_vector(7 downto 0) := "00110100"; -- Number 4
    constant TxData7 : std_logic_vector(7 downto 0) := "00110111"; -- Number 7
    constant TxData0 : std_logic_vector(7 downto 0) := "00110000"; -- Number 0
	constant TxDataS : std_logic_vector(7 downto 0) := "00100000"; -- Space Char
	constant TxDataL : std_logic_vector(7 downto 0) := "00001010"; -- Cariage Return Char
	
	
BEGIN 
	-- Instantiate the Unit Under Test (UUT)
   uut: TopLevel PORT MAP (
          clk => clk,
          RsRx => RsRx,
          RsTx => RsTx
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
		wait for 100 us;
		wait for 10.25*clk_period;		
		
		RsRx <= '0';		-- Start bit
		wait for bit_time;
		
		for bitcount in 0 to 7 loop
			RsRx <= TxDataA(bitcount);
			wait for bit_time;
		end loop;
		
		RsRx <= '1';		-- Stop bit
		wait for bit_time; --200 us;
		
		RsRx <= '0';		-- Start bit
		wait for bit_time;
		
		for bitcount in 0 to 7 loop
			RsRx <= TxDataD(bitcount);
			wait for bit_time;
		end loop;
		
		RsRx <= '1';		-- Stop bit
		wait for bit_time; --200 us;
		
		RsRx <= '0';		-- Start bit
                wait for bit_time;
                
        for bitcount in 0 to 7 loop
            RsRx <= TxDataS(bitcount);
            wait for bit_time;
        end loop;
                
           RsRx <= '1';        -- Stop bit
           wait for bit_time;
           
           RsRx <= '0';		-- Start bit
           wait for bit_time;
                   
           for bitcount in 0 to 7 loop
               RsRx <= TxData2(bitcount);
               wait for bit_time;
           end loop;
           
           RsRx <= '1';        -- Stop bit
           wait for bit_time; --200 us;
           
           RsRx <= '0';		-- Start bit
           wait for bit_time;
                   
           for bitcount in 0 to 7 loop
               RsRx <= TxDataD(bitcount);
               wait for bit_time;
           end loop;
                   
              RsRx <= '1';        -- Stop bit
              wait for bit_time;
              
--            RsRx <= '0';		-- Start bit
--            wait for bit_time;
                    
--            for bitcount in 0 to 7 loop
--                RsRx <= TxData2(bitcount);
--                wait for bit_time;
--            end loop;
                    
--               RsRx <= '1';        -- Stop bit
--               wait for bit_time;
               
--                RsRx <= '0';		-- Start bit
--               wait for bit_time;
                       
--               for bitcount in 0 to 7 loop
--                   RsRx <= TxData7(bitcount);
--                   wait for bit_time;
--               end loop;
                       
--                  RsRx <= '1';        -- Stop bit
--                  wait for bit_time;          
                       
--                 RsRx <= '0';		-- Start bit
--                wait for bit_time;
                        
--                for bitcount in 0 to 7 loop
--                    RsRx <= TxDataS(bitcount);
--                    wait for bit_time;
--                end loop;
                        
--                   RsRx <= '1';        -- Stop bit
--                   wait for bit_time;
                                   
                  RsRx <= '0';		-- Start bit
                  wait for bit_time;
                          
                  for bitcount in 0 to 7 loop
                      RsRx <= TxDataL(bitcount);
                      wait for bit_time;
                  end loop;
                          
                     RsRx <= '1';        -- Stop bit
                     wait for bit_time;                                   
		wait;
   end process;
END;

