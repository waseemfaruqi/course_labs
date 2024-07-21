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
-- Module Name: adder_tb                        File Name: adder_tb.vhd        *
--                                                                             *
-- Module Function: This file contains the testbench for the Introduction      *
-- 					to VHDL lab 1a  								           *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY adder_tb IS
END ENTITY adder_tb;

ARCHITECTURE stimulus OF adder_tb IS

	-- Component declaration for adder block
	COMPONENT adder
		PORT  (
			dataa, datab: IN UNSIGNED(15 DOWNTO 0);
			sum: OUT UNSIGNED(15 DOWNTO 0)
		);
	END COMPONENT;

	-- Signals to connect to DUT
	SIGNAL dataa, datab, sum : UNSIGNED (15 DOWNTO 0);

BEGIN  -- beginning of architecture body

	-- instantiate unit under test (adder)
	adder1 : adder PORT MAP 
		(dataa => dataa, datab => datab, sum => sum);

	-- Assign values to "dataa" and "datab" to test adder block
	dataa <= x"0008", x"0000" AFTER 20 NS, x"000A" AFTER 30 NS;
	datab <= x"0005", x"0001" AFTER 20 NS, x"0005" AFTER 30 NS;
		
END ARCHITECTURE stimulus;