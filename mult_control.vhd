--******************************************************************************
--                                                                             *
--                  Copyright (C) 2014 Altera Corporation                      *
--                                                                             *
-- ALTERA, ARRIA, CYCLONE, HARDCOPY, MAX, MEGACORE, NIOS, QUARTUS & STRATIX    *
-- are Reg. U.S. Pat. & Tm. Off. and Altera marks in and outside the U.S.      *
--                                                                             *
-- All information provided herein is provided on an "as is" basis,            *
-- without warranty of any kind.                                               *
--                                                                             *
-- Module Name: mult_control               ile Name: mult_control.vhd          *
--                                                                             *
-- Module Function: state machine control logic for the multiplier             *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for "control"
ENTITY mult_control IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs "clk", "reset_a", "start", "count"
		clk, reset_a, start : IN STD_LOGIC;
		count : IN UNSIGNED (1 DOWNTO 0);
		
		-- Declare output control signals "in_sel", "shift_sel", "state_out", "done", "clk_ena" and "sclr_n"
		input_sel, shift_sel : OUT UNSIGNED(1 DOWNTO 0);
		state_out : OUT UNSIGNED(2 DOWNTO 0);
		done, clk_ena, sclr_n : OUT STD_LOGIC
	);
-- End entity
END ENTITY mult_control;

--  Begin architecture 
ARCHITECTURE logic OF mult_control IS

	-- Declare enumberated state type consisting of 6 values:  "idle", "lsb", "mid", "msb", "calc_done" and "err"
--- ############### ----
--- YOUR LOGIC HERE ----
--- ############### ----
	TYPE state_type is (idle, lsb, mid, msb, calc_done, err);
	-- Declare two signals named "current_state" and "next_state" to be of enumerated type
--- ############### ----
--- YOUR LOGIC HERE ----
--- ############### ----
	SIGNAL current_state, next_state	: state_type;
 
BEGIN
	-- Create sequential process to control state transitions by making current_state equal to next state on
	--	rising edge transitions; Use asynchronous clear control
	PROCESS (clk, reset_a)
	BEGIN
		IF(reset_a = '1') THEN
			current_state <= idle;
		ELSIF (clk'event and clk = '1') THEN
			current_state <= next_state;
		END IF;
	END PROCESS;
	
	-- Create combinational process & case statement to determine next_state based on current state and inputs
	PROCESS (current_state, start, count)
	BEGIN
		CASE current_state IS
			WHEN idle =>
				IF start = '1' THEN
					next_state <= lsb;
				ELSE
					next_state <= idle;
				END IF;
-- complete the case statements
--- ############### ----
--- YOUR LOGIC HERE ----
--- ############### ----
			WHEN lsb =>
				IF start = '0' and count = "00" THEN
					next_state <= mid;
				ELSE
					next_state <= err;
				END IF;
			WHEN mid =>
				IF start = '0' and count = "01" THEN
					next_state <= mid;
				ELSIF start = '0' and count = "10" THEN
					next_state <= msb;
				ELSE
					next_state <= err;
				END IF;
			WHEN msb =>
				IF start = '0' and count = "11" THEN
					next_state <= calc_done;
				ELSE
					next_state <= err;
				END IF;
			WHEN calc_done =>
				IF start = '0' THEN
					next_state <= idle;
				ELSIF start = '1' THEN
					next_state <= err;
				END IF;
			WHEN err =>
				IF start = '0'  THEN
					next_state <= err;
				ELSIF start = '1' THEN
					next_state <= lsb;
				END IF;
		END CASE;
	-- End process
	END PROCESS;

	-- Create process for Mealy output logic for input_sel, shift_sel, done, clk_ena and sclr_n(outputs function of inputs and current_state)
	mealy: PROCESS (current_state, start, count) 
	BEGIN
	
		-- Initialize outputs to default values so case only covers when they change
		-- #### the following default values may need to be changed ####
		input_sel <= "00";
		shift_sel <= "00";
		done <= '0';
		clk_ena <= '0';
		sclr_n <= '1';
		
		CASE current_state IS
			WHEN idle =>
				IF start = '1' THEN
					sclr_n <= '0';
					clk_ena <= '1';
				END IF;
-- complete the case statments....
--- ############### ----
--- YOUR LOGIC HERE ----
--- ############### ----
			WHEN lsb =>
				IF start = '0' and count = "00" THEN
					sclr_n <= '1';
					clk_ena <= '1';
				ELSE
					sclr_n <= '1';
					clk_ena <= '0';
				END IF;
			WHEN mid =>
				IF start = '0' and count = "01" THEN
					input_sel <= "01";
					shift_sel <= "01";
					clk_ena <= '1';
					sclr_n <= '1';
				ELSIF start = '0' and count = "10" THEN
					input_sel <= "10";
					shift_sel <= "01";
					clk_ena <= '1';
					sclr_n <= '1';
				END IF;
			WHEN msb =>
				IF start = '0' and count = "11" THEN
					input_sel <= "11";
					shift_sel <= "10";
					clk_ena <= '1';
					sclr_n <= '1';
				END IF;
			WHEN calc_done =>
				IF start = '0' THEN
					done  <= '1';
				END IF;
			WHEN err =>
		END CASE;
	-- End process
	END PROCESS mealy;

	-- Create process for Moore output logic for state_out  (outputs function of current_state only)
		moore: PROCESS(current_state)
		BEGIN
			-- Initialize state_out to default values so case only covers when they change
			state_out <= "000";
			
			CASE current_state IS
				WHEN idle =>
				WHEN lsb =>
					state_out <= "001";
				WHEN mid =>
					state_out <= "010";
				WHEN msb =>
					state_out <= "011";
				WHEN calc_done =>
					state_out <= "100";
				WHEN err =>
					state_out <= "101";
				
-- complete the case statements
--- ############### ----
--- YOUR LOGIC HERE ----
--- ############### ----



			END CASE;
		-- End process
		END PROCESS moore;
-- End architecture
END ARCHITECTURE logic;