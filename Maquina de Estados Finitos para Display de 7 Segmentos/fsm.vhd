----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alvaro Davi S. Alves
-- 
-- Create Date:    12:42:10 02/17/2022 
-- Design Name: 
-- Module Name:    fsm - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fsm is
port (
	clk: in std_logic;
	reset: in std_logic;
	dig: out std_logic_vector(1 downto 0);
	letter: out std_logic_vector(7 downto 0)
);
end fsm;


architecture Behavioral of fsm is
	type state is (U,F,E,S);
	signal current_state: state;
	signal current_dig: std_logic_vector(1 downto 0);
	signal timer_tick: std_logic;
begin
	process(clk, timer_tick, reset) is
	begin
		if (reset = '1') then
			current_dig <= "11";
			dig <= current_dig;
			letter <= "11111111"; -- initial state
			timer_tick <= '0';
		elsif (rising_edge(clk)) then
			timer_tick <= '1';
			case current_state is
				when U =>
					if (timer_tick = '1') then
						current_dig <= "11";
						dig <= current_dig;
						letter <= "01010101"; --  U state
						current_state <= F;
					end if;
				when F =>
					if (current_dig = "11" and timer_tick = '1') then
						current_dig <= "10";
						dig <= current_dig;
						letter <= "01000110"; --  F state
						current_state <= E;
					end if;
				when E =>
					if (current_dig = "10" and timer_tick = '1') then
						current_dig <= "01";
						dig <= current_dig;
						letter <= "01000101"; --  E state
						current_state <= S;
					end if;
				when S =>
					if (current_dig = "01" and timer_tick = '1') then
						current_dig <= "00";
						dig <= current_dig;
						letter <= "01010011"; --  S state
						current_state <= U;
					end if;
			end case;
			timer_tick <= '1';
		end if;
	end process;
end Behavioral;

