library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4 is
	port(
			mux_in_a		: in  unsigned(3 downto 0);
			mux_in_b		: in  unsigned(3 downto 0);
			mux_sel		: in  std_logic;
			mux_out		: out unsigned(3 downto 0)
	);
end mux4;

architecture arch of mux4 is
begin
	
	process(mux_in_a, mux_in_b, mux_sel)
	begin
		if(mux_sel = '1') then
			mux_out		<= mux_in_b;
		else
			mux_out		<= mux_in_a;
		end if;
	end process;
	
end arch;	
