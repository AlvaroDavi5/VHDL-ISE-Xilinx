----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:58:26 10/12/2020
-- Design Name: 
-- Module Name:    prog_prior_encoder - Behavioral
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


entity prog_prior_encoder is
	port (
		r : in std_logic_vector(7 downto 0);
		c : in std_logic_vector(2 downto 0);
		code : out std_logic_vector(2 downto 0);
		active : out std_logic
	);
end prog_prior_encoder;
-- r = 8 bits, c = 3 bits, code = 3 bits, active = 1 bit


architecture behavioral of prog_prior_encoder is
	signal mask, lower_r, upper_r : std_logic_vector (7 downto 0);
	signal lower_code, upper_code: std_logic_vector (2 downto 0);
	signal lower_active : std_logic;
begin
--==================
-- mask generator
--==================
	with c select
		mask <= "11111111" when "111",
				"01111111" when "110",
				"00111111" when "101",
				"00011111" when "100",
				"00001111" when "011",
				"00000111" when "010",
				"00000011" when "001",
				"00000001" when others;
--==================
-- upper_r and lower_r
--==================
	upper_r <= r and (not mask);
	lower_r <= r and mask;
--==================
-- 8_to_3 priority encoder to upper_code and lower_code
--==================
	upper_code <= "111" when (upper_r(7) = '1') else
					"110" when (upper_r(6) = '1') else
					"101" when (upper_r(5) = '1') else
					"100" when (upper_r(4) = '1') else
					"011" when (upper_r(3) = '1') else
					"010" when (upper_r(2) = '1') else
					"001" when (upper_r(1) = '1') else
					"000";

	lower_code <= "111" when (lower_r(7) = '1') else
					"110" when (lower_r(6) = '1') else
					"101" when (lower_r(5) = '1') else
					"100" when (lower_r(4) = '1') else
					"011" when (lower_r(3) = '1') else
					"010" when (lower_r(2) = '1') else
					"001" when (lower_r(1) = '1') else
					"000";
--==================
-- active and lower_active 
--==================
	active <= r(7) or r(6) or
						r(5) or r(4) or 
						r(3) or r(2) or 
						r(1) or r(0);

	lower_active <= lower_r(7) or lower_r(6) or
						lower_r(5) or lower_r(4) or 
						lower_r(3) or lower_r(2) or 
						lower_r(1) or lower_r(0);
--==================
-- Criar bloco MUX 2:1 de 3 bits para gerar code
--==================
	process(upper_code, lower_code, lower_active)
	begin
		if (lower_active = '1') then
			code <= lower_code;
		else
			code <= upper_code;
		end if;
	end process;
--==================
-- finally
--==================
end behavioral;

