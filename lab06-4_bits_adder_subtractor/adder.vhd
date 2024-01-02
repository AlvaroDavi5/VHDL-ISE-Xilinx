
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity adder is
    port(
        a, b : in std_logic;
        co, s : out std_logic
    );
end adder;

architecture arch of adder is
begin
    s <= a xor b;
    co <= a and b;
end arch;
