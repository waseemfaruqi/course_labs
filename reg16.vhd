library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16 is
	port(
			clk		: in 	std_logic;
			sclr_n	: in 	std_logic;
			clk_ena	: in 	std_logic;
			datain	: in 	unsigned(15 downto 0);
			reg_out	: out unsigned(15 downto 0)
	);
end reg16;

architecture arch of reg16 is
begin
	
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if(clk_ena = '1') then
				if(sclr_n = '0') then
					reg_out	<= "0000000000000000";
				else
					reg_out	<= datain;
				end if;
			end if;
		end if;
		
		
	end process;
end arch;