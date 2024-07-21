library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
	port(
			input 		: in  unsigned(7  downto 0);
			shift_cntrl	: in  unsigned(1  downto 0);
			shift_out	: out unsigned(15 downto 0)
	);
end shifter;

architecture arch of shifter is
begin
	
	process(input, shift_cntrl)
	begin
		if(shift_cntrl = "00" or shift_cntrl = "11") then
			shift_out	<= "00000000" & input;
		elsif(shift_cntrl = "01") then
			shift_out	<= "0000" & input & "0000";
		elsif(shift_cntrl = "10") then
			shift_out	<= input & "00000000";
		else
			shift_out	<= "0000000000000000";
		end if;
	end process;
	
	
end arch;
	
	