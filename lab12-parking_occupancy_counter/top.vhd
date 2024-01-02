library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity top is
	port (
		sw : in std_logic_vector(1 downto 0);
		clk : in std_logic;
		led : out std_logic_vector(1 downto 0)
	);
end top;

architecture arch of top is
	constant N : integer := 99999999;
	signal enable : std_logic;
	signal divide_clk : integer range 0 to N;
begin
	fsm : entity work.fsm
		port map(
			a => sw(1), 
			b => sw(0), 
			car_enter => led(0), 
			car_exit => led(1), 
			clk => clk, 
			reset => '0', 
			enable => enable
		);

    enable <= '1' when divide_clk = N else '0';

	process (clk) begin
		if (clk'EVENT and clk = '1') then
			divide_clk <= divide_clk + 1;
			if divide_clk = N then
				divide_clk <= 0;
			end if;
		end if;
	end process;

end arch;