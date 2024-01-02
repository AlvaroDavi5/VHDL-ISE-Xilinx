-- TODO: testar display
library ieee;
use ieee.std_logic_1164.all;


entity top is
	port (
        clk  : in std_logic;
        btn  : in std_logic_vector(3 downto 1);
        led  : out std_logic_vector(2 downto 0);
        an   : out std_logic_vector(3 downto 0);
        sseg : out std_logic_vector(7 downto 0)
    );
end top;

architecture arch of top is
	signal btn0, btn1, reset_btn : std_logic;
	signal join, quit, max_tick : std_logic;
	signal result : std_logic_vector(3 downto 0);
begin
	reset_btn <= btn(2);

    -- debouncing
    db0: entity work.debounce
    port map(
        sw => btn(3),
        db => btn0,
        clk => clk,
        reset => reset_btn
    );
    db1: entity work.debounce
    port map(
        sw => btn(1),
        db => btn1,
        clk => clk,
        reset => reset_btn
    );

	-- finite state machine
	fsm: entity work.fsm
	port map(
		a => btn0,
		b => btn1,
		car_enter => join,
		car_exit => quit,
		clk => clk,
		reset => reset_btn,
		enable => '1'
	);

	-- parking counter
	counter: entity work.counter
	port map(
		clk => clk,
		reset => reset_btn,   
		enable => '1',   
		inc => join,
		dec => quit,
		q => result,
		max_tick => max_tick
    );

	-- display
	display_mux: entity work.disp_hex_mux
	port map(
		clk => clk,
		reset => reset_btn,   
		hex0 => result,
		hex1 => result,
		hex2 => result,
		hex3 => result,
		an => an,
		sseg => sseg
	);

	led(0) <= max_tick;
end arch;
