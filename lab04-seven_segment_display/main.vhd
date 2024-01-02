library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity main is
	port(
		clk : in std_logic; -- clock
		sw : in  std_logic_vector(15 downto 0); -- 16 switches
		an : out std_logic_vector(7 downto 0); -- 8 displays
		sseg : out std_logic_vector(7 downto 0) -- 8 display segments
	);
end main;


architecture arch of main is
	signal led7, led6, led5, led4, led3, led2, led1, led0 : std_logic_vector(7 downto 0);
	signal increment3, increment2, increment1, increment0 : std_logic_vector(3 downto 0);
begin
	hex_to_sseg_1 : entity work.hex_to_sseg(arch)
		port map(
			hex => sw(3 downto 0),
			dp => '1',
			sseg => led0
		);
	hex_to_sseg_2 : entity work.hex_to_sseg(arch)
		port map(
			hex => sw(7 downto 4),
			dp => '1',
			sseg => led1
		);
	hex_to_sseg_3 : entity work.hex_to_sseg(arch)
		port map(
			hex => sw(11 downto 8),
			dp => '1',
			sseg => led2
		);
	hex_to_sseg_4 : entity work.hex_to_sseg(arch)
		port map(
			hex => sw(15 downto 12),
			dp => '1',
			sseg => led3
		);

	increment0 <= std_logic_vector(unsigned(sw(3 downto 0)) + 1);
	increment1 <= std_logic_vector(unsigned(sw(7 downto 4)) + 1);
	increment2 <= std_logic_vector(unsigned(sw(11 downto 8)) + 1);
	increment3 <= std_logic_vector(unsigned(sw(15 downto 12)) + 1);

	hex_to_sseg_5 : entity work.hex_to_sseg(arch)
		port map(
			hex => increment0,
			dp => '1',
			sseg => led4
		);
	hex_to_sseg_6 : entity work.hex_to_sseg(arch)
		port map(
			hex => increment1,
			dp => '1',
			sseg => led5
		);

	hex_to_sseg_7 : entity work.hex_to_sseg(arch)
		port map(
			hex => increment2,
			dp => '1',
			sseg => led6
		);
	hex_to_sseg_8 : entity work.hex_to_sseg(arch)
		port map(
			hex => increment3,
			dp => '1',
			sseg => led7
		);

	mux : entity work.led_mux8(arch)
		port map(
			clk => clk,
			reset => '0',
			in0 => led0,
			in1 => led1,
			in2 => led2,
			in3 => led3,
			in4 => led4,
			in5 => led5,
			in6 => led6,
			in7 => led7,
			an => an,
			sseg => sseg
		);

end arch;

