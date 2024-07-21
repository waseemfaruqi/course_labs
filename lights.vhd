library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lights is
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
	
end lights;

architecture bhv of lights is

type 		state is (RST, Green_NS_Red_EW, Red_NS_Green_EW, Orange_NS_Orange_EW, Left_Turn_Green_NS, Left_Turn_Yellow_NS, Left_Turn_Green_EW, Left_Turn_Yellow_EW, NIGHT_NS, NIGHT_EW);
signal	next_state, current_state			: state;
signal 	done_9, done_2, done_11, done_b 	: std_logic;
signal	sens_left_r1, sens_left_r2			: std_logic;
signal   night_mode_r1,	night_mode_r2		: std_logic;
component counter is 

	generic	( N :	natural	:= 4);
	
	port( clock		 : in  std_logic;
			reset		 : in  std_logic;
			ld_val	 : in  std_logic_vector(N-1 downto 0);
			done		 : out std_logic;
			count_val : out std_logic_vector(N-1 downto 0)
		  );
end component;

begin
	
	G: counter	
	port map	( clock		=> clock,
				  reset		=> reset,
				  ld_val	   => "1001",
				  done		=> done_9
				 );
	
	Y: counter	
	port map	( clock		=> clock,
				  reset		=> reset,
				  ld_val	   => "0010",
				  done		=> done_2
				 );
	
	R: counter	
	port map	( clock		=> clock,
				  reset		=> reset,
				  ld_val	   => "1011",
				  done		=> done_11
				 );
	
	
	blink: counter	
	port map	( clock		=> clock,
				  reset		=> reset,
				  ld_val	   => "0011",
				  done		=> done_b
				 );
				 
	process(clock)
	begin
		if(rising_edge(clock)) then
			sens_left_r1	<= sens_left;
			night_mode_r1	<= night_mode;
		end if;
	end process;
	
	process(clock)
	begin
		if(rising_edge(clock)) then
			sens_left_r2	<= sens_left_r1;
			night_mode_r2	<= night_mode_r1;
		end if;
	end process;
	
	process(clock, reset)
	begin
		if reset = '0' then
			current_state		<= RST;
		elsif(rising_edge(clock)) then
				current_state	<= next_state;
		end if;
	end process;
	
	process(current_state, done_9, done_2, done_11, sens_left_r2, night_mode_r2)
	begin
		if night_mode_r2 = '1' then			
			if current_state = NIGHT_NS then
				next_state <= NIGHT_EW;
			else
				next_state <= NIGHT_NS;
			end if;
		else
	
			case current_state is
				when RST =>
					next_state	<= Green_NS_Red_EW;
					
				when Green_NS_Red_EW =>
					if sens_left_r2 = '1' then
						next_state	<= Left_Turn_Green_NS;
					elsif done_9 = '1' then
						next_state	<= Orange_NS_Orange_EW;
					end if;
				
				when Orange_NS_Orange_EW =>
					if done_2 = '1' then
						next_state	<= Red_NS_Green_EW;
					end if;
				
				when Red_NS_Green_EW =>
					if sens_left_r2 = '1' then
						next_state	<= Left_Turn_Green_EW;
					elsif done_9 = '1' then
						next_state	<= Green_NS_Red_EW;
					end if;
				
				when Left_Turn_Green_NS =>
					next_state		<= Left_Turn_Yellow_NS;
				
				when Left_Turn_Green_EW =>
					next_state		<= Left_Turn_Yellow_EW;
					
				when Left_Turn_Yellow_NS =>
					next_state		<= Red_NS_Green_EW;
				
				when Left_Turn_Yellow_EW =>
					next_state		<= Green_NS_Red_EW;
				
				when NIGHT_NS	=>
					next_state		<= Green_NS_Red_EW;
				
				when NIGHT_EW =>
					next_state		<= Green_NS_Red_EW;
				
				when others =>
					next_state		<= RST;
				
			end case;
		end if;
	end process;
	
	process(current_state)
	begin
		LED_G_N		<= '0';
		LED_Y_N		<= '0';
		LED_R_N		<= '0';
		LED_G_S		<= '0';
		LED_Y_S		<= '0';
		LED_R_S		<= '0';
		LED_G_E		<= '0';
		LED_Y_E		<= '0';
		LED_R_E		<= '0';
		LED_G_W		<= '0';
		LED_Y_W		<= '0';
		LED_R_W		<= '0';
		LED_G_NS		<= '0';
		LED_Y_NS		<= '0';
		LED_G_EW		<= '0';
		LED_Y_EW		<= '0';
		  
		case current_state is
			when Green_NS_Red_EW 		=>	
				LED_G_N		<= '1';
				LED_G_S		<= '1';
				LED_R_E		<= '1';
				LED_R_W		<= '1';
			
			when Orange_NS_Orange_EW 	=>
				LED_Y_N		<= '1';
				LED_Y_S		<= '1';
				LED_Y_E		<= '1';
				LED_Y_W		<= '1';
			
			when Red_NS_Green_EW 		=>
				LED_R_N		<= '1';
				LED_R_S		<= '1';
				LED_G_E		<= '1';
				LED_G_W		<= '1';
			
			when Left_Turn_Green_NS 	=>
				LED_G_NS		<= '1';
			
			when Left_Turn_Green_EW 	=>
				LED_G_EW		<= '1';
			
			when Left_Turn_Yellow_NS 	=>
				LED_Y_NS		<= '1';
			
			when Left_Turn_Yellow_EW 	=>
				LED_Y_EW		<= '1';
			
			when NIGHT_NS					=>
				LED_Y_N		<= '1';
				LED_Y_S		<= '1';
				LED_R_E		<= '1';
				LED_R_W		<= '1';	
			
			when NIGHT_EW					=>	
				LED_R_N		<= '1';
				LED_R_S		<= '1';
				LED_Y_E		<= '1';
				LED_Y_W		<= '1';
			
			when others 					=>
				LED_G_N		<= '0';
				LED_Y_N		<= '0';
				LED_R_N		<= '0';
				LED_G_S		<= '0';
				LED_Y_S		<= '0';
				LED_R_S		<= '0';
				LED_G_E		<= '0';
				LED_Y_E		<= '0';
				LED_R_E		<= '0';
				LED_G_W		<= '0';
				LED_Y_W		<= '0';
				LED_R_W		<= '0';
				LED_G_NS		<= '0';
				LED_Y_NS		<= '0';
				LED_G_EW		<= '0';
				LED_Y_EW		<= '0';
		end case;
		
	end process;
	
end bhv;













































