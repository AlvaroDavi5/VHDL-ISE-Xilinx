-- import libraries
library ieee;
use ieee.std_logic_1164.all;


-- declares entity
entity prio_encoder is
	port(
		shift : in std_logic_vector(2 downto 0); -- 2: shift right, 1: circular shift right, 0: shift left
		code: out std_logic_vector(1 downto 0) -- output
	);
end prio_encoder; -- parse 3 bits code (8 possibilities) to 2 bits code (4 possibilities)


-- build architecture
architecture case_arch of prio_encoder is
begin
	process(shift)
	begin
		-- the most significant bit has priority over the others
		case shift is
			when "100" | "101" | "110" | "111" => -- 4,5,6,7
				code <= "11"; -- 3
			when "010" | "011" => -- 2,3
				code <= "10"; -- 2
			when "001" => -- 1
				code <= "01"; -- 1
			when others => -- 0
				code <= "00"; -- 0
		end case;
	end process;
end case_arch;
