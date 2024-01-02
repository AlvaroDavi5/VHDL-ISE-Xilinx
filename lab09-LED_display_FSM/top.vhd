library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
          clk   : in STD_LOGIC;
          an    : out std_logic_vector(7 downto 0);
          sseg  : out std_logic_vector(7 downto 0)
    );
end top;

architecture arch of top is
    constant N : integer := 999999999; 
    signal enable : std_logic;
    signal divide_clk : integer range 0 to N;
begin
mux : entity work.fsm_eg
      port map(
                clk    => clk,
                reset  => '0',
                enable => enable,
                an     => an,
                sseg   => sseg
     );

     enable <= '1' when divide_clk = N else '0';

     PROCESS (clk)
        BEGIN
            IF (clk'EVENT AND clk='1') THEN
                divide_clk <= divide_clk+1;
                IF divide_clk = N THEN
                    divide_clk <= 0;
                END IF;
            END IF;
     END PROCESS;

end arch;
