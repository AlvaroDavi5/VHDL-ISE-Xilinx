
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity full_adder is
    port (
        a, b, ci : in std_logic;
        s, co : out std_logic
    );
end full_adder;

architecture arch of full_adder is
    signal result, carry_out : std_logic;
begin
    adder : entity work.adder(arch)
        port map(
            a => a,
            b => b,
            s => result,
            co => carry_out
        );

    s <= result xor ci;
    co <= carry_out or (result and ci);    

end arch;
