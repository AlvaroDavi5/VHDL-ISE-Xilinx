library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter is
	generic(N : integer := 4); -- 4 bits
	port(
		clk      : in std_logic;
		reset    : in std_logic;
		enable   : in std_logic;
		inc      : in std_logic;
		dec      : in std_logic;
		q        : out std_logic_vector(N-1 downto 0);
		max_tick : out std_logic
	);
end counter;

architecture arch of counter is
	signal r_reg  : unsigned(N-1 downto 0);
	signal r_next : unsigned(N-1 downto 0);
begin
	-- register
	process(clk, enable, reset)
	begin
		if (reset = '1') then
			r_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			if (enable = '1') then
				r_reg <= r_next;
			end if;
		end if;
	end process;

	-- next-state logic
	process(inc, dec, r_reg)
	begin
		if dec = '1' then
			r_next <= r_reg - 1;
		elsif inc= '1' then
			r_next <= r_reg + 1;
		else
			r_next <= r_reg;
	end if;
	end process;

	-- output logic
	q <= std_logic_vector(r_next);

	max_tick <= '1' when r_reg=(2**N - 1) else '0';
end arch;
