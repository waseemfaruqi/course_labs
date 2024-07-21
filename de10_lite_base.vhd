library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- dont touch entity
entity de10_lite_base is 

	port (

		--clocks
		MAX10_CLK1_50	:	in		std_logic;

		--seven seg
		HEX0, HEX1, HEX2, 
		HEX3, HEX4, HEX5 : out	std_logic_vector(6 downto 0);
		
		--general human interface
		KEY				:	in		std_logic_vector(2 downto 0);
		SW					:	in		std_logic_vector(9 downto 0)
		--LEDR			:	out	std_logic_vector(9 downto 0)

	);
	
end entity;

ARCHITECTURE de10_lite OF de10_lite_base IS

	component gen_counter is

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
		
	end component; 

	component seven_segment_cntrl is
	port(
			input			: in  unsigned(4 downto 0);
			seven_seg	: out std_logic_vector(6 downto 0)
		);
		
	end component;

	
	type state is (zero, one, two, three, four, five, six);
	
	signal state_reg, state_next	: state;
	signal one_sec, two_sec, tick	: std_logic;
	signal timer_1, timer_2, timer: unsigned (4 downto 0);
	signal fast, direction, freeze: std_logic;
	signal hex_input_0,
			 hex_input_1, 
			 hex_input_2,
			 hex_input_3, 
			 hex_input_4, 
			 hex_input_5				: unsigned(4 downto 0);
	signal rst							: std_logic;
	
Begin		
	
	rst	<= not KEY(0);
	
	GC1_sec: gen_counter 
					generic map(
						wide => 3, 
						max  => 5
						)
					port map(
						clk	 		=> MAX10_CLK1_50,
						ctr_ena 		=> '1',
						reset	 		=> rst,
						term_out	 	=> one_sec,
						count_out 	=> open
						);
	GC2_sec: gen_counter 
					generic map(
						wide => 4, 
						max  => 10
						)
					port map(
						clk	 		=> MAX10_CLK1_50,
						ctr_ena 		=> '1',
						reset	 		=> rst,
						term_out	 	=> two_sec,
						count_out 	=> open
						);
	
	process(fast, one_sec, two_sec)
	begin
		if(fast = '0') then
			--timer	<= timer_1;
			tick	<= one_sec;
		else
			--timer <= timer_2;
			tick	<= two_sec;
		end if;
	end process;
	
	SS0 : seven_segment_cntrl 
			port map(
					input			=> hex_input_0, 
					seven_seg	=> HEX0
					);
	SS1 : seven_segment_cntrl 
			port map(
					input			=> hex_input_1, 
					seven_seg	=> HEX1
					);
					
	SS2 : seven_segment_cntrl 
			port map(
					input			=> hex_input_2, 
					seven_seg	=> HEX2
					);
					
	SS3 : seven_segment_cntrl 
			port map(
					input			=> hex_input_3, 
					seven_seg	=> HEX3
					);
					
	SS4 : seven_segment_cntrl 
			port map(
					input			=> hex_input_4, 
					seven_seg	=> HEX4
					);
					
	SS5 : seven_segment_cntrl 
			port map(
					input			=> hex_input_5, 
					seven_seg	=> HEX5
					);
					
	
	process (MAX10_CLK1_50, rst)
	begin
		if (rst = '1') then
			state_reg	<= zero;
			fast			<= '0';
			direction	<= '0';
			freeze		<= '0';
		elsif rising_edge(MAX10_CLK1_50) and tick = '1' then
			state_reg	<= state_next;
			fast			<= SW(0);
			direction	<= KEY(1);
			freeze		<= KEY(2);
		end if;
	end process;
	
	
	process (state_reg, freeze, direction)
	begin
		state_next <= state_reg;
		case state_reg is 
			when zero =>
				hex_input_0 <= "00000";
				hex_input_1	<= "00111";
				hex_input_2	<=	"00101";
				hex_input_3	<=	"00100";
				hex_input_4	<=	"01110";
				hex_input_5	<=	"01110";
				if( freeze = '1') then
					if(direction = '1') then
						state_next	<= one;
					else
						state_next	<= six;
					end if;
				else
					state_next	<= state_reg;
				end if;
			when one =>
				hex_input_0 <= "00001";
				hex_input_1	<= "10000";
				hex_input_2	<=	"00111";
				hex_input_3	<=	"00101";
				hex_input_4	<=	"00100";
				hex_input_5	<=	"01110";
				
				if( freeze = '1' ) then
					if(direction = '1') then
						state_next	<= two;
					else
						state_next	<= zero;
					end if;
				else
					state_next	<= state_reg;
				end if;
			when two =>
				hex_input_0 <= "00010";
				hex_input_1	<= "10000";
				hex_input_2	<=	"10000";
				hex_input_3	<=	"00111";
				hex_input_4	<=	"00101";
				hex_input_5	<=	"00100";
				
				if( freeze ='1') then
					if(direction = '1') then
						state_next	<= three;
					else
						state_next	<= one;
					end if;
				else
					state_next	<= state_reg;
				end if;
			when three =>
				hex_input_0 <= "00011";
				hex_input_1	<= "01110";
				hex_input_2	<=	"10000";
				hex_input_3	<=	"10000";
				hex_input_4	<=	"00111";
				hex_input_5	<=	"00101";
				
				if( freeze = '1') then
					if(direction = '1') then
						state_next	<= four;
					else
						state_next	<= two;
					end if;
				else
					state_next	<= state_reg;
				end if;
			when four =>
				hex_input_0 <= "00100";
				hex_input_1	<= "01110";
				hex_input_2	<=	"01110";
				hex_input_3	<=	"10000";
				hex_input_4	<=	"10000";
				hex_input_5	<=	"00111";
				
				if( freeze = '1') then
					if(direction = '1') then
						state_next	<= five;
					else
						state_next	<= three;
					end if;
				else
					state_next	<= state_reg;
				end if;
			when five =>
				hex_input_0 <= "00101";
				hex_input_1	<= "00100";
				hex_input_2	<=	"01110";
				hex_input_3	<=	"01110";
				hex_input_4	<=	"10000";
				hex_input_5	<=	"10000";
				
				if( freeze = '1') then
					if(direction = '1') then
						state_next	<= six;
					else
						state_next	<= four;
					end if;
				else
					state_next	<= state_reg;
				end if;
			when six =>
				hex_input_0 <= "00110";
				hex_input_1	<= "00101";
				hex_input_2	<=	"00100";
				hex_input_3	<=	"01110";
				hex_input_4	<=	"01110";
				hex_input_5	<=	"10000";
				
				if( freeze = '1') then
					if(direction = '1') then
						state_next	<= zero;
					else
						state_next	<= five;
					end if;
				else
					state_next	<= state_reg;
				end if;
			when others	=>
				hex_input_0 <= "10000";
				hex_input_1	<= "10000";
				hex_input_2	<=	"10000";
				hex_input_3	<=	"10000";
				hex_input_4	<=	"10000";
				hex_input_5	<=	"10000";
		end case;
	end process;
end de10_lite;


























