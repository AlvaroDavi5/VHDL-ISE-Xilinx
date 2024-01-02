library IEEE; -- library require
use IEEE.STD_LOGIC_1164.ALL; -- library import


-- entity model
entity xnor_gate is
	port (
		in1, in2 : in std_logic;
		out1 : out std_logic
	); -- entity ports
end xnor_gate;


-- circuit architecture
architecture test of xnor_gate is
	signal a : std_logic;
	signal b : std_logic;
	signal r1 : std_logic;
	signal r2 : std_logic;
begin
	a <= '0';
	b <= '0';

	r1 <= (a or b);
	r2 <= ((not a) or (not b));
	out1 <= r1 and r2;
end test;
