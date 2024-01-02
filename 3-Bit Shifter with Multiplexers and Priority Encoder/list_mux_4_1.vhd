-- import libraries
library ieee;
use ieee.std_logic_1164.all;


-- declares entity
entity mux4 is
	port(
		x: in std_logic_vector(3 downto 0); -- inputs: X3, ... , X0
		c: in std_logic_vector(1 downto 0); -- control: C1, C0
		y: out std_logic -- output
	);
end mux4; -- sets input value to return to output based on control value


-- build architecture
architecture case_arch of mux4 is
begin
	process(x, c)
	begin
		-- higher binary values ​​make mux return the most significant bit
		case c is
			when "00" => -- 0
				y <= x(0); -- less significant
			when "01" =>
				y <= x(1);
			when "10" =>
				y <= x(2);
			when others => -- 3
				y <= x(3); -- most significant
		end case;
	end process;
end case_arch;
