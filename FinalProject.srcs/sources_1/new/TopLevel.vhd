----------------------------------------------------------------------------------
-- Company: Engs 31 20S
-- Engineer: Garret Andreine, Wesley Heim, Shane Hewitt 
-- 
-- Create Date: 06/04/2020 11:40:22 PM
-- Design Name: Morse Code Shell
-- Module Name: TopLevel - Behavioral
-- Project Name: Morse Code Final Project 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: Final prject top level wiring of all componenets together 
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
use IEEE.NUMERIC_STD.ALL;  -- Include all needed Libraries 
library UNISIM;					-- needed for the BUFG component
use UNISIM.Vcomponents.ALL;

entity TopLevel is
  Port( clk: in std_logic;
        RsRx: in std_logic;
        LED_flash: out std_logic;
        buzz_out: out std_logic;
        seg :   out std_logic_vector(0 to 6);
        an  :   out std_logic_vector(3 downto 0);
        RsTx: out std_logic );
end TopLevel;

architecture Behavioral of TopLevel is

-- Signals for the 100 MHz to 10 MHz clock divider
constant CLOCK_DIVIDER_VALUE: integer := 5;
signal clkdiv: integer := 0;			-- the clock divider counter
signal clk_en: std_logic := '0';		-- terminal count
signal clk10: std_logic;				-- 10 MHz clock signal

-- Signals for UART processes 
signal rx_data : std_logic_vector(7 downto 0);
signal rx_done_tick : std_logic;
signal tx_done_tick: std_logic;

--Signals for Queue block
signal decoder_finished : std_logic  := '0';
signal decoder_in: std_logic_vector(7 downto 0) := (others => '0');
signal not_decoder_finished : std_logic := '0';

--Signals for Decode block
signal block_addr: std_logic_vector(7 downto 0) := (others => '0');
signal ready_mp: std_logic := '0';

--Signals for Memory map
signal twenty_str: std_logic_vector(19 downto 0) := (others => '0');

--Signals for output logic
signal enter_sig : std_logic := '0';

--Signal for LED
signal LED_flash_sig : std_logic := '0';

--Signal for oscillator
signal osc : std_logic := '0';
signal sound_clkdiv : integer := 0;
signal sound_clk_en :   std_logic;

-- Signals for 7 segment display
signal slot_one, slot_two :   std_logic_vector(7 downto 0) := (others => '0');
signal dp, updated_7seg   :   std_logic := '0';

-- Component Declarations
COMPONENT SerialRx  -- Serial Reciever
	PORT(
		Clk : IN std_logic;
		RsRx : IN std_logic;      
		rx_data :  out std_logic_vector(7 downto 0);
		rx_done_tick : out std_logic  );
END COMPONENT;

COMPONENT SerialTx 
    PORT(  -- Serial Transmitter 
        clk : in  STD_LOGIC;  -- 10Mhz clock
        tx_data : in  STD_LOGIC_VECTOR (7 downto 0);  -- data to be sent
        tx_start : in  STD_LOGIC;  -- start signal
        tx : out  STD_LOGIC;	-- data out
        tx_done_tick : out  STD_LOGIC);  -- done signal
END COMPONENT;

Component Output_Logic
    Port (clk : in std_logic;
          decoder_out : in std_logic_vector(19 downto 0); --decoder has updated decoder_out
          decoder_mp : in std_logic; --tells output logic that 
          enter : in std_logic;
          ready_mp : out std_logic; --tells decoder that the output 
          led_buzz : out std_logic); --logic is ready for another signal
end Component;

Component decoder is
    port (clk	:	in	std_logic;
		  decode_en	:	in	std_logic;
		  letter	:	in	std_logic_vector(7 downto 0);
          done_tick	:	out	std_logic;
          address	:	out	std_logic_vector(7 downto 0));
end Component;

component blk_mem_gen_0 is
    port(   clka    :   in  std_logic;
            ena :   in  std_logic;
            addra   :   in  std_logic_vector(7 downto 0);
            douta   :   out std_logic_vector(19 downto 0));
end component;

component Queue_Block is
    Port (clk : in std_logic;
          uart_mp : in std_logic;
          uart_data : in std_logic_vector(7 downto 0);
          decoder_in_en : in std_logic;
          enter : out std_logic;
          char_out : out std_logic_vector(7 downto 0));
end component;

component oscillator is 
    Port (clk : in std_logic;
          enable_bit : in std_logic;
          output : out std_logic); 
end component;

component mux7seg is
    Port ( clk : in  STD_LOGIC;									-- runs on a fast (1 MHz or so) clock
           y0, y1, y2, y3 : in  STD_LOGIC_VECTOR (7 downto 0);	-- digits
           dp_set : in std_logic_vector(3 downto 0);            -- decimal points
           seg : out  STD_LOGIC_VECTOR(0 to 6);				    -- segments (a...g)
           dp : out std_logic;
           an : out  STD_LOGIC_VECTOR (3 downto 0) );	      -- anodes
end component;

begin
LED_flash <= LED_flash_sig;
buzz_out <= osc;
-- Clock buffer for 10 MHz clock
-- The BUFG component puts the slow clock onto the FPGA clocking network
Slow_clock_buffer: BUFG
      port map (I => clk_en,
                O => clk10 );

-- Divide the 100 MHz clock down to 20 MHz, then toggling the 
-- clk_en signal at 20 MHz gives a 10 MHz clock with 50% duty cycle
Clock_divider: process(clk)
begin
	if rising_edge(clk) then
	   	if clkdiv = CLOCK_DIVIDER_VALUE-1 then 
	   		clk_en <= NOT(clk_en);		
			clkdiv <= 0;
		else
			clkdiv <= clkdiv + 1;
		end if;
	end if;
end process Clock_divider; 

SOUND_clk_divider:  process(clk10)
begin
    if rising_edge(clk10) then
        if sound_clkdiv = 10000 - 1 then
            sound_clk_en <= NOT(sound_clk_en);
            sound_clkdiv <= 0;
        else
            sound_clkdiv <= sound_clkdiv + 1;
        end if;
    end if;
 end process SOUND_clk_divider;

display_proc:   process(decoder_finished, clk10)
begin
    if rising_edge(clk10) then
        if decoder_finished = '1' then
            slot_one(3 downto 0) <= decoder_in(3 downto 0);
            slot_two(3 downto 0) <= decoder_in(7 downto 4);
        else
        
        end if;
    end if;
    
end process display_proc;

--slot_one(3 downto 0) <= decoder_in(3 downto 0) when decoder_finished = '1';
--slot_two(3 downto 0) <= decoder_in(7 downto 4) when decoder_finished = '1';

Receiver: SerialRx PORT MAP(
    clk => clk10,  -- receiver is clocked with 10 MHz clock
    RsRx => RsRx,  --  
    rx_data => rx_data,  -- Data for Queue 
    rx_done_tick => rx_done_tick);

        
Trasmitter: SerialTx PORT MAP(  --changed name from UART_Tx 
    clk => clk10, -- made Clk upper case c
    tx_data  => rx_data,  -- data to be sent
    tx_start => rx_done_tick,  -- start signal
    tx => RsTx,	-- data out
    tx_done_tick => tx_done_tick);  -- done signal
    
Decoder_map: decoder PORT MAP(
    clk => clk10,
    decode_en => ready_mp,
    letter => decoder_in,
    done_tick => decoder_finished,
    address => block_addr);

Queue_input: Queue_Block PORT MAP(
     clk => clk10,
     uart_mp => rx_done_tick,
     uart_data => rx_data,
     decoder_in_en => decoder_finished,
     enter => enter_sig,
     char_out => decoder_in);

Memory_map: blk_mem_gen_0 PORT MAP (
    clka => clk10, --changed from clk10
    ena => '1', -- comming from wes output block 
    addra => block_addr,
    douta => twenty_str);
    
Output_timer: Output_Logic PORT MAP (
    clk => clk10,
    decoder_out => twenty_str, --decoder has updated decoder_out
    decoder_mp => '1',--decoder_finished, 
    enter => enter_sig,
    ready_mp =>  ready_mp, --tells decoder that the output                    
    led_buzz => LED_flash_sig);--logic is ready for another signal

oscillator_block: oscillator PORT MAP (
    clk => sound_clk_en,
    enable_bit => LED_flash_sig,
    output => osc);
    

display: mux7seg port map( 
            clk => clk10,				-- runs on the 1 MHz clock
           	y3 => x"00", 		        
           	y2 => x"10", -- A/D converter output  	
           	y1 => slot_two, 		
           	y0 => slot_one,		
           	dp_set => "0000",           -- decimal points off
          	seg => seg,
          	dp => dp,
           	an => an );	

end Behavioral;
