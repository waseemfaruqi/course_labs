library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult4x4 is
	port(
			dataa		: in  unsigned(3 downto 0);
			datab		: in  unsigned(3 downto 0);
			product	: out unsigned(7 downto 0)
	);
end mult4x4;

architecture comb of mult4x4 is
begin
	
	product		<= dataa * datab;
	
	
end comb;