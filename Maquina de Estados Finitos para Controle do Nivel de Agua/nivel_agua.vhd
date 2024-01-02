
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity nivel_agua is
	Port (
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		cf : in STD_LOGIC;
		ca : in STD_LOGIC;
		nmin : in STD_LOGIC;
		nmax : in STD_LOGIC;
		start : in STD_LOGIC;
		stop : in STD_LOGIC;
		m1, m0 : out STD_LOGIC
	);
end nivel_agua;

architecture Behavioral of nivel_agua is
	type state_type is (
		PARADO,
		ABRINDO,
		FECHANDO
	);
	signal state_reg, state_next: state_type;
begin
	-- process sequencial: criao de memria 
	process(clk, reset)
	begin
		if reset = '1' then 
			state_reg <= PARADO;
		elsif clk' event and clk='1' then
			state_reg <= state_next;
		end if;
	end process;
	-- process combinacional 
	process(start, stop, nmax, nmin, ca, cf)
	begin
		case state_reg is
			when PARADO =>
				if (nmin = '1' and ca = '0') then
					state_next <= ABRINDO;
				elsif ((start = '1' or stop = '1' or nmax = '1') and cf = '0') then
					state_next <= FECHANDO;
				else
					state_next <= PARADO;
				end if;
			when ABRINDO =>
				if (start = '1' or stop = '1' or nmax = '1') then
					state_next <= FECHANDO;
				elsif (nmax = '0' and ca = '1') then
					state_next <= PARADO;
				else
					state_next <= ABRINDO;
				end if;
			when FECHANDO =>
				if (nmin = '1') then
					state_next <= ABRINDO;
				elsif ((stop = '1' or nmin = '0') and cf = '1') then
					state_next <= PARADO;
				else
					state_next <= FECHANDO;
				end if;
			when others =>
				state_next <= state_reg;
		end case;
		case state_reg is
			when PARADO =>
				m1 <= '0';
				m0 <= '0';
			when ABRINDO =>
				m1 <= '0';
				m0 <= '1';
			when FECHANDO =>
				m1 <= '1';
				m0 <= '0';
		end case;
	end process;
end Behavioral;

