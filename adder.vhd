library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity adder is 
	port(
			dataa	: in  unsigned(15 downto 0);
			datab	: in  unsigned(15 downto 0);
			sum		: out unsigned(15 downto 0)
	);
end adder;

architecture comb of adder is
begin
	
	sum <= dataa + datab;
	
end comb;