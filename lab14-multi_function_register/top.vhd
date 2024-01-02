library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity top is
	port (
		sw : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		led : out std_logic_vector(3 downto 0)
	);
end top;

architecture arch of top is
	signal enable : std_logic;
	signal SHR_in, cLD, cINC, CSHR : std_logic;
	signal code : std_logic_vector(2 downto 0);
	signal code_out : std_logic_vector(1 downto 0);
	signal mi0, mi1, mi2, mi3 : std_logic_vector(3 downto 0);
	signal mux_out : std_logic_vector(3 downto 0);
	signal ff_out : std_logic_vector(3 downto 0);
	signal inc_out : std_logic_vector(3 downto 0);
begin
    div_clk : entity work.div_clk
    port map(
        clk => clk, 
        en => enable
    );

    SHR_in <= sw(4);
    cLD <= sw(7);
    cINC <= sw(6);
    CSHR <= sw(5);
    code <= cLD & cINC & CSHR;
    prior_encoder : entity work.cod_prio
		port map(
			r => code, 
			pcode => code_out
		);


    mi0 <= sw(0) & inc_out(0) & ff_out(1) & ff_out(0);
	mux0 : entity work.mux_4x1
		port map(
			i => mi0, 
			c => code_out, 
			s => mux_out(0)
		);
    ff0 : entity work.FF_D
        port map(
            D => mux_out(0), 
            e => enable, 
            clk => clk,
            Q => ff_out(0)
        );

    mi1 <= sw(1) & inc_out(1) & ff_out(2) & ff_out(1);
	mux1 : entity work.mux_4x1
		port map(
			i => mi1, 
			c => code_out, 
			s => mux_out(1)
		);
    ff1 : entity work.FF_D
        port map(
            D => mux_out(1), 
            e => enable, 
            clk => clk,
            Q => ff_out(1)
        );

    mi2 <= sw(2) & inc_out(2) & ff_out(3) & ff_out(2);
	mux2 : entity work.mux_4x1
		port map(
			i => mi2, 
			c => code_out, 
			s => mux_out(2)
		);
    ff2 : entity work.FF_D
        port map(
            D => mux_out(2), 
            e => enable, 
            clk => clk,
            Q => ff_out(2)
        );

    mi3 <= sw(3) & inc_out(3) & SHR_in & ff_out(3);
	mux3 : entity work.mux_4x1
		port map(
			i => mi3, 
			c => code_out, 
			s => mux_out(3)
		);
    ff3 : entity work.FF_D
        port map(
            D => mux_out(3), 
            e => enable, 
            clk => clk,
            Q => ff_out(3)
        );


    inc : entity work.inc_4bits
    port map(
        inc_in => ff_out, 
        inc_out => inc_out
    );


    led <= ff_out;
end arch;