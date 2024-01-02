----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:	 13:41:34 09/29/2020 
-- Design Name: 
-- Module Name:	 eq_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity eq_top is
	port(
		sw  : in  std_logic_vector(3 downto 0); -- 4 switches
		led : out std_logic_vector(0 downto 0)  -- 1 red LED
	);
end eq_top;

architecture struc_arch of eq_top is
begin
	-- instantiate 2-bit comparator
	eq2_unit : entity work.eq2(struc_arch)
		port map(
			a	 => sw(3 downto 2), -- a to switches 3 and 2
			b	 => sw(1 downto 0), -- b to switches 3 and 2
			aeqb => led(0)			 -- output to led(0)
		);
end struc_arch;

