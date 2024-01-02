library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		sw : in std_logic_vector(1 downto 0);
		clk : in std_logic;
		an : out std_logic_vector(7 downto 0);
		sseg : out std_logic_vector(7 downto 0)
	);
end top;

architecture arch of top is
	constant N : integer := 99999998;
	signal enable : std_logic;
	signal divide_clk : integer range 0 to N;
begin
	fsm : entity work.fsm_display
		port map(
			cw => sw(1), 
			en => sw(0), 
			clk => clk, 
			reset => '0', 
			enable => enable, 
			an => an, 
			sseg => sseg
		);

		enable <= '1' when divide_clk = N else '0';

	process (clk) begin
		if (clk'event and clk = '1') then
			divide_clk <= divide_clk + 1;
			if divide_clk = N then
				divide_clk <= 0;
			end if;
		end if;
	end process;

end arch;

