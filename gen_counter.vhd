LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity gen_counter is

-- we are using the generic construct to allow this counter to be generic
	generic (
				wide : positive; -- how many bits is the counter
				max  : positive -- what is the max value of the counter ( modulus )
	);
	
	port (
				clk	 		:in  std_logic; -- system clock
				ctr_ena 		:in  std_logic; -- ctr_ena
				reset	 		:in  std_logic; -- reset to zeros use i_count <= (others => '0' ) since size depends on generic
				term_out	 	:out std_logic; -- maximum count is reached
				count_out 	:out std_logic_vector(wide-1 downto 0)
	);
	
end; -- end entity gen_counter
	
architecture rtl of gen_counter is

	signal i_count : unsigned (wide-1 downto 0) := (others => '0'); -- see how we made this generic using the generics above

begin

-- counter process, asynchronously clears the counter to 0's
-- allows the count value to be preset/loaded with a value when
-- the load signal is high, and has priority
-- once the counter is ctr_enad the counter will start counting until it rolls over
-- or the max count is met. 

counter: process(clk, reset) 

begin

  if (reset='1') then -- active high reset
			 i_count <= (others => '0'); -- set counter to 0's
			 term_out <= '0';  -- want the terminal count off on reset
	 
  elsif (rising_edge(clk)) then
		 if (ctr_ena = '1') then -- if ctr_ena is high then the counter is running.
		 
				if (i_count = max) then -- the max value is hit, synchronously set to '0'
				  term_out <= '1'; -- signal for a state change
				  i_count <= (others => '0'); -- set counter to 0's

				else -- increment the counter
				  term_out <= '0'; 
				  i_count <= i_count + 1;
				  
				end if; 
		 end if;		
   end if;
	
	
end process;

	count_out <= std_logic_vector(i_count); -- we type cast the count back to std_logic_vector

end;
				
		