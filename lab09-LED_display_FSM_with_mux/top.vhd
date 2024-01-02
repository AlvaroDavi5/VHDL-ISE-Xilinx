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
begin
mux : entity work.led_mux8
      port map(
                clk    => clk,
                reset  => '0',
                in7    => "11000000",
                in6    => "11111001",
                in5    => "10100100",
                in4    => "10110000",
                in3    => "10011001",
                in2    => "10010010",
                in1    => "10000010",
                in0    => "11111000",
                an     => an,
                sseg   => sseg
     );

end arch;
