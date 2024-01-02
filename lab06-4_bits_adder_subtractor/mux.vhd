library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux is
    port (
        v1, v2 : in std_logic_vector(3 downto 0);
        op : in std_logic;
        res : out std_logic_vector(3 downto 0)
    );
end mux;

architecture arch of mux is
    signal v2_comp : std_logic_vector(3 downto 0);
begin
    v2_comp <= not v2;

    process(op) begin
        case op is
            when '1' => -- subtracton
                res <= v2_comp;
            when others => -- adition
            res <= v1;
        end case;
    end process;
end arch;
