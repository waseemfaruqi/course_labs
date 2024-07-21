library ieee;
use ieee.std_logic_1164.all;

entity lights_tb is
end lights_tb;

architecture tb of lights_tb is

signal clock		: std_logic;
signal reset		: std_logic;
signal sens_left	: std_logic;
signal night_mode	: std_logic;
signal LED_G_N		: std_logic;
signal LED_Y_N		: std_logic;
signal LED_R_N		: std_logic;
signal LED_G_S		: std_logic;
signal LED_Y_S		: std_logic;
signal LED_R_S		: std_logic;
signal LED_G_E		: std_logic;
signal LED_Y_E		: std_logic;
signal LED_R_E		: std_logic;
signal LED_G_W		: std_logic;
signal LED_Y_W		: std_logic;
signal LED_R_W		: std_logic;
signal LED_G_NS	: std_logic;
signal LED_Y_NS	: std_logic;
signal LED_G_EW	: std_logic;
signal LED_Y_EW	: std_logic;

component lights is
	port(clock			: in std_logic;
		  reset			: in std_logic;
		  sens_left		: in std_logic;
		  night_mode	: in std_logic;
		  LED_G_N		: out std_logic;
		  LED_Y_N		: out std_logic;
		  LED_R_N		: out std_logic;
		  LED_G_S		: out std_logic;
		  LED_Y_S		: out std_logic;
		  LED_R_S		: out std_logic;
		  LED_G_E		: out std_logic;
		  LED_Y_E		: out std_logic;
		  LED_R_E		: out std_logic;
		  LED_G_W		: out std_logic;
		  LED_Y_W		: out std_logic;
		  LED_R_W		: out std_logic;
		  LED_G_NS		: out std_logic;
		  LED_Y_NS		: out std_logic;
		  LED_G_EW		: out std_logic;
		  LED_Y_EW		: out std_logic
		  );
	
end component;
				  

				  
				  
				  
begin

	UUT: lights 
	port map ( clock			=> clock,
				  reset			=> reset,
				  sens_left		=> sens_left,
				  night_mode	=> night_mode,
				  LED_G_N		=> LED_G_N,
				  LED_Y_N		=> LED_Y_N,
				  LED_R_N		=> LED_R_N,
				  LED_G_S		=> LED_G_S,
				  LED_Y_S		=> LED_Y_S,
				  LED_R_S		=> LED_R_S,
				  LED_G_E		=> LED_G_E,
				  LED_Y_E		=> LED_Y_E,
				  LED_R_E		=> LED_R_E,
				  LED_G_W		=> LED_G_W,
				  LED_Y_W		=> LED_Y_W,
				  LED_R_W		=> LED_R_W,
				  LED_G_NS		=> LED_G_NS,
				  LED_Y_NS		=> LED_Y_NS,
				  LED_G_EW		=> LED_G_EW,
				  LED_Y_EW		=> LED_Y_EW
				  );
				  
	clk: process
	begin
		clock	<= '0';
		wait for 500 ps;
		clock	<= '1';
		wait for 500 ps;
	end process;
	
	reset			<= '0', '1' after 2 ns;
	sens_left	<= '0';
	night_mode	<= '0';
end tb;














