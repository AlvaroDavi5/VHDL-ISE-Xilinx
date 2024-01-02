
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    port (
        sw : in std_logic_vector(8 downto 0); -- 9 switches
        led : out std_logic_vector(4 downto 0) -- 5 leds
    );
end top;

architecture arch of top is
    signal num1, num2, num2_res : std_logic_vector(3 downto 0);
    signal carry, result : std_logic_vector(3 downto 0);
begin

    num1 <= sw(3 downto 0);
    num2 <= sw(7 downto 4);

    mux : entity work.mux(arch)
        port map(
            v1 => num2,
            v2 => num2,
            op => sw(8),
            res => num2_res
        );

    fa0 : entity work.full_adder(arch)
        port map(
            a => num1(0),
            b => num2_res(0),
            ci => sw(8),
            s => result(0),
            co => carry(0)
        );

    fa1 : entity work.full_adder(arch)
        port map(
            a => num1(1),
            b => num2_res(1),
            ci => carry(0),
            s => result(1),
            co => carry(1)
        );

    fa2 : entity work.full_adder(arch)
        port map(
            a => num1(2),
            b => num2_res(2),
            ci => carry(1),
            s => result(2),
            co => carry(2)
        );

    fa3 : entity work.full_adder(arch)
        port map(
            a => num1(3),
            b => num2_res(3),
            ci => carry(2),
            s => result(3),
            co => carry(3)
        );

    led(3 downto 0) <= result;
    led(4) <= ((not num1(3) and not num2_res(3) and result(3)) or (num1(3) and num2_res(3) and not result(3)));

end arch;
