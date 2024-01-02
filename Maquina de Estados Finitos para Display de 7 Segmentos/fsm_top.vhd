----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:18:56 11/11/2020 
-- Design Name: 
-- Module Name:    fsm_top - Behavioral 
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
entity fsm_top is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           letter : out  STD_LOGIC_VECTOR (7 downto 0);
           dig : out  STD_LOGIC_VECTOR (1 downto 0));
end fsm_top;

architecture Behavioral of fsm_top is
	signal timer_tick: std_logic;
begin
   fsm_unit: entity work.fsm(Behavioral)
      port map(clk=>clk, reset=>reset, 
		         timer_tick=>timer_tick,
               dig=>dig, 
					letter=>letter);
	-- instancia o timer
	timer_unit: entity work.timer (Behavioral)
						port map ( clk => clk, 
						reset => reset, 
						timer_tick => timer_tick);

end Behavioral;

