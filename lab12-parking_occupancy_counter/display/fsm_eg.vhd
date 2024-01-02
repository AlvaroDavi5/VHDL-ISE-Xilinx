library ieee;
use ieee.std_logic_1164.all;
entity fsm_display is
   port(
      clk, reset : in  std_logic;
      enable     : in std_logic;
      an         : out  std_logic_vector(7 downto 0);
      sseg       : out std_logic_vector(7 downto 0)
   );
end fsm_display;

architecture display_arch of fsm_display is
   type eg_state_type is (s0, s1, s2, s3, s4, s5, s6, s7);
   signal state_reg, state_next : eg_state_type;
begin
   -- state register
   process(clk, reset)
   begin
      if (reset = '1') then
         state_reg <= s0;
      elsif (clk'event and clk = '1') then -- clock rising edge
         if (enable = '1') then
            state_reg <= state_next; -- state change
         end if;
      end if;
   end process;
   -- next-state logic
   process(state_reg)
   begin
      case state_reg is
         when s0 =>
               state_next <= s1;
         when s1 =>
                  state_next <= s2;
         when s2 =>
                  state_next <= s3;
         when s3 =>
                  state_next <= s4;
         when s4 =>
                  state_next <= s5;
         when s5 =>
                  state_next <= s6;
         when s6 =>
                  state_next <= s7;
         when s7 =>
                  state_next <= s0;
      end case;
   end process;
   -- Moore output logic
   process(state_reg)
   begin
      case state_reg is
         when s0 =>
            an   <= "11111110";
            sseg <= "11111000";
         when s1 =>
            an   <= "11111101";
            sseg <= "10000010";
         when s2 =>
            an   <= "11111011";
            sseg <= "10010010";
         when s3 =>
            an   <= "11110111";
            sseg <= "10011001";
         when s4 =>
            an   <= "11101111";
            sseg <= "10110000";
         when s5 =>
            an   <= "11011111";
            sseg <= "10100100";
         when s6 =>
            an   <= "10111111";
            sseg <= "11111001";
         when s7 =>
            an   <= "01111111";
            sseg <= "11000000";
      end case;
   end process;
end display_arch;
