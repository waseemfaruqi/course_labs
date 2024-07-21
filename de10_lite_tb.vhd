LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity de10_lite_tb is
end entity;

architecture behav of de10_lite_tb is

component de10_lite_base is
port (
	--clocks

	MAX10_CLK1_50			:	in		std_logic;

	--seven seg
	HEX0, HEX1, HEX2,
	HEX3, HEX4, HEX5		:	out	std_logic_vector(6 downto 0);
	--general human interface
	KEY						:	in	std_logic_vector(2 downto 0);
	SW							:  in std_logic_vector(9 downto 0)

);
end component;
	
constant CLK_PER:time := 20 ns;
constant clk_cycle:time := 2*clk_per;

signal clk    :   std_logic;
signal sw     :   std_logic_vector(9 downto 0); -- used for shift command
signal key    :   std_logic_vector(2 downto 0); -- used for halt and reset
signal hex0	  :   std_logic_vector(6 downto 0); -- right most
signal hex1	  :	std_logic_vector(6 downto 0);	
signal hex2	  :	std_logic_vector(6 downto 0);	
signal hex3	  :	std_logic_vector(6 downto 0);	
signal hex4	  :	std_logic_vector(6 downto 0);	
signal hex5	  :	std_logic_vector(6 downto 0); -- left most

--cnt_rst

begin
	
	
	clock:process begin  -- this process just continues to run as the simulation time continues
		 clk <= '0';
		 wait for CLK_PER;
		 clk <= '1';
		 wait for CLK_PER;
	end process;
		
	
	
	vectors:process begin -- put you test vectors here, remember to advance the simulation in modelsim

	
		------------- Section to check shift operation --------------
		key(0) <= '1'; 		   -- set the asynchronous reset signal low
		key(1) <= '1'; 		   -- enable (is inverted)
		key(2) <= '1';
		sw     <= "0000000000"; -- drive all the switch inputs to a 0
		wait for 40*clk_cycle;-- wait until right before 11th state change and then set shift high
		sw     <= "0000000001"; -- shift L
		wait for 80*clk_cycle;   -- keep shift input high for 2 clock cycles
		sw     <= "0000000000"; -- drive all the switch inputs to a 0
	
		---------- Section to check asynch reset operation ----------
		wait for 17.5*clk_cycle;-- wait a few state changes so we arent on 0 state and test asynchronous reset
		key(0) <= '0';          -- set asynch reset high
		wait for 10*clk_cycle; -- wait for 2.4 clk cycles so reset is low before rising edge clk
		key(0) <= '1';          -- set reset back to low
		key(1) <= '0';			   -- enable goes low halting shift
		wait for 60*clk_cycle;   -- wait 4 clk cycles
		
		----------- Section to check halt operation -----------------
		wait for 3*clk_cycle;   -- wait a few clock cycles for term_out to go high and test shift
		key(2) <= '0';			   -- enable goes low halting shift
		wait for 80*clk_cycle;   -- wait 4 clk cycles
		sw     <= "0000000001"; -- ensure halt still works when shift enabled  
		wait for 2*clk_cycle;	-- wait 2 clk cycles
		key(0) <= '0';          -- test asynch reset when shift and halt are high
		wait for 2.9*clk_cycle; -- wait for 2.9 clk cycles so reset is low before rising edge clk
		key(0) <= '1';          -- set reset low
		sw     <= "0000000000"; -- set shift back to low
		key(2) <= '1';			   -- set enable back to high
		wait for 0.1*clk_cycle; -- line back up with clock pulses
		
	end process;
	


-- instantiate the device under test (dut)
dut :de10_lite_base
port map (
	
	--clocks		
	MAX10_CLK1_50	=> clk,					
	--seven seg
	HEX0 		=> hex0,
	HEX1 		=> hex1,
	HEX2		=> hex2,
	HEX3 		=> hex3,
	HEX4 		=> hex4,
	HEX5		=> hex5,
	--general human interface
	KEY		=> key, 			
	SW			=> sw							

);
end architecture;
		
		
		
	
	