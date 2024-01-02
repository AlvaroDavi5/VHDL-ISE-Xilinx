
--                  3-Bit Shifter with Multiplexers and Priority Encoder
-- authors: Álvaro Davi Santos Alves & Gabriel Saymon da Conceição
-- professor: Anselmo Frizera Neto
-- class: 05.2N


-- import libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- declares entity
entity main is
	port(
		sw : in  std_logic_vector(7 downto 0); -- 8 switches
		led : out std_logic_vector(15 downto 0) -- 3 LEDs
	);
end main;


-- build architecture (behavioral)
architecture arch of main is
	-- signals (variables)
	signal control : std_logic_vector(2 downto 0);
	signal c_out : std_logic_vector(1 downto 0);
	signal in2, in1, in0 : std_logic_vector(3 downto 0);
begin

	-- control switches
	control(2) <= sw(7);
	control(1) <= sw(6);
	control(0) <= sw(5);

	-- priority encoder
	priority_encoder : entity work.prio_encoder(case_arch)
		port map(
			shift => control,
			code => c_out
		);

	-- priority encoder output feedback
	led(15) <= c_out(1);
	led(14) <= c_out(0);

	-- data switches:
	--		X3  = sw(4)
	--		X2  = sw(3)
	--		X1  = sw(2)
	--		X0  = sw(1)
	--		X-1 = sw(0)

	in2(3) <= sw(4); -- shift right
	in2(2) <= sw(1); -- circular shift right
	in2(1) <= sw(2); -- shift left
	in2(0) <= sw(3); -- do nothing
	-- most significant mux
	mux2 : entity work.mux4(case_arch)
		port map(
			x => in2,
			c => c_out,
			y => led(2) -- most significant LED
		);

	in1(3) <= sw(3); -- shift right
	in1(2) <= sw(3); -- circular shift right
	in1(1) <= sw(1); -- shift left
	in1(0) <= sw(2); -- do nothing
	-- middle mux
	mux1 : entity work.mux4(case_arch)
		port map(
			x => in1,
			c => c_out,
			y => led(1) -- middle LED
		);

	in0(3) <= sw(2); -- shift right
	in0(2) <= sw(2); -- circular shift right
	in0(1) <= sw(0); -- shift left
	in0(0) <= sw(1); -- do nothing
	-- less significant mux
	mux0 : entity work.mux4(case_arch)
		port map(
			x => in0,
			c => c_out,
			y => led(0) -- less significant LED
		);

end arch;

