library ieee;
use ieee.std_logic_1164.all;
entity eq_top is
   port(
      sw  : in  std_logic_vector(7 downto 0); --8 switches
      led : out std_logic_vector(7 downto 0) -- 8 red LEDs
   );
end eq_top;

architecture struc_arch of eq_top is
begin
   -- instantiate 2-bit comparator
   encoder : entity work.prio_encoder(if_arch)
      port map(
         r => sw(4 downto 1),
         pcode => led(2 downto 0)
      );

   decoder : entity work.decoder_2_4(if_arch)
      port map(
        a => sw(6 downto 5),
        en => sw(7),
        y => led(7 downto 4)
      );

end struc_arch;
