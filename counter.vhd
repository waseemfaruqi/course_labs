library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is 
	port(
			clk		: in  std_logic;
			aclr_n	: in  std_logic;
			count_out: out unsigned(1 downto 0)
	);
end counter;

architecture arch of counter is
begin
	
	process(clk, aclr_n)
	variable count		: unsigned (1 downto 0);
	begin
		if(aclr_n = '0') then
			count		:= "00";
		else
			if(clk'event and clk = '1') then
				if(count = "11") then
					count	:= "00";
				else
					count := count + 1;
				end if;
			end if;
		end if;
		count_out	<= count;
	end process;
		
end arch;